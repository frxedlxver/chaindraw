class_name CardFactory

static var card_scene : PackedScene = preload("res://pfbs/card.tscn")

static var next_id : int = 0

static func create_card(card_logic_type) -> CardNode:
	var card : CardNode = card_scene.instantiate()
	card.card_base = card_logic_type.new()
	return card
