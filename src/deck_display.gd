class_name DeckDisplayPanel extends Panel

@export var  card_container : GridContainer
static var DISPLAY_CARD_PFB : PackedScene = preload("res://assets/pfbs/display_card.tscn")
const CARD_SIZE : Vector2i = Vector2i(220,300)
@export var debug : bool = false

func update_card_display(card_array : Array[CardNode]):
	var column_count = floor(self.size.x / CARD_SIZE.x)
	
	for child in card_container.get_children():
		child.queue_free()
	
	card_container.columns = column_count
	
	var display_card_array : Array[DisplayCardNode] = []
	for card : CardNode in card_array:
		var display_card : DisplayCardNode = DISPLAY_CARD_PFB.instantiate()
		display_card.create_from_card_node(card)
		display_card_array.append(display_card)
		
	display_card_array.shuffle()
	
	for display_card :  DisplayCardNode in display_card_array:
		card_container.add_child(display_card)
