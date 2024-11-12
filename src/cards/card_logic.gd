class_name CardLogic

var cardData: CardData
var bondedTo: CardLogic = null
var drawnViaBond: bool = false
var metadata: Dictionary = {}

func use(battle_state : BattleData):
	pass  # To be overridden by subclasses

func on_drawn_via_bond():
	pass  # To be overridden by subclasses

func on_draw_bonded_card():
	pass  # To be overridden by subclasses

func set_metadata(key: String, value):
	metadata[key] = value

func get_metadata(key: String, value):
	return metadata.get(key, null)
