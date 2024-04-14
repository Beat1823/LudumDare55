shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;

//void fragment() {
    //vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
//
    //c.rgb = mix(vec3(0.0), c.rgb, brightness);
    //c.rgb = mix(vec3(0.5), c.rgb, contrast);
    //c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);
//
    //COLOR.rgb = c;
//}
vec3 to_gray(vec3 tex)
{
	float avg = (tex.r + tex.g + tex.b) / 3.0;
	return vec3(avg);
}

void fragment() {
	vec4 color = texture(screen_texture, vec2(SCREEN_UV));
	vec3 graycolor = to_gray(color.rgb);
	COLOR = vec4(graycolor.r,graycolor.g,graycolor.b,COLOR.a);
} 