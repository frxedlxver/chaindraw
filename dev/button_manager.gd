class_name ButtonManager extends Node

@export var end_turn_button : Button

func _on_battle_phase_changed(new_phase : BattleController.BattlePhase):
	if new_phase == BattleController.BattlePhase.PLAYER_TURN:
		end_turn_button.disabled == false
	else:
		end_turn_button.disabled == true
