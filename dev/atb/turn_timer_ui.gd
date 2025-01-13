class_name TurnTimerUI extends ProgressBar

var max_time : float = 0
@export var label : Label

func update_label_text():
	if label:
		label.text = "%.1f / %.1f" % [self.value, self.max_value]
		
func _on_time_changed(new_time : float):
	self.value = new_time
	update_label_text()
	
	
func _on_max_time_changed(new_max_time : float):
	self.max_time = new_max_time
	self.max_value = new_max_time
	update_label_text()
