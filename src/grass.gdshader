shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_disabled;

uniform sampler2D wind_noise;
uniform sampler2D color_ramp : source_color;
uniform float shading_amount = 0.2;

group_uniforms wind;
uniform float wind_speed = 0.1;
uniform float wind_strength = 0.3;
uniform float wind_noise_scale = 20.0;
uniform float wind_vertical_affect = 0.3;
uniform vec2 wind_scroll_direction = vec2(1.0,0.5);


void vertex() {
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	vec2 world_uv = world_vert.xz / wind_noise_scale + normalize(wind_scroll_direction) * wind_speed * TIME;

	float displacement_mask = (1.0 - UV.y);
	float wind_noise_intensity = (textureLod(wind_noise, world_uv , 0.0).r - 0.5);

	vec2 vert_space_horizontal_dir = normalize(wind_scroll_direction);
	
	vec3 wind_displace = vec3(
		wind_noise_intensity * vert_space_horizontal_dir.x,
		1.0 - wind_noise_intensity,
		wind_noise_intensity * vert_space_horizontal_dir.y 
	);
	wind_displace *= vec3(
		wind_strength,
		wind_vertical_affect,
		wind_strength
	);
	VERTEX += wind_displace * displacement_mask;
}

void fragment() {
	vec4 col = texture(color_ramp, vec2(1.0 - UV.y));

	ALBEDO = col.rgb;
	ROUGHNESS = 1.0;
	NORMAL = NORMAL * vec3(shading_amount);;


}
