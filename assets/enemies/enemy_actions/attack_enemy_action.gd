class_name AttackEnemyAction extends EnemyAction

func _init(amount : int):
	self.amount = amount
	self.action_data = ResourceLoader.load("res://assets/enemies/enemy_actions/EAD_attack.tres")
	
func do_action(battle_data : BattleData, caller : Enemy):
	battle_data.player.take_damage(7)
