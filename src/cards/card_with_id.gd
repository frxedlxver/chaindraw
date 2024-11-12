class_name CardWithID extends RefCounted

var card : CardNode
var card_id : int

func _init(card : CardNode, id : int):
	self.card = card
	self.card_id = id
