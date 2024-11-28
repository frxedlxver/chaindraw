class_name Main extends Node

@export var enemies : Array[Enemy]
@export var hand : HandNode
@export var player : Player
@onready var defeat_screen : Panel = $DefeatScreen
@onready var victory_screen : Panel = $VictoryScreen

var enemy_scene : PackedScene = preload("res://enemies/jackie.tscn")

var battle : BattleController
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies = [
		enemy_scene.instantiate(),
		enemy_scene.instantiate(),
		enemy_scene.instantiate(),
	]
	battle = $BattleController
	battle.enter_battle_phase.connect(_on_enter_battle_phase)
	battle.initialize_battle(player, enemies)
	battle.start_battle()


func _on_enter_battle_phase(battle_phase : BattleController.BattlePhase):
	match battle_phase:
		BattleController.BattlePhase.VICTORY:
			victory_screen.show()
		BattleController.BattlePhase.DEFEAT:
			defeat_screen.show()
