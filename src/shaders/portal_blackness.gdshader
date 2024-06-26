shader_type spatial;
render_mode unshaded, depth_draw_never;


uniform vec3 col: source_color;

void fragment() {
	ALBEDO = col;
}
