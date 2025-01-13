class_name Attack extends CardBase

var damage : int = 10

func _init(id : int):
	cardData = preload("res://assets/cards/card_data/Attack.tres")
	super._init(id)
	
func use(battle_data : BattleData):
	battle_data.player.deal_damage_to(battle_data.cur_target, damage)
		
func get_description():
	return "Deal %s damage to target" % str(damage)
