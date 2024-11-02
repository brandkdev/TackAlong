shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform sampler2D noise_texture: filter_nearest, repeat_enable;

uniform float distortion = 0.01;

uniform vec2 speed = vec2(0.5, 0.2);

uniform float wave_strength = 20.0;

	// Called for every vertex the material is visible on.
void vertex() {
	VERTEX.y += wave_strength * sin(TIME + VERTEX.x);
}
	// Called for every pixel the material is visible on.
void fragment() {
	
	vec2 uv = UV + speed * TIME;
	
	vec2 noise = 2.0 * texture(noise_texture, UV).rg - vec2(1.0) * distortion;
	
	uv += noise;
	
	COLOR = texture(TEXTURE, UV);
	
	COLOR += texture(screen_texture, SCREEN_UV);
}

