class_name BattleData

var player : Player
var enemies : Array[Enemy]
var cur_target

func _init(player_node : Player, enemies_list : Array[Enemy]):
	self.player = player_node
	self.enemies = enemies_list
