class_name Healthbar extends ProgressBar


func _on_player_max_health_changed(new_max_health: Variant) -> void:
	self.max_value = new_max_health


func _on_player_current_health_changed(new_current_health: Variant) -> void:
	self.value = new_current_health
