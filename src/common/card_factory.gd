class_name CardFactory

static var card_scene : PackedScene = preload("res://assets/pfbs/card.tscn")
static var next_id : int = 0
static var used_ids : Array[int] = []

static func create_card(card_logic_type) -> CardNode:
	var card : CardNode = card_scene.instantiate()
	card.card_base = card_logic_type.new(get_next_card_id())
	return card
	
static func get_next_card_id() -> int:
	var result = next_id
	used_ids.append(next_id)
	next_id += 1
	while(next_id in used_ids):
		next_id += 1
	return result

static func update_next_id_after_load(highest_loaded_id : int):
	if highest_loaded_id >= next_id:
		next_id = highest_loaded_id + 1
