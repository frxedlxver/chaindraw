extends Button

@onready var hand : HandNode = self.get_parent_control().get_parent_control().hand

func _pressed() -> void:
	var card = CardFactory.create_card(Attack)
	hand.add_card(CardWithID.new(card, CardFactory.get_next_card_id()))
