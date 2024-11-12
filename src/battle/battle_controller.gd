extends Node
class_name BattleController

# Enumeration for the different phases of the battle
enum BattlePhase {
	PLAYER_TURN,
	TARGETING,
	ENEMY_TURN,
	VICTORY,
	DEFEAT
}

signal exit_battle_phase(BattlePhase)
signal enter_battle_phase(BattlePhase)

# Current phase of the battle
var phase: BattlePhase

# Data container for the battle, including player and enemies
var battle_data: BattleData

# Reference to the player's hand UI component
@export var hand: HandNode

# The card currently being played
var active_card: CardNode

# Manages target selection during the targeting phase
var target_selector: TargetSelector

func initialize_battle(player: Player, enemies: Array[Enemy]):
	self.hand = hand
	battle_data = BattleData.new(player, enemies)

	# Initialize the target selector with the list of enemies
	target_selector = TargetSelector.new(battle_data.enemies)
	self.add_child(target_selector)

	# Connect the card activation signal from the hand to the handler
	hand.card_activated.connect(_on_hand_card_activated)
	$EnemyContainer.set_enemy_positions(enemies.size())
	for enemy in enemies:
		$EnemyContainer.add_enemy(enemy)

# Starts the battle by setting the initial phase
func start_battle():
	set_phase(BattlePhase.PLAYER_TURN)

############ PHASE FUNCTIONS ############

# Sets the current phase of the battle
func set_phase(new_phase: BattlePhase):
	# Exit the current phase
	exit_phase(phase)
	# Update to the new phase
	phase = new_phase
	# Enter the new phase
	enter_phase(phase)

# Handles entering a new phase
func enter_phase(new_phase: BattlePhase):
	match new_phase:
		BattlePhase.PLAYER_TURN:
			# Player's turn begins
			battle_data.player.on_turn_start()
		BattlePhase.ENEMY_TURN:
			# Each enemy's turn begins
			for enemy in battle_data.enemies:
				enemy.on_turn_start()
		BattlePhase.VICTORY:
			# Victory state logic
			pass
		BattlePhase.DEFEAT:
			# Defeat state logic
			pass
	enter_battle_phase.emit(new_phase)

# Handles exiting the current phase
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

# Processes logic each frame based on the current phase
func _process(delta: float) -> void:
	match phase:
		BattlePhase.PLAYER_TURN:
			# Logic for player's turn (if any)
			pass
		BattlePhase.ENEMY_TURN:
			set_phase(BattlePhase.PLAYER_TURN)
		BattlePhase.VICTORY:
			# Logic during victory state
			pass
		BattlePhase.DEFEAT:
			# Logic during defeat state
			pass

############ EVENT HANDLERS ############

# Called when a card is activated from the player's hand
func _on_hand_card_activated(card_node: CardNode):
	# Check if the player has enough energy to use the card
	if battle_data.player.energy < card_node.card_base.cardData.cost:
		# Not enough energy; flash the card red
		card_node.flash_red()
		return

	# Set the active card to the one played
	active_card = card_node

	# Check if the card requires target selection
	if card_node.card_base.cardData.target_type == CardData.TargetType.SINGLE_ENEMY:
		# Enter target selection mode
		_do_target_selection(card_node)
	else:
		# No target required; activate the card immediately
		_use_card(card_node)

# Initiates target selection mode for the card
func _do_target_selection(card_node: CardNode):
	# Activate the target selector with the current card
	target_selector.activate(card_node)
	# Connect signals for target selection and cancellation
	target_selector.target_selected.connect(_on_card_target_selected)
	target_selector.clicked_outside_target.connect(_exit_target_selection)

# Called when a target is selected
func _on_card_target_selected(target: Enemy):
	# Set the current target in battle data
	battle_data.cur_target = target_selector.cur_target
	# Use the active card on the selected target
	_use_card(active_card)
	# Exit target selection mode
	_exit_target_selection()

# Activates the card's effect and removes it from the hand
func _use_card(card_node: CardNode):
	# Activate the card with the battle data context
	card_node.activate(battle_data)
	# Remove the card from the player's hand
	var id = hand.hand.get_card_id_if_exists(active_card)
	var index = hand.hand.cards.keys().find(id)
	var card = hand.take_card(index)
	# Free the card node to remove it from the scene
	card.card.queue_free()
	# Clear the active card reference
	active_card = null

# Exits target selection mode and disconnects signals
func _exit_target_selection():
	# Deactivate the target selector
	target_selector.deactivate()
	# Disconnect the signals to prevent multiple connections
	target_selector.target_selected.disconnect(_on_card_target_selected)
	target_selector.clicked_outside_target.disconnect(_exit_target_selection)
	
func _end_turn_button_pressed():
	if phase == BattlePhase.PLAYER_TURN:
		set_phase(BattlePhase.ENEMY_TURN)
