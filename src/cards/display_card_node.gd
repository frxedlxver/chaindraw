extends PanelContainer
class_name DisplayCardNode

var card_base: CardBase  # Reference to the underlying CardBase instance

@export var cost_label : Label
@export var base_tex_rect : TextureRect
@export var card_art_tex_rect : TextureRect

enum CardState {
	NORMAL,   # In hand, not interacted with
	HOVERED,  # Mouse is over the card
	ACTIVE,    # Card is selected/activated
}

var current_state: CardState = CardState.NORMAL
const DEFAULT_COLOR: Color = Color.WHITE
var flash_tween: Tween

var angle_in_hand: float = 0
var anchor : Vector2 = Vector2.ZERO

signal card_clicked(CardNode)

var cost : int:
	get: return card_base.cardData.cost

func _ready():
	set_process_input(true)

func create_from_card_node(card_node : CardNode):
	self.card_base = card_node.card_base
	update_visual_components()
	

func _gui_input(event: InputEvent) -> void:
	if Util.event_is_lmb_press(event):
			card_clicked.emit(self)


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
		cost_label.text = str(card_base.cardData.cost)
		card_art_tex_rect.texture = card_base.cardData.faceTex
