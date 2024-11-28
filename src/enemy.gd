class_name Enemy extends Node2D

@export var max_health : int :
	get: return _max_health
	set(v):
		_max_health = v
		max_health_changed.emit(_max_health)
var health : int :
	get: return _health
	set(v):
		_health = v
		health_changed.emit(health)

var _max_health : int
var _health : int


@onready var healthbar : EnemyHealthBar = $HealthBar
@onready var main_sprite : AnimatedSprite2D = $AnimatedSprite2D

signal dead(Enemy)
signal enemy_clicked(Enemy)
signal mouse_entered_enemy(Enemy)
signal mouse_exited_enemy(Enemy)
signal animation_finished(String)
signal health_changed(int)
signal max_health_changed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health_changed.emit(max_health)
	health = max_health
	
	
func on_turn_start():
	pass
	
	
func on_turn_end():
	pass
	
func attack(battle_data : BattleData):
	main_sprite.play("attack")
	await main_sprite.animation_finished
	main_sprite.play("idle")
	battle_data.player.take_damage(7)
	animation_finished.emit("attack")
	
func take_damage(amount):
	self.health = self.health - amount
	if self.health <= 0:
		self.dead.emit(self)
	self.flash_red()
	
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			enemy_clicked.emit(self)

	
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
	main_sprite.self_modulate = Color.RED
	tween.set_ease(Tween.EASE_IN) 
	tween.tween_property(main_sprite, "self_modulate", Color.WHITE, 0.1)


func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	mouse_entered_enemy.emit(self)


func _on_area_2d_mouse_shape_exited(shape_idx: int) -> void:
	mouse_exited_enemy.emit(self)
