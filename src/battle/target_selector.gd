class_name TargetSelector extends Line2D

var card : CardNode

var enemies : Array[Enemy]
var cur_target : Enemy
var is_targeting : bool:
	get:
		return _is_targeting
	set(v):
		_is_targeting = v
		if !_is_targeting:
			cur_target = null

var _is_targeting : bool

signal target_selected(Enemy)
signal clicked_outside_target()

func _init(enemies : Array[Enemy]) -> void:
	self.enemies = enemies

func _ready() -> void:
	self.add_point(Vector2.ZERO, 0)
	self.add_point(Vector2.ZERO, 1)
	for enemy : Enemy in enemies:
		enemy.mouse_entered_enemy.connect(_on_mouse_entered_enemy)
		enemy.mouse_exited_enemy.connect(_on_mouse_exited_enemy)
	self.deactivate()
	
func activate(card : CardNode):
	card = card
	self.is_targeting = true
	self.show()
	var card_center = card.position + card.pivot_offset
	self.set_point_position(0, card_center)
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func deactivate():
	card = null
	self.is_targeting = false
	self.hide()
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _on_mouse_entered_enemy(enemy : Enemy):
	if is_targeting:
		cur_target = enemy
		enemy.highlight()

func _on_mouse_exited_enemy(enemy : Enemy):
	if cur_target == enemy:
		cur_target = null
		enemy.remove_hightlight()

func _input(event: InputEvent) -> void:
	if Util.event_is_lmb_press(event):
		if cur_target:
			target_selected.emit(cur_target)
		else:
			clicked_outside_target.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.set_point_position(1, get_global_mouse_position())
