class_name Healthbar extends ProgressBar

@export var label : Label

var max_health : int = 0
var cur_health : int = 0

func _on_player_max_health_changed(new_max_health: Variant) -> void:
	self.max_value = new_max_health
	max_health = new_max_health
	_update_label()


func _on_player_current_health_changed(new_current_health: Variant) -> void:
	self.value = new_current_health
	cur_health = new_current_health
	_update_label()
	
func _update_label():
	label.text = "%d / %d" % [self.cur_health, self.max_health]
