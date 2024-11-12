extends RichTextLabel

@onready var hand : HandNode = self.get_parent_control().get_parent_control().hand

func _process(delta: float) -> void:
	self.text = ("Hand size: %d" % hand.hand.card_count)
