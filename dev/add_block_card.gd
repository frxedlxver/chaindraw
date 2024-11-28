extends Button

@onready var hand : HandNode = self.get_parent_control().get_parent_control().hand
@onready var deck : Deck = self.get_parent_control().get_parent_control().deck

func _pressed() -> void:
	var card = CardFactory.create_card(Block)
	hand.add_card(CardWithID.new(card, CardFactory.get_next_card_id()))
	CardFactory.next_id += 1
