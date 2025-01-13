class_name EnemyIntentUI extends TextureRect

@export var icon : TextureRect
@export var label : Label
# Called when the node enters the scene tree for the first time.
func _ready():
	_on_action_finished()


func _on_action_finished():
	label.text = '0'
	label.hide()
	icon.hide()
	icon.texture = null
	self.hide()


func _on_enemy_intent_changed(new_intent : EnemyAction):
	if new_intent == null:
		self.hide()
	else:
		self.show()
		icon.texture = new_intent.action_data.icon_tex
		icon.show()
		if new_intent.amount > 0:
			label.show()
			label.text = str(new_intent.amount)
		else:
			label.hide()
			label.text = '0'
	
