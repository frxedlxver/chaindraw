class_name ChargeUp extends StackableStatusEffect

func _init(stacks : int):
	super._init(stacks)
	self.data = preload("res://assets/statuses/SED_chargeup.tres")

func on_owner_meter_full(owner: Node):
	if owner.has_method("add_status_effect"):
		owner.add_status_effect(Burst.new(1))
	self.stacks -= 1

func modify_owner_outgoing_damage(amount : int):
	self.stacks = 0
	return amount
