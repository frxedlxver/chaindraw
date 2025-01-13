class_name Player extends Node

# Signals
signal max_health_changed(new_max_health)
signal current_health_changed(new_current_health)
signal energy_changed(new_energy)
signal max_energy_changed(new_max_energy)
signal block_changed(new_block)
signal statuses_changed(Array)
signal block_decay_time_left_changed(float)
signal block_decay_duration_changed(float)
signal dead()

# Backing variables
var _max_health : int = 100
var _current_health : int = _max_health
var _energy : int = 3
var _max_energy : int = 3
var _block : int = 0  # Damage reduction for one turn
var statuses : Dictionary
var max_hand_size : int = 5
var deck : Deck
var block_decay_duration : float = 5.0
var block_decay_time_left : float = 0.0

# Properties with getters and setters
var max_health : int:
	get:
		return _max_health
	set(value):
		_max_health = value
		max_health_changed.emit(_max_health)

var current_health : int:
	get:
		return _current_health
	set(value):
		_current_health = value
		current_health_changed.emit(_current_health)

var energy : int:
	get:
		return _energy
	set(value):
		_energy = value
		energy_changed.emit(_energy)

var max_energy : int:
	get:
		return _max_energy
	set(value):
		_max_energy = value
		max_energy_changed.emit(_max_energy)

var block : int:
	get:
		return _block
	set(value):
		_block = value
		block_changed.emit(block)

func _ready():
	reset()
	pass

func reset():
	max_health = 100
	max_energy = 3
	current_health = max_health
	energy = max_energy
	block = 0
	statuses.clear()
	statuses_changed.emit(statuses.values())
	deck = Deck.new()
	
	# trigger signals for ui update
	self.block_decay_duration_changed.emit(self.block_decay_duration)
	
func load_deck(deck_to_load : Deck):
	self.deck = deck_to_load

func take_damage(amount : int):
	var damage_after_statuses = amount
	for status : StatusEffect in statuses.values():
		damage_after_statuses = status.modify_owner_incoming_damage(damage_after_statuses)
	
	var damage_after_block = max(damage_after_statuses - block, 0)
	block = max(block - amount, 0)
	
	current_health -= damage_after_block
	current_health = max(current_health, 0)
	
	if current_health == 0:
		die()
	
	# visual effects for damage taken
	if block > 0:
		pass
	else:
		pass
		
func deal_damage_to(target : Enemy, amount : int):
	var damage_after_statuses = amount
	
	for status : StatusEffect in statuses.values():
		damage_after_statuses = status.modify_owner_outgoing_damage(damage_after_statuses)
	
	target.take_damage(damage_after_statuses)

func _managed_process(delta):
	if self.block > 0:
		self.block_decay_time_left -= delta
		if self.block_decay_time_left <= 0.0:
			self.block_decay_time_left = self.block_decay_duration
			self.block -= 1
		self.block_decay_time_left_changed.emit(self.block_decay_time_left)

		
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

func add_status_effect(new_status : StatusEffect):
	if statuses.has(new_status.data.name):
		var cur_status = statuses[new_status.data.name]
		cur_status.absorb_new_status(new_status)
		statuses_changed.emit(statuses.values())
	else:
		if new_status is StackableStatusEffect:
			new_status.stacks_updated.connect(on_status_stacks_changed)
		statuses[new_status.data.name] = new_status
		new_status.status_decayed.connect(on_status_decayed)
		statuses_changed.emit(statuses.values())
	
func remove_status_effect(effect_name : String):
	if statuses.has(effect_name):
		statuses.erase(effect_name)
		statuses_changed.emit(statuses.values())

func on_status_decayed(decayed_status : StatusEffect):
	statuses.erase(decayed_status.data.name)
	statuses_changed.emit(statuses.values())
	
func on_status_stacks_changed(status : StackableStatusEffect):
	statuses_changed.emit(statuses.values())
	
func on_meter_full():
	for status : StatusEffect in statuses.values():
		status.on_owner_meter_full(self)
	
func die():
	dead.emit()

func on_battle_start():
	block = 0;
	refill_energy()
	
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
