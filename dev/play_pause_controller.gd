class_name PlayPauseController extends Control

@export var play_tex : TextureRect
@export var pause_tex : TextureRect

var is_paused : bool = false

func _ready():
	play_tex.pivot_offset = play_tex.get_rect().size / 2
	pause_tex.pivot_offset = pause_tex.get_rect().size / 2

func on_play():
	if is_paused:
		play_tex.self_modulate = Color.WHITE
		play_tex.custom_minimum_size = Vector2(128, 128)
		is_paused = false
		pause_tex.hide()
		play_tex.show()
		var play_tween = play_tex.create_tween()
		var size_tween = play_tex.create_tween()
		play_tween.tween_property(play_tex, "self_modulate", Color.hex(0xffffff00), 0.2)
		size_tween.tween_property(play_tex, "size", Vector2(170, 170), 0.5)
		await play_tween.finished
		play_tex.hide()
		
		
func on_pause():

	pause_tex.self_modulate = Color.WHITE
	pause_tex.show()
	var pause_tween = pause_tex.create_tween()
	var size_tween = play_tex.create_tween()
	size_tween.tween_property(pause_tex, "size", Vector2(170, 170), 0.05)
	pause_tween.tween_property(pause_tex, "self_modulate", Color.hex(0xffffff20), 0.2)
	await size_tween.finished
	size_tween = pause_tex.create_tween()
	size_tween.tween_property(pause_tex, "size", Vector2(128, 128), 0.05)
	
	is_paused = true
