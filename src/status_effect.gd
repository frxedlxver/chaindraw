# Base class for status effects
class_name StatusEffect

enum StatusTiming {
	START,
	END
}

var name: String
var stackable: bool   # Whether the status can stack
var stacks : int
var per_turn_change: int = 0  # Change in intensity per turn
var timing: StatusTiming

func apply_effect(target):
	# To be overridden by subclasses
	pass

func on_turn_start():
	if timing == StatusTiming.START:
		#apply_effect()
		update_status()

func on_turn_end():
	if timing == StatusTiming.END:
		#apply_effect()
		update_status()

func update_status():
	stacks += per_turn_change
	#if stacks <= 0:
		#owner.remove_status(self)
