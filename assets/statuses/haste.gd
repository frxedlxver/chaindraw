class_name Haste extends StatusEffect


func _init():
	self.data = load("res://resources/statuses/SED_haste.tres")

func _update_status_stacks():
	self.stacks -= 1
