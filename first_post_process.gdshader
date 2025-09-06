shader_type spatial;

uniform sampler2D view_port_tex : source_color, repeat_disable, filter_nearest;

render_mode unshaded, fog_disabled, blend_mix;

// I was testing with these conversion functions... doesn't seem to help at all
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

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	ivec2 viewport_size = textureSize(view_port_tex, 0);
	vec2 pixel_pos = SCREEN_UV * vec2(viewport_size);
	float index = pixel_pos.x + (pixel_pos.y * float(viewport_size.x));
	float linear_ratio = index / float(viewport_size.x * viewport_size.y);
	
	// cycle between combining green or blue with red
	// you can see that red + green is ALMOST okay (except there is a funky bar across the top)
	// red + blue is quite bad though (almost as though "higher intensity" sRGB colors are taking "less space")...
	float go = (sin(TIME) + 1.0) * 0.5;
	float bo = (sin(TIME + PI) + 1.0) * 0.5;
	
	// (just for testing)
	vec3 output_color = vec3(
		SCREEN_UV.y, // red
		SCREEN_UV.x * go, // green
		SCREEN_UV.x * bo  // blue
	);
	
	// uncomment this to see the actual scene rendered with the incorrect colors
	// vec4 output_color = texture(view_port_tex, SCREEN_UV);
	
	// encode our colors into 5 bits each
	uint color_index =
		uint(output_color.r * 31.0)
		| (uint(output_color.g * 31.0) << 5u)
		| (uint(output_color.b * 31.0) << 10u);
		
	// encode 15 bit rgb values into red channel
    ALBEDO = vec3(
		float(color_index) / 32767.0, // red, encode all rgb colors in 15 bits
		0.0,
		0.0
	);
}

