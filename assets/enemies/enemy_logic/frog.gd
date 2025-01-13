class_name Frog extends Enemy

func decide_next_action(battle_data : BattleData):
	self.intended_action = AttackEnemyAction.new(randi_range(4, 8))
