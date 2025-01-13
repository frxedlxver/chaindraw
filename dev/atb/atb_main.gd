class_name ATBMain extends Node

@export var enemies : Array[Enemy]
@export var hand : HandNode
@export var player : Player
@onready var defeat_screen : Panel = $DefeatScreen
@onready var victory_screen : Panel = $VictoryScreen

@export var enemy_scene : PackedScene

var battle : ATBController
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies = [
		enemy_scene.instantiate(),
	]
	battle = $ATBController
	player.reset()
	var deck = DebugDeckLoader.get_deck()
	CardSaveDataHandler.save_deck(deck)
	player.deck = CardSaveDataHandler.load_deck()
	battle.victory.connect(_on_victory)
	battle.defeat.connect(_on_defeat)
	battle.initialize_battle(player, enemies)

func _on_victory():
	victory_screen.show()
	
func _on_defeat():
	defeat_screen.show()
