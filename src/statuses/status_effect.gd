# Base class for status effects
class_name StatusEffect

var data : StatusEffectData

signal status_decayed(StatusEffectData)

func apply_effect(_target):
	# To be overridden by subclasses
	pass

func on_owner_meter_full(owner):
	pass

func modify_owner_outgoing_damage(damage : int):
	return damage

func modify_owner_incoming_damage(damage : int):
	return damage

func absorb_new_status(new_status : StatusEffect):
	pass
