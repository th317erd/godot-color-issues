shader_type spatial;

uniform sampler2D view_port_tex : source_color, repeat_disable, filter_nearest;

render_mode unshaded, fog_disabled, blend_mix;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

float linear_to_srgb(float c) {
    return (c <= 0.0031308)
        ? 12.92 * c
        : 1.055 * pow(c, 1.0 / 2.4) - 0.055;
}

float srgb_to_linear(float c) {
    return (c <= 0.04045)
        ? c / 12.92
        : pow((c + 0.055) / 1.055, 2.4);
}

void fragment() {
	vec3 viewport_texel = texture(view_port_tex, SCREEN_UV).rgb;

	// Decode the "r" channel into "rgb" colors (5 bit for each channel)
	uint color_index = uint(viewport_texel.r * 32767.0);
	vec3 color = vec3(
		float(color_index & 0x1Fu) / 31.0,
		float((color_index >> 5u) & 0x1Fu) / 31.0,
		float((color_index >> 10u) & 0x1Fu) / 31.0
	);

	//ALBEDO = vec3(
		//srgb_to_linear(viewport_texel.r),
		//viewport_texel.g,
		//viewport_texel.b
	//);
	
	ALBEDO = color;
}
