class_name Reaper extends Enemy

func decide_starting_action(battle_data: BattleData):
	if randi() % 2 == 0:
		self.intended_action = BlockEnemyAction.new(10)
	else:
		self.intended_action = AttackEnemyAction.new(7)

func decide_next_action(battle_data: BattleData):
	if self.intended_action is BlockEnemyAction:
		self.intended_action = AttackEnemyAction.new(randi_range(8, 12))
	else:
		self.intended_action = BlockEnemyAction.new(randi_range(3, 5))
