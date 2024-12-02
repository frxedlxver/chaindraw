class_name Block extends CardLogic
var block : int = 5

func _init(id : int):
	cardData = preload("res://cards/card_data/Block.tres")
	super._init(id)
	
	
func use(battle_data : BattleData):
	battle_data.player.gain_block(5)
