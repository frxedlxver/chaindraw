class_name Hand extends RefCounted

var cards : Dictionary = {}

var max_hand_size : int = 1000
var card_count : int:
	get: return cards.values().size()

# returns true if card added successfully, else false
func add_card(card_node : CardNode) -> bool:
	if card_count >= max_hand_size:
		return false
	
	cards[card_node.card_base.id] = card_node
	return true

func pop_at_index(index : int):

	
	# get key of target
	var to_remove_key = cards.keys()[index]
	# cache target card to return it
	var to_remove : CardNode = cards.get(to_remove_key)
	
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
