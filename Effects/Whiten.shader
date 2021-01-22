shader_type canvas_item;

uniform float progress : hint_range(0,1) = 0;
uniform vec4 color : hint_color = vec4(1,1,1,1);

vec3 interpolate_vec3(vec3 start, vec3 end, float delta){
    return start + (end - start) * delta;
}

void fragment(){
    vec4 origin = texture(TEXTURE, UV);
	vec3 rgb = vec3(color.r, color.g, color.b);
    COLOR.rgb = interpolate_vec3(origin.rgb, rgb, progress);
    COLOR.a = origin.a;
}