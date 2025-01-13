class_name BlockEnemyAction extends EnemyAction


# Called when the node enters the scene tree for the first time.
func _init(amount : int):
	self.amount = amount
	self.action_data = ResourceLoader.load("res://assets/enemies/enemy_actions/EAD_block.tres")

func do_action(battle_data : BattleData, caller : Enemy):
	caller.block = amount
