shader_type spatial;
render_mode specular_disabled;

uniform sampler2D image: hint_default_black;
uniform sampler2D wiggle_noise: hint_default_black;
uniform vec3 col: source_color;

void fragment() {
	vec2 coordinates = vec2(UV.x - (TIME * 0.1), UV.y);
	ALBEDO = vec3(0.0);
	EMISSION = col;
	ALPHA = texture(image, coordinates).r;
}

void vertex() {
	vec2 coordinates = vec2(UV.x, UV.y - (TIME * 0.5));
	VERTEX.z += texture(wiggle_noise, coordinates).r * 0.4;
}