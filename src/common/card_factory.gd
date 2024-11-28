class_name CardFactory

static var card_scene : PackedScene = preload("res://pfbs/card.tscn")

static var next_id : int = 0

static func create_card(card_logic_type) -> CardNode:
	var card : CardNode = card_scene.instantiate()
	card.card_base = card_logic_type.new()
	return card
	
static func get_next_card_id() -> int:
	var result = next_id;
	next_id += 1
	return result
