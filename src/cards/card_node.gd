class_name CardNode extends PanelContainer

var card_base : CardLogic  # Reference to the underlying CardLogic instance

@onready var cost_label = $BaseTexRect/CostLabel
@onready var base_tex_rect = $BaseTexRect
@onready var card_art_tex_rect = $CardArtRect

var highlight_color : Color = Color.hex(0xffe8b3cc)
@export var select_color : Color = Color.hex(0xffe8b3cc)

signal mouse_clicked(CardNode)
signal mouse_entered_card(CardNode)
signal mouse_exited_card(CardNode)

var angle_in_hand : float = 0

func _ready():
	update_visual_components()
	# Enable input processing
	set_process_input(true)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print(event)
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			mouse_clicked.emit(self)
			print("clicked")
			
func transform_card(new_card: CardLogic):
	card_base = new_card
	update_visual_components()

func update_visual_components():
	if card_base != null:
		cost_label.text = str(card_base.cardData.cost)
		card_art_tex_rect.texture = card_base.cardData.faceTex

func activate(battle_state : BattleData):
	card_base.use(battle_state)
	
func _on_mouse_entered() -> void:
	mouse_entered_card.emit(self)
	
func _on_mouse_exited() -> void:
	mouse_exited_card.emit(self)
	
func highlight():
	self.top_level = true
	self.scale_to(1.1)
	self.angle_in_hand = self.rotation_degrees
	self.rotate_to(0)
	
func select():
	self.top_level = true
	self.scale_to(1.2)
	if self.angle_in_hand == 0:
		self.angle_in_hand = self.rotation_degrees
	self.rotate_to(0)

func flash_red():
	var original_color = base_tex_rect.self_modulate
	# Immediately set the color to red
	base_tex_rect.self_modulate = Color.RED
	# Create a tween to handle the animation
	var tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	# Tween the self_modulate property back to white over 0.2 seconds
	tween.tween_property(base_tex_rect, "self_modulate", original_color, 0.2)

func reposition(position : Vector2, rotation_deg : float):
	move_to(position)
	rotate_to(rotation_deg)

func remove_highlight():
	self.top_level = false
	self.scale_to(1.0)
	self.rotate_to(angle_in_hand)

func scale_to(target_scale : float):
	var tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	# Tween the self_modulate property back to white over 0.2 seconds
	tween.tween_property(self, "scale", Vector2.ONE * target_scale, 0.1)

func rotate_to(target_rotation_deg : float):
	var tween = create_tween()
	tween.set_ease(Tween.EaseType.EASE_IN)
	# Tween the self_modulate property back to white over 0.2 seconds
	tween.tween_property(self, "rotation_degrees", target_rotation_deg, 0.1)

func move_to(target_position : Vector2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN) 
	tween.tween_property(self, "position", target_position, 0.1)
