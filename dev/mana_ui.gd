class_name ManaUI extends Label

var cur_energy : int
var max_energy : int
var label_text : String = "Energy: "

func _on_player_energy_changed(new_energy: Variant) -> void:
	cur_energy = new_energy
	_update_display_text()


func _on_player_max_energy_changed(new_max_energy: Variant) -> void:
	max_energy = new_max_energy
	_update_display_text()

func _update_display_text():
	self.text = "%s%d/%d" % [label_text, cur_energy, max_energy]
