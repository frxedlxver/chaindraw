class_name Enemy extends Control

var max_health : int = 100
var health : int 


@onready var healthbar : ProgressBar = $HealthBar
@onready var main_tex : TextureRect = $EnemyTexture

signal dead()
signal enemy_clicked(Enemy)
signal mouse_entered_enemy(Enemy)
signal mouse_exited_enemy(Enemy)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.healthbar.max_value = max_health
	self.health = max_health
	self.healthbar.value = health
	
	
func on_turn_start():
	pass
	
	
func on_turn_end():
	pass
	
	
func take_damage(amount):
	self.health = self.health - amount
	self.healthbar.value = self.health
	if self.health <= 0:
		self.dead.emit()
		self.queue_free()
	self.flash_red()
	
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			enemy_clicked.emit(self)


func _on_mouse_entered() -> void:
	mouse_entered_enemy.emit(self)
	
	
func _on_mouse_exited() -> void:
	mouse_exited_enemy.emit(self)
	
	
func highlight():
	scale_to(1.1)
	
	
func remove_hightlight():
	scale_to(1.0)
	
	
func scale_to(target_scale):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN) 
	tween.tween_property(self, "scale", target_scale * Vector2.ONE, 0.1)
	
	
func flash_red():
	var tween = create_tween()
	main_tex.self_modulate = Color.RED
	tween.set_ease(Tween.EASE_IN) 
	tween.tween_property(main_tex, "self_modulate", Color.WHITE, 0.1)
