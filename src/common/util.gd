class_name Util

static func event_is_lmb_press(event):
	return event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT
