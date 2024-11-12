class_name Hand extends RefCounted

var cards : Dictionary = {}

var max_hand_size : int = 1000
var card_count : int:
	get: return cards.values().size()


func is_full() -> bool:
	return card_count >= max_hand_size

# returns true if card added successfully, else false
func add_card(card_with_id : CardWithID) -> bool:
	if card_count >= max_hand_size:
		return false
	
	cards[card_with_id.card_id] = card_with_id
	return true

func remove_at(index : int):
	# index oob, return false
	if cards.keys().size() <= index:
		return false
	
	# get key of target
	var to_remove_key = cards.keys()[index]
	# cache target card to return it
	var to_remove : CardWithID = cards.get(to_remove_key)
	
	# remove from hand and return card
	cards.erase(to_remove_key)
	return to_remove
	
# returns card if removed successfully, else false
func remove_card_by_id(card_id : int):
	if !cards.has(card_id):
		return false
	
	var to_remove = cards.get(card_id)
	cards.erase(card_id)
	
	return to_remove

# returns -1 if card not found in hand
func get_card_id_if_exists(card_node : CardNode) -> int:
	for card_with_id : CardWithID in cards.values():
		if card_with_id.card == card_node:
			return card_with_id.card_id
	return -1