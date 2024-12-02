class_name BlockUI extends TextureRect

@onready var label : Label = $Label
var block : int = 0

func _ready():
	_update_display_text()
	
func _on_target_block_changed(new_block: Variant) -> void:
	block = new_block
	_update_display_text()

func _update_display_text():
	if label:
		label.text = str(block)
	if block < 1:
		self.hide()
	else:
		self.show()
