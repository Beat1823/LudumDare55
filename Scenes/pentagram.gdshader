shader_type canvas_item;

uniform vec2 blood_points[600];
uniform int blood_num;
uniform float blood_radius;
uniform vec4 base_color : source_color;
uniform vec4 set_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	bool covered = false;
	
	for (int i = 0; i<blood_num; ++i)
	{
		vec2 diff = VERTEX - blood_points[i];
		float dist2 = diff.x * diff.x + diff.y * diff.y;
		
		if (dist2 < blood_radius * blood_radius)
		{
			covered = true;
		}
	}
	
	if (covered)
	{
		COLOR = set_color * 3.0;
	}
	else
	{
		COLOR = base_color;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
