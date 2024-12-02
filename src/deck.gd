class_name Deck extends RefCounted

var cards : Dictionary = {}

func add_card(card : CardNode):
	cards[card.card_base.id] = card

func remove_card(card_id : int):
	cards.erase(card_id)

func transform_card(new_card : CardNode):
	cards[new_card.card_base.card_id] = new_card
	
func get_card(card_id : int):
	if cards.has(card_id):
		return cards.get(card_id)

func get_cards() -> Array:
	return cards.values()
	
func card_count() -> int:
	return cards.values().size()
