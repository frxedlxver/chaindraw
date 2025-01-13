@tool
extends PanelContainer
class_name CardNode

var card_base: CardBase  # Reference to the underlying CardBase instance

@export var cost_label : Label
@export var cardborder_tex : TextureRect
@export var card_art_tex_rect : TextureRect
@export var title_label : Label
@export var _targeting_line_base_pos_node : Node2D

@export var unplayable_border_color : Color = Color.hex(0xff9f90ff)
@export var unplayable_text_color : Color = Color.RED
@export var playable_border_color : Color = Color.hex(0xb6dec7ff)
@export var playable_text_color : Color = Color.WHITE


var targeting_line_base_pos : Vector2:
	get: return _targeting_line_base_pos_node.global_position

enum CardState {
	NORMAL,   # In hand, not interacted with
	HOVERED,  # Mouse is over the card
	ACTIVE    # Card is selected/activated
}

var playable : bool:
	get: return playable
	set(v):
		_playable = v
		if _playable:
			self.cost_label.add_theme_color_override(&"font_color", playable_text_color)
			self.cardborder_tex.self_modulate = playable_border_color
		else:
			self.cost_label.add_theme_color_override(&"font_color", unplayable_text_color)
			self.cardborder_tex.self_modulate = unplayable_border_color
			
var _playable : bool
var current_state: CardState = CardState.NORMAL
const DEFAULT_COLOR: Color = Color.WHITE
var flash_tween: Tween

var angle_in_hand: float = 0
var anchor : Vector2 = Vector2.ZERO

static var max_dist_from_anchor_while_active : float = 100.0

signal card_clicked(CardNode)

var cost : int:
	get: return card_base.cardData.cost

func _process(delta):
	if self.current_state == CardState.ACTIVE:
		var mouse_pos = get_parent().get_local_mouse_position()
		var angle_to_mouse = anchor.angle_to_point(mouse_pos)
		var dist_from_anchor = min((mouse_pos - anchor).length(), max_dist_from_anchor_while_active)
		var x = dist_from_anchor * cos(angle_to_mouse)
		var y = min(0.0, dist_from_anchor * sin(angle_to_mouse))
		self.position = anchor + Vector2(x, y)
	else:
		self.position = anchor


func _ready():
	self.name = "CardNode"
	update_visual_components()
	set_process_input(true)

func _gui_input(event: InputEvent) -> void:
	if Util.event_is_lmb_press(event):
			card_clicked.emit(self)

func use(battle_state : BattleData):
	card_base.use(battle_state)
	
func _on_mouse_entered() -> void:
	if current_state == CardState.NORMAL:
		change_state(CardState.HOVERED)

func _on_mouse_exited() -> void:
	if current_state != CardState.ACTIVE:
		change_state(CardState.NORMAL)

func change_state(new_state: CardState):
	if current_state == new_state:
		return  # No state change needed
	current_state = new_state
	update_visual_state()

func update_visual_state():
	match current_state:
		CardState.NORMAL:
			modulate = DEFAULT_COLOR
			scale_to(1.0)
			rotate_to(angle_in_hand)
			z_index = 0
		CardState.HOVERED:
			modulate = DEFAULT_COLOR
			scale_to(1.1)
			rotate_to(0)
			z_index = 1
		CardState.ACTIVE:
			modulate = Color.BEIGE
			scale_to(1.2)
			rotate_to(0)
			z_index = 2

func select():
	change_state(CardState.ACTIVE)

func deselect():
	change_state(CardState.NORMAL)

func flash_red():
	if flash_tween and flash_tween.is_running():
		flash_tween.kill()
	modulate = Color.RED
	flash_tween = create_tween()
	flash_tween.set_ease(Tween.EaseType.EASE_IN)
	flash_tween.tween_property(self, "modulate", DEFAULT_COLOR, 0.2)

func reposition(new_position: Vector2, new_rotation_deg: float):
	move_to(new_position)
	rotate_to(new_rotation_deg)

func set_card_anchor(anchor_position : Vector2, anchor_angle : float):
	self.anchor = anchor_position
	self.angle_in_hand = anchor_angle

func scale_to(target_scale: float):
	var tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ONE * target_scale, 0.1)

func rotate_to(target_rotation_deg: float):
	var tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	tween.tween_property(self, "rotation_degrees", target_rotation_deg, 0.1)

func move_to(target_position: Vector2):
	var tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	tween.tween_property(self, "position", target_position, 0.1)

func update_visual_components():
	if card_base != null:
		title_label.text = card_base.cardData.title
		cost_label.text = str(card_base.cardData.cost)
		card_art_tex_rect.texture = card_base.cardData.faceTex
