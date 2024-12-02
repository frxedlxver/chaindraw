class_name CardFactory

static var card_scene : PackedScene = preload("res://pfbs/card.tscn")

static var next_id : int = 0
static var used_ids : Array[int] = []

static func create_card(card_logic_type) -> CardNode:
	var card : CardNode = card_scene.instantiate()
	card.card_base = card_logic_type.new(get_next_card_id())
	return card
	
static func get_next_card_id() -> int:
	var result = next_id;
	used_ids.append(next_id)
	next_id += 1
	while(next_id in used_ids):
		next_id += 1
	return result

static func load_card_from_save_data(card_data_dict : Dictionary) -> CardNode:
	var card : CardNode = card_scene.instantiate()
	var card_logic_path = card_data_dict.get("logic_script_path")
	card.card_base = load(card_logic_path).new(CardFactory.get_next_card_id())
	print(card.card_base.get_class())
	used_ids.append(card.card_base.id)
	card.card_base.metadata = card_data_dict.get("metadata")
	card.card_base.next_in_chain = card_data_dict.get("bonded_to")
	return card

static func convert_to_saveable(card : CardNode):
	var card_logic = card.card_base
	var card_data_dict = {
		"id" : card_logic.id,
		"logic_script_path" : card_logic.get_script().resource_path,
		"bonded_to" : card_logic.next_in_chain,
		"metadata": card_logic.metadata
	}
	return card_data_dict

static func convert_deck_to_saveable(deck : Deck) -> Array:
	var card_data_array : Array = []
	for card : CardNode in deck.cards:
		var card_data_to_save : Dictionary = CardFactory.convert_to_saveable(card)
		card_data_array.append(card_data_to_save)
	return card_data_array

static func load_deck_from_save_data(card_data_array : Array):
	var cards : Array[CardNode]
	
	for card_data : Dictionary in card_data_array:
		var card : CardNode = load_card_from_save_data(card_data)
		cards.append(card)
	
	return cards
		
