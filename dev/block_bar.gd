class_name BlockBar extends ProgressBar

@export var label : Label
var block : int = 0

func _ready():
	_update_display_text()
		
func _on_target_block_changed(new_block: Variant) -> void:
	self.block = new_block
	_update_display_text()

func _update_display_text():
	if label:
		label.text = str(block)
	if block < 1:
		self.hide()
	else:
		self.show()


func _on_decay_time_left_changed(new_time_left : float):
	self.value = new_time_left


func _on_block_decay_duration_changed(new_decay_duration : float):
	self.max_value = new_decay_duration
