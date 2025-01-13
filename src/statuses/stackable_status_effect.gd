class_name StackableStatusEffect extends StatusEffect

var stacks : int:
	get: return _stacks
	set(v):
		_stacks = v
		if _stacks <= 0:
			status_decayed.emit(self)
		stacks_updated.emit(self)

var _stacks : int

var stack_decay_time : float

signal stacks_updated(StackableStatusEffect)

func _init(stacks : int):
	self.stacks = stacks
	
func absorb_new_status(new_status : StatusEffect):
	if typeof(new_status) == typeof(self):
		self.stacks += new_status.stacks
