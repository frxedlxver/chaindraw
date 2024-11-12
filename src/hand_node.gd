@tool
class_name HandNode extends Control

signal card_activated(CardNode)

@export var hand_radius : int = 200:
	set(v):
		hand_radius = v
		if (debug_shape) and (debug_shape.shape is CircleShape2D):
			debug_shape.shape.radius = v
			
@export var hand_x_stretch : float = 1.0
@export var hand_y_stretch : float = 1.0

@export var debug_shape : CollisionShape2D
@onready var hand = Hand.new()
@export var max_card_spread_angle : float = 1
@export var max_spread_total : float = 200
var selected_card
const HAND_CENTER_ANGLE_IN_DEG : float = -90
var card : CardNode


func add_card(card_with_id : CardWithID) -> bool:
	# check hand data object to see if draw is possible
	if hand.is_full():
		return false
	# return false if card cannot be added
	# add card to hand data object
	hand.add_card(card_with_id)
	
	var card : CardNode = card_with_id.card
	
	#connect signals
	card.mouse_clicked.connect(on_card_clicked)
	card.mouse_entered_card.connect(on_mouse_enter_card)
	card.mouse_exited_card.connect(on_mouse_exit_card)
	# add physical card
	self.add_child(card_with_id.card)
	print("adding card with id %d" % card_with_id.card_id)
	# update card positions/rotation
	self.reposition_cards()
	return true

func on_card_clicked(cardnode : CardNode):
	var id : int = hand.get_card_id_if_exists(cardnode)
	if id != -1:
		var card_index = hand.cards.keys().find(id)
	
	# notify that card has been used
	self.card_activated.emit(cardnode)

func on_mouse_enter_card(card_node : CardNode):
	select_card(card_node)
	
func on_mouse_exit_card(card_node : CardNode):
	if card_node == selected_card:
		deselect_selected_card()

func select_card(card_node : CardNode):
	deselect_selected_card()
	selected_card = card_node
	card_node.highlight()

func deselect_selected_card():
	if selected_card != null and selected_card is CardNode:
		selected_card.remove_highlight()
	selected_card = null
	
func reposition_cards():
	# Calculate spread angle per card, constrained by max spread and max angle
	var card_spread : float = min(max_spread_total / hand.card_count, max_card_spread_angle)

	# Calculate total spread to center cards around HAND_CENTER_ANGLE_IN_DEG
	var total_spread = card_spread * (hand.card_count - 1)
	var start_angle = HAND_CENTER_ANGLE_IN_DEG - (total_spread / 2)

	# Position each card around the calculated starting angle
	for i in range(hand.card_count):
		var current_angle = start_angle + i * card_spread
		var card = hand.cards.values()[i].card
		update_card_transform(card, current_angle)


# removes card from hand and returns it
# returns false if card with id not found
func take_card(index : int):
	var result = hand.remove_at(index)
	if !result:
		return false
	if selected_card == result:
		deselect_selected_card()
	result.card.mouse_clicked.disconnect(on_card_clicked)
	self.remove_child(result.card)
	self.reposition_cards()
	return result

# calculates x and y position of card based on angle
func calculate_card_position(angle_in_deg : float) -> Vector2:
	var angle_in_rad = deg_to_rad(angle_in_deg)
	var x : float = hand_radius * cos(angle_in_rad) * hand_x_stretch
	var y : float = hand_radius * sin(angle_in_rad) * hand_y_stretch
	var pos : Vector2 = Vector2(x, y)
	return pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	(debug_shape.shape as CircleShape2D).radius = hand_radius
	
func update_card_transform(card_node : CardNode, card_angle : float):
	card_node.reposition(
		calculate_card_position(card_angle), 
		card_angle + 90
		)
