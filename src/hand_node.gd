extends Control
class_name HandNode

# Signal emitted when a card in the hand is clicked
signal card_clicked(card_node: CardNode)

@export var hand_radius: int = 200:
	set(value):
		hand_radius = value
		if debug_shape and debug_shape.shape is CircleShape2D:
			debug_shape.shape.radius = value

@export var hand_x_stretch: float = 1.0
@export var hand_y_stretch: float = 1.0

@export var debug_shape: CollisionShape2D
@onready var hand = Hand.new()
@export var max_card_spread_angle: float = 1
@export var max_spread_total: float = 200

const HAND_CENTER_ANGLE_IN_DEG: float = -90

func add_card(card_to_add: CardNode) -> bool:
	# Add card to hand data object
	hand.add_card(card_to_add)
	# Connect signals
	card_to_add.card_clicked.connect(_on_card_clicked)
	# Add the card to the scene tree
	add_child(card_to_add)
	print("Adding card with ID %d" % card_to_add.card_base.id)
	# Update card positions and rotation
	reposition_cards()
	return true

func _on_card_clicked(card_node: CardNode):
	# Emit signal to notify that a card has been clicked
	card_clicked.emit(card_node)

func reposition_cards():
	# Calculate spread angle per card, constrained by max spread and max angle
	var card_spread: float = min(max_spread_total / hand.card_count, max_card_spread_angle)
	# Calculate total spread to center cards around HAND_CENTER_ANGLE_IN_DEG
	var total_spread = card_spread * (hand.card_count - 1)
	var start_angle = HAND_CENTER_ANGLE_IN_DEG - (total_spread / 2)
	# Position each card around the calculated starting angle
	for i in range(hand.card_count):
		var current_angle = start_angle + i * card_spread
		var card = hand.cards.values()[i]
		update_card_transform(card, current_angle)

func take_card_by_entity(card_node: CardNode) -> CardNode:
	var id = card_node.card_base.id
	var index = hand.cards.keys().find(id)
	var card_with_id = take_card(index)
	return card_with_id

func take_card(index: int) -> CardNode:
	var result = hand.pop_at_index(index)
	result.card_clicked.disconnect(_on_card_clicked)
	remove_child(result)
	reposition_cards()
	return result

func calculate_card_position(angle_in_deg: float) -> Vector2:
	var angle_in_rad = deg_to_rad(angle_in_deg)
	var x: float = hand_radius * cos(angle_in_rad) * hand_x_stretch
	var y: float = hand_radius * sin(angle_in_rad) * hand_y_stretch
	return Vector2(x, y)

func _process(_delta: float) -> void:
	# Update the debug shape radius if necessary
	if debug_shape and debug_shape.shape is CircleShape2D:
		(debug_shape.shape as CircleShape2D).radius = hand_radius

func update_card_transform(card_node: CardNode, card_angle: float):
	card_node.reposition(
		calculate_card_position(card_angle),
		card_angle + 90
	)
	card_node.angle_in_hand = card_angle + 90
