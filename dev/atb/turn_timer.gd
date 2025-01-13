class_name TurnTimer extends Node

signal time_changed(float)
signal max_time_changed(float)
signal timer_finished()

var _max_time : float
var _cur_time : float

var max_time : float:
	get: return _max_time
	set(v):
		_max_time = v
		max_time_changed.emit(_max_time)
		



var cur_time : float:
	get: return _cur_time
	set(v):
		_cur_time = v
		time_changed.emit(_cur_time)

func _ready():
	# to trigger signals
	max_time = max_time
	cur_time = cur_time

func increment(delta : float):
	cur_time = min(max_time, cur_time + delta)
	
	if cur_time >= max_time:
		timer_finished.emit()
		reset()

func reset():
	self.cur_time = 0.0
