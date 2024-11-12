class_name Main extends Node

@export var enemies : Array[Enemy]
@export var hand : HandNode
@export var player : Player
var enemy_scene : PackedScene = preload("res://enemies/enemy.tscn")

var battle : BattleController
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies = [
		enemy_scene.instantiate(),
		enemy_scene.instantiate(),
		enemy_scene.instantiate(),
	]
	battle = $BattleController
	battle.initialize_battle(player, enemies)
	battle.start_battle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
