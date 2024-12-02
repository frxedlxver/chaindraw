class_name CardLogic

var cardData: CardData
var next_in_chain : int = -1
var drawnViaBond: bool = false

var _drawn_via_bond : bool = false
var metadata: Dictionary = {}
var id : int

func _init(id : int):
	self.id = id

func use(_battle_state : BattleData):
	pass  # To be overridden by subclasses

func set_metadata(key: String, value):
	metadata[key] = value

func get_metadata(key: String):
	return metadata.get(key, null)
