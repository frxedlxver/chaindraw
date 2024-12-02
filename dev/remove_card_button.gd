extends Button

@onready var hand : HandNode = self.get_parent_control().get_parent_control().hand


func _pressed() -> void:
	var card = hand.take_card(0)
	
	if card is CardNode:
		card.queue_free()
