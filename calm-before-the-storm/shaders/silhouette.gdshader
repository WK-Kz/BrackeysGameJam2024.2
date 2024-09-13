shader_type canvas_item;

// Screen texture detects if sprite is behind another sprite
uniform sampler2D screen_texture: hint_screen_texture;

// silhouette color
uniform vec4 silhouette_color: source_color = vec4(0.0, 0.0, 0.0, 0.5);

// Called for every pixel the material is visible on.
void fragment() {
	// Sample screen color
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	// Sample sprite color
	vec4 sprite_color = texture(TEXTURE, UV);
	// Check if sprite & screen color match
	if(all(lessThan(abs(sprite_color - screen_color), vec4(0.01)))) {
		// Character sprite visible
		COLOR = sprite_color;
	} else {
		// Character is behind object
		COLOR = vec4(silhouette_color.rgb, silhouette_color.a * sprite_color.a);
	}
}