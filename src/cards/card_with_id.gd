class_name CardWithID extends RefCounted

var card : CardNode
var card_id : int

func _init(card_node : CardNode, id : int):
	self.card = card_node
	self.card_id = id
