class_name Player extends Node

# Signals
signal max_health_changed(new_max_health)
signal current_health_changed(new_current_health)
signal energy_changed(new_energy)
signal max_energy_changed(new_max_energy)
signal block_changed(new_block)
signal status_effects_changed()

# Backing variables
var _max_health : int = 100
var _current_health : int = _max_health
var _energy : int = 3
var _max_energy : int = 3
var _block : int = 0  # Damage reduction for one turn
var status_effects : Array[StatusEffect]

# Properties with getters and setters
var max_health : int:
	get:
		return _max_health
	set(value):
		_max_health = value
		emit_signal("max_health_changed", _max_health)

var current_health : int:
	get:
		return _current_health
	set(value):
		_current_health = value
		emit_signal("current_health_changed", _current_health)

var energy : int:
	get:
		return _energy
	set(value):
		_energy = value
		emit_signal("energy_changed", _energy)

var max_energy : int:
	get:
		return _max_energy
	set(value):
		_max_energy = value
		emit_signal("max_energy_changed", _max_energy)

var block : int:
	get:
		return _block
	set(value):
		_block = value
		emit_signal("block_changed", _block)

func _ready():
	# Initialization code
	pass

func reset():
	max_health = 100
	max_energy = 3
	current_health = max_health
	energy = max_energy
	block = 0
	status_effects.clear()
	emit_signal("status_effects_changed")

func take_damage(amount : int):
	var damage_after_block = max(amount - block, 0)
	block = max(block - amount, 0)
	current_health -= damage_after_block
	current_health = max(current_health, 0)
	if current_health == 0:
		die()

func gain_block(amount : int):
	block += amount
	print("gained %d block for a total of %d block" % [amount, block])

func heal(amount : int):
	current_health += amount
	current_health = min(current_health, max_health)

func use_energy(amount : int) -> bool:
	if energy >= amount:
		energy -= amount
		return true
	else:
		return false

func refill_energy():
	energy = max_energy
	
func gain_energy(amount : int):
	energy += amount
	energy = min(energy, max_energy)

func apply_status_effect(effect : StatusEffect):
	pass
	
func remove_status_effect(effect_name : String):
	if status_effects.has(effect_name):
		status_effects.erase(effect_name)
		emit_signal("status_effects_changed")

func die():
	pass #not yet implemented

func on_turn_start():
	# Reset block at the start of each turn
	block = 0
	# Refill energy
	refill_energy()
	# Decrease duration of status effects
	#process any status effects
	#to be implemented

func on_turn_end():
	pass # unimplemented