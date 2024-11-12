class_name BattleData

var player : Player
var enemies : Array[Enemy]
var cur_target

func _init(player : Player, enemies : Array[Enemy]):
	self.player = player
	self.enemies = enemies
