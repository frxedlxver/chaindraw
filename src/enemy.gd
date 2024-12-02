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

var block : int:
	get: return _block
	set(v):
		_block = v
		block_changed.emit(block)
		
var _max_health : int
var _health : int
var _block : int

@onready var healthbar : EnemyHealthBar = $HealthBar
@onready var main_sprite : AnimatedSprite2D = $AnimatedSprite2D

signal dead(Enemy)
signal enemy_clicked(Enemy)
signal mouse_entered_enemy(Enemy)
signal mouse_exited_enemy(Enemy)
signal animation_finished(String)
signal turn_finished
signal health_changed(int)
signal max_health_changed(int)
signal block_changed(int)
signal plan_changed(EnemyPlan)

enum EnemyPlan {
	ATTACK,
	BLOCK
}

var turn_in_progress : bool

var plan : EnemyPlan

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health_changed.emit(max_health)
	health = max_health
	self.plan = EnemyPlan.ATTACK if randf_range(0.0, 1.0) > 0.5 else EnemyPlan.BLOCK
	main_sprite.play("idle")
	
	
func on_turn_start():
	self.block = 0
	
	
func on_turn_end():
	pass
	
func do_turn(battle_data : BattleData):
	turn_in_progress = true
	if plan == EnemyPlan.ATTACK:
		main_sprite.play("attack")
		await main_sprite.animation_finished
		animation_finished.emit("attack")
		main_sprite.play("idle")
		battle_data.player.take_damage(7)
		turn_finished.emit()
		set_plan(EnemyPlan.BLOCK)
	elif plan == EnemyPlan.BLOCK:
		self.block += 10
		set_plan(EnemyPlan.ATTACK)
	turn_in_progress = false
	turn_finished.emit()

func set_plan(new_plan : EnemyPlan):
	self.plan = new_plan
	plan_changed.emit(self.plan)

func take_damage(amount : int, ignore_armor : bool = false):
	if ignore_armor:
		self.health -= amount
	else:
		# see if damage amount removes all block.
		var remainder = amount - self.block
		print("self.block")
		
		# apply damage to block
		self.block = max(0, self.block - amount)
		
		# if damage removed all block (and then some), pass that through to health
		if remainder > 0:
			self.health -= remainder
	
	# damage effect 
	self.flash_red()
	
	#check if dead
	if self.health <= 0:
		self.dead.emit(self)


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


func _on_area_2d_mouse_shape_entered(_shape_idx: int) -> void:
	mouse_entered_enemy.emit(self)


func _on_area_2d_mouse_shape_exited(_shape_idx: int) -> void:
	mouse_exited_enemy.emit(self)
