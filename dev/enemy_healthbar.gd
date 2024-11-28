class_name EnemyHealthBar extends ProgressBar

@onready var label : Label = $Label

var health : int
var max_health : int

func _ready() -> void:
	await label.ready
	_update_visuals()

func _on_enemy_max_health_changed(new_max_health : int) -> void:
	self.max_health = new_max_health
	_update_visuals()


func _on_enemy_health_changed(new_health : int) -> void:
	self.health = new_health
	_update_visuals()

func _update_visuals():
	if label:
		label.text = "%d / %d" % [health, max_health]
	self.value = health
	self.max_value = max_health
