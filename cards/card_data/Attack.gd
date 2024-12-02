class_name Attack extends CardLogic

var damage : int = 10

func _init(id : int):
	cardData = preload("res://cards/card_data/Attack.tres")
	super._init(id)
	
func use(battle_data : BattleData):
	if metadata.has("ignore_armor"):
		battle_data.cur_target.take_damage(damage, metadata.get("ignore_armor"));
	else: 
		battle_data.cur_target.take_damage(damage)
