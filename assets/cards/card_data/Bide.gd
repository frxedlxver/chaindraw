class_name Bide extends CardBase

var block : int = 10
var charge_up : int = 5

func _init(id : int):
	cardData = preload("res://assets/cards/card_data/Bide.tres")
	super._init(id)
	
	
func use(battle_data : BattleData):
	battle_data.player.gain_block(block)
	battle_data.player.add_status_effect(ChargeUp.new(5))

func get_description():
	return "Gain %d block. Gain %d Chargeup" % [block, charge_up]
