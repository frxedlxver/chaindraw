class_name Block extends CardLogic
var block : int = 5
func _init() -> void:
	self.cardData = load("res://cards/card_data/Block.tres")
	
func use(battle_state : BattleData):
	battle_state.player.gain_block(5)
	
func on_drawn_via_bond():
	pass  # To be overridden by subclasses

func on_draw_bonded_card():
	pass  # To be overridden by subclasses

func set_metadata(key: String, value):
	metadata[key] = value

func get_metadata(key: String):
	return metadata.get(key, null)
