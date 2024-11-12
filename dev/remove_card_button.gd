extends Button

@onready var hand : HandNode = self.get_parent_control().get_parent_control().hand


func _pressed() -> void:
	var card = hand.take_card(0)
	
	if card and card is CardWithID:
		card.card.queue_free()
