class_name TargetSelector extends Line2D

var active_card : CardNode

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

func initialize(enemies_list : Array[Enemy]) -> void:
	self.enemies = enemies_list
	self.add_point(Vector2.ZERO, 0)
	self.add_point(Vector2.ZERO, 1)
	for enemy : Enemy in enemies:
		enemy.mouse_entered_enemy.connect(_on_mouse_entered_enemy)
		enemy.mouse_exited_enemy.connect(_on_mouse_exited_enemy)
	self.deactivate()
	
func activate(card : CardNode):
	active_card = card
	self.is_targeting = true
	self.show()
	var card_center : Vector2 = card.targeting_line_base_pos
	self.set_point_position(0, card_center)
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func deactivate():
	active_card = null
	self.is_targeting = false
	self.hide()
	self.process_mode = Node.PROCESS_MODE_DISABLED

func _on_mouse_entered_enemy(enemy : Enemy):
	if is_targeting:
		cur_target = enemy
		enemy.highlight()
		self.default_color = Color.ORANGE_RED

func _on_mouse_exited_enemy(enemy : Enemy):
	if cur_target == enemy:
		cur_target = null
		enemy.remove_hightlight()
		self.default_color = Color.WHITE

func _input(event: InputEvent) -> void:
	if Util.event_is_lmb_press(event):
		if cur_target:
			target_selected.emit(cur_target)
		else:
			clicked_outside_target.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.set_point_position(1, get_global_mouse_position())
