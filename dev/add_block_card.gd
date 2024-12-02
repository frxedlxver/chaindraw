extends Button

var hand : HandNode:
	get: return self.get_parent_control().get_parent_control().hand
var deck : Deck:
	get: return self.get_parent_control().get_parent_control().deck

func _pressed() -> void:
	var card = CardFactory.create_card(Block)
	hand.add_card(card)
