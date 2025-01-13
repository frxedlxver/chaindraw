class_name ATBController extends Node


var battle_data: BattleData
@export var hand : HandNode
@export var deck_handle : DeckHandle
@export var discard_handle : DeckHandle
@export var target_selector: TargetSelector
@export var player_turn_timer_ui : TurnTimerUI

@onready var player_turn_timer : TurnTimer = TurnTimer.new()
var enemy_turn_timers : Dictionary

# The card currently being played (used when targeting)
var active_card: CardNode = null
var card_deselction_buffer_time : float = 0.05
var time_since_card_deselected : float = 0.00
var wait_for_action : bool = false

var action_queue : Array[Callable]
var paused : bool:
	get: return _paused
	set(v):
		_paused = v
		if _paused:
			atb_paused.emit()
		else:
			atb_unpaused.emit()
var _paused : bool = false


signal victory()
signal defeat()
signal atb_paused()
signal atb_unpaused()


func initialize_battle(player: Player, enemies: Array[Enemy]):
	battle_data = BattleData.new(player, enemies)
	battle_data.player.dead.connect(_on_player_dead)
	battle_data.battle_deck = deck_handle
	deck_handle.on_battle_start(player.deck)

	# Initialize the target selector with the list of enemies
	target_selector.initialize(battle_data.enemies)

	# Connect the card clicked signal from the hand to the handler
	hand.card_clicked.connect(_on_card_clicked)

	# Set enemy positions and add them to the scene
	$EnemyContainer.set_enemy_positions(enemies.size())
	
	for enemy : Enemy in enemies:
		$EnemyContainer.add_enemy(enemy)
		enemy.dead.connect(_on_enemy_dead)
		enemy.turn_finished.connect(_on_enemy_turn_timer_finished)
		enemy.initialize_self()
		enemy.wait_for_action_event.connect(_on_wait_for_action_event_received)
		enemy.decide_starting_action(battle_data)
		
	player_turn_timer.max_time_changed.connect(player_turn_timer_ui._on_max_time_changed)
	player_turn_timer.time_changed.connect(player_turn_timer_ui._on_time_changed)
	player_turn_timer.timer_finished.connect(_on_player_turn_timer_finished)
	player_turn_timer.max_time = 4.0
	player.energy_changed.connect(_on_player_energy_changed)
	
	refill_player_hand()
	
func _input(event):
	if event.is_action_pressed("toggle_atb_pause"):
		self.paused = !self.paused
		

func refill_player_hand():
	while hand.hand.card_count < battle_data.player.max_hand_size and deck_handle.cards.size() > 0:
		hand.add_card(deck_handle.draw_from_top())
	
	hand.recheck_playable_cards(battle_data.player.energy)
		
func _process(delta : float):
	if can_do_next_action():
		var next_action = action_queue.pop_front()
		if next_action != null and next_action is Callable:
			next_action.call()
	
	if can_increment_timers():
		if battle_data.player.energy < battle_data.player.max_energy:
			player_turn_timer.increment(delta)
		battle_data.player._managed_process(delta)
		for enemy : Enemy in battle_data.enemies:
			enemy.managed_process(delta)
	
	if time_since_card_deselected < card_deselction_buffer_time:
		time_since_card_deselected += delta 

############ TIMER VERIFICATION ############

func can_increment_timers() -> bool:
	return (
		not wait_for_action \
		and not target_selector.is_targeting \
		and not paused
	)
	
func can_do_next_action() -> bool:
	return (
		not wait_for_action \
		and not target_selector.is_targeting \
		and not action_queue.is_empty() \
		and not paused
	)

############ EVENT HANDLERS ############
func _on_player_turn_timer_finished():
	action_queue.append(refill_player_hand)
	action_queue.append(func() : battle_data.player.gain_energy(1))
	action_queue.append(func() : battle_data.player.on_meter_full())

func _on_player_energy_changed(player_energy : int):
	if player_energy == 0:
		pass
	hand.recheck_playable_cards(player_energy)
	
func _on_enemy_turn_timer_finished(caller : Enemy):
	action_queue.append(func() : caller.do_turn(battle_data))
	action_queue.append(func() : caller.decide_next_action(battle_data))
	
func _on_wait_for_action_event_received(started : bool):
	if started:
		wait_for_action = true
	else:
		wait_for_action = false

func _on_card_clicked(card_node: CardNode):
	if time_since_card_deselected < card_deselction_buffer_time:
		return
	
	# Check if there is already an active card
	if active_card != null:
		return  # Ignore clicks when a card is active

	# Check if the player has enough energy to use the card
	if battle_data.player.energy < card_node.card_base.cardData.cost:
		# Not enough energy; flash the card red
		card_node.flash_red()
		return

	# Set the clicked card as active
	active_card = card_node
	card_node.select()

	# Proceed to target selection or use the card
	if card_node.card_base.cardData.target_type == CardData.TargetType.SINGLE_ENEMY:
		_do_target_selection(card_node)
	else:
		_use_card(card_node)

func _do_target_selection(card_node: CardNode):
	# Activate the target selector with the current card
	target_selector.activate(card_node)
	# Connect signals for target selection and cancellation
	target_selector.target_selected.connect(_on_card_target_selected)
	target_selector.clicked_outside_target.connect(_exit_target_selection)

func _on_card_target_selected(target: Enemy):
	# Set the current target in battle data
	battle_data.cur_target = target
	# Use the active card on the selected target
	_use_card(active_card)
	# Exit target selection mode
	_exit_target_selection()

func _use_card(card_node: CardNode):
	# Activate the card with the battle data context
	card_node.use(battle_data)
	# Deduct the card's cost from the player's energy
	battle_data.player.use_energy(card_node.cost)
	# Remove the card from the player's hand
	hand.take_card_by_entity(card_node)
	# Clear the active card reference
	active_card = null

func _exit_target_selection():
	time_since_card_deselected = 0.0
	# Deactivate the target selector
	target_selector.deactivate()
	# Deselect the active card
	if active_card:
		active_card.deselect()
		active_card = null
	# Disconnect the signals to prevent multiple connections
	target_selector.target_selected.disconnect(_on_card_target_selected)
	target_selector.clicked_outside_target.disconnect(_exit_target_selection)

func _on_enemy_dead(enemy : Enemy):
	var enemy_idx = battle_data.enemies.find(enemy)
	battle_data.enemies.remove_at(enemy_idx)
	enemy.queue_free()
	if battle_data.enemies.is_empty():
		victory.emit()
	
	
func _on_player_dead():
	defeat.emit()


func _on_battle_ui_manager_state_changed(new_state, old_state):
	match new_state:
		BattleUIManager.BattleUIState.NORMAL:
			paused = false
		BattleUIManager.BattleUIState.SHOWING_DECK:
			paused = true
