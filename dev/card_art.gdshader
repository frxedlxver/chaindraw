shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, vec2(
		clamp(UV.x + (sin(UV.y * 100.0 + TIME * 4.0) * 0.01), -1.0, 1.0),
		UV.y
	));
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
