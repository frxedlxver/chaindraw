class_name Attack extends CardLogic

var damage : int = 10
func _init() -> void:
	self.cardData = load("res://cards/card_data/Attack.tres")
	
func use(battle_state : BattleData):
	battle_state.cur_target.take_damage(damage)
	battle_state.player.use_energy(cardData.cost)
	
func on_drawn_via_bond():
	pass  # To be overridden by subclasses

func on_draw_bonded_card():
	pass  # To be overridden by subclasses

func set_metadata(key: String, value):
	metadata[key] = value

func get_metadata(key: String, value):
	return metadata.get(key, null)
