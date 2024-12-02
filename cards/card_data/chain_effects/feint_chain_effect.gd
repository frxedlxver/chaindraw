class_name PierceChainEffect extends ChainEffect

func before_play(target_card : CardNode, battle_data : BattleData):
	target_card.card_base.set_metadata("ignore_armor", true)

func after_play(target_card : CardNode, battle_data : BattleData):
	target_card.card_base.set_metadata("ignore_armor", false)
