class_name Deck extends RefCounted

var cards : Dictionary = {}



var _id_counter : int = 0

func add_card(card : CardNode):
	var id = CardFactory.get_next_card_id()
	cards[id] = CardWithID.new(card, id)

func remove_card(card_id : int):
	cards.erase(card_id)

func update_card(card_with_id : CardWithID):
	cards[card_with_id.card_id] = card_with_id
	
func get_card(card_id):
	if cards.has(card_id):
		return cards.get(card_id)

func get_cards() -> Array:
	return cards.values()
	
func card_count() -> int:
	return cards.values().size()
