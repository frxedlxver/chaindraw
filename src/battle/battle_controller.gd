extends Node
class_name BattleController

# Enumeration for the different phases of the battle
enum BattlePhase {
	START,
	PLAYER_TURN,
	ENEMY_TURN,
	VICTORY,
	DEFEAT
}

signal exit_battle_phase(old_phase: BattlePhase)
signal enter_battle_phase(new_phase: BattlePhase)

# Current phase of the battle
var phase: BattlePhase
var battle_data: BattleData
@export var hand : HandNode
@export var deck_handle : DeckHandle
@export var discard_handle : DeckHandle
@export var target_selector: TargetSelector
@export var end_turn_button : Button

# The card currently being played (used when targeting)
var active_card: CardNode = null

func initialize_battle(player: Player, enemies: Array[Enemy]):
	battle_data = BattleData.new(player, enemies)
	battle_data.player.dead.connect(_on_player_dead)
	battle_data.battle_deck = deck_handle

	# Initialize the target selector with the list of enemies
	target_selector.initialize(battle_data.enemies)

	# Connect the card clicked signal from the hand to the handler
	hand.card_clicked.connect(_on_card_clicked)

	# Set enemy positions and add them to the scene
	$EnemyContainer.set_enemy_positions(enemies.size())
	
	for enemy in enemies:
		$EnemyContainer.add_enemy(enemy)
		enemy.dead.connect(_on_enemy_dead)

func start_battle():
	set_phase(BattlePhase.START)


############ PHASE FUNCTIONS ############

func set_phase(new_phase: BattlePhase):
	# Exit the current phase
	exit_phase(phase)
	# Update to the new phase
	phase = new_phase
	# Enter the new phase
	enter_phase(phase)

func enter_phase(new_phase: BattlePhase):
	match new_phase:
		BattlePhase.START:
			battle_data.player.on_battle_start()
			
			# initialize battledeck with info from player's main deck
			battle_data.battle_deck.on_battle_start(battle_data.player.deck)
			set_phase(BattlePhase.PLAYER_TURN)
		BattlePhase.PLAYER_TURN:
			
			# timer for small delay between each card drawn
			var t = Timer.new()
			self.add_child(t)
			
			# draw from deck until hand is full
			while (hand.hand.card_count < battle_data.player.max_hand_size):
				
				# handle empty deck
				if battle_data.battle_deck.card_count == 0:
					# will change this behavior eventually
					break;
				
				# 
				hand.add_card(battle_data.battle_deck.draw_from_top())
				t.wait_time = 0.1
				t.start()
				await t.timeout
			
			# free the timer
			self.remove_child(t)
			t.queue_free()
			
			end_turn_button.disabled = false
				
			battle_data.player.on_turn_start()
		BattlePhase.ENEMY_TURN:
			# Each enemy's turn begins
			for enemy in battle_data.enemies:
				enemy.on_turn_start()
			for enemy : Enemy in battle_data.enemies:
				enemy.do_turn(battle_data)
				if enemy.turn_in_progress:
					await enemy.turn_finished
			set_phase(BattlePhase.PLAYER_TURN)
		BattlePhase.VICTORY:
			# Victory state logic
			pass
		BattlePhase.DEFEAT:
			# Defeat state logic
			pass
	enter_battle_phase.emit(new_phase)

func exit_phase(old_phase: BattlePhase):
	match old_phase:
		BattlePhase.PLAYER_TURN:
			# Player's turn ends
			battle_data.player.on_turn_end()
		BattlePhase.ENEMY_TURN:
			# Each enemy's turn ends
			for enemy in battle_data.enemies:
				enemy.on_turn_end()
		BattlePhase.VICTORY:
			# Cleanup after victory
			pass
		BattlePhase.DEFEAT:
			# Cleanup after defeat
			pass
	exit_battle_phase.emit(old_phase)

func _process(_delta: float) -> void:
	match phase:
		BattlePhase.PLAYER_TURN:
			# Logic for player's turn (if any)
			pass
		BattlePhase.ENEMY_TURN:
			# Logic for enemy's turn
			pass
		BattlePhase.VICTORY:
			# Logic during victory state
			pass
		BattlePhase.DEFEAT:
			# Logic during defeat state
			pass

############ EVENT HANDLERS ############

func _on_card_clicked(card_node: CardNode):
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
	if card_node.card_base.next_in_chain != -1:
		var card : CardNode = deck_handle.find_card_by_id(card_node.card_base.next_in_chain)
		if !card:
			card = deck_handle.find_card_by_id(card_node.card_base.next_in_chain)
		if !card:
			pass # check hand for card
		if !card:
			print("could not find card with id %d" % card_node.card_base.next_in_chain)
		else:
			card.chain_effects = card_node.card_base.cardData.chain_effects_to_pass
			card.drawn_via_chain = true
			hand.add_card(card)
	# Remove the card from the player's hand
	hand.take_card_by_entity(card_node)
	# Clear the active card reference
	active_card = null

func _exit_target_selection():
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
	if battle_data.enemies.size() == 0:
		set_phase(BattlePhase.VICTORY)
		
func _on_player_dead():
	set_phase(BattlePhase.DEFEAT)

func _on_end_turn_button_pressed() -> void:
	if phase == BattlePhase.PLAYER_TURN:
		set_phase(BattlePhase.ENEMY_TURN)
	end_turn_button.disabled = true
