class_name Burst extends StackableStatusEffect

var damage_mod_per_stack : float = 0.20

func _init(stacks : int):
	super._init(stacks)
	self.data = load("res://assets/statuses/SED_burst.tres")

func modify_owner_outgoing_damage(damage : int):
	var modified_damage : int = damage * (1 + stacks * damage_mod_per_stack)
	call_deferred("empty_stacks")
	return modified_damage

func empty_stacks():
	self.stacks = 0
