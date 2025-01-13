class_name Block extends CardBase
var block : int = 5

func _init(id : int):
	cardData = preload("res://assets/cards/card_data/Block.tres")
	super._init(id)
	
	
func use(battle_data : BattleData):
	battle_data.player.gain_block(5)

func get_description():
	return "Gain %s block" % str(block)
