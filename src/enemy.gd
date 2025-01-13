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
		
var intended_action : EnemyAction:
	get: return _intended_action
	set(v):
		_intended_action = v
		intent_changed.emit(_intended_action)
		
@export var turn_length : float :
	get: return _turn_length
	set(v):
		_turn_length = v
		turn_length_changed.emit(_turn_length)
		
var time_in_turn : float:
	get: return _time_in_turn
	set(v):
		_time_in_turn = v
		time_in_turn_changed.emit(_time_in_turn)

var _max_health : int
var _health : int
var _block : int
var _intended_action : EnemyAction
var turn_in_progress : bool
var _turn_length : float
var _time_in_turn : float
@export var main_sprite : AnimatedSprite2D

var timer_running : bool = true

signal time_in_turn_changed(float)
signal turn_length_changed(float)
signal intent_changed(EnemyAction)
signal dead(Enemy)
signal enemy_clicked(Enemy)
signal mouse_entered_enemy(Enemy)
signal mouse_exited_enemy(Enemy)
signal animation_finished(String)
signal turn_finished(Enemy)
signal health_changed(int)
signal max_health_changed(int)
signal block_changed(int)
signal wait_for_action_event(started : bool)

func managed_process(delta):
	if !self.timer_running:
		return
		
	self.time_in_turn += delta
	if self.time_in_turn >= self.turn_length:
		self.time_in_turn = 0.0
		self.turn_finished.emit(self)


func initialize_self():
	max_health_changed.emit(max_health)
	health = max_health
	main_sprite.play("idle")
	turn_length_changed.emit(self._turn_length)
	self.time_in_turn = randf_range(0.0, self._turn_length * 0.2)
	self.time_in_turn = 0.0
	self.turn_length = self.turn_length


func decide_next_action(battle_data : BattleData):
	pass

# override if starting action decision is different
func decide_starting_action(battle_data : BattleData):
	decide_next_action(battle_data)


func do_turn(battle_data : BattleData):
	turn_in_progress = true
	#play animation, if necessary
	if self.intended_action.action_data.has_animation:
		wait_for_action_event.emit(true)
		main_sprite.play(self.intended_action.action_data.animation_name)
		await main_sprite.animation_finished
		animation_finished.emit(self.intended_action.action_data.animation_name)
		wait_for_action_event.emit(false)

	self.intended_action.do_action(battle_data, self)
		
	# notify turn finished
	turn_in_progress = false


func take_damage(amount : int, ignore_armor : bool = false):
	if ignore_armor:
		self.health -= amount
	else:
		# see if damage amount removes all block.
		var remainder = amount - self.block
		
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
