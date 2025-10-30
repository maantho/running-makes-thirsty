shader_type canvas_item;

uniform float value = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(UV.y < (1.0 - value)){
		COLOR.a = 0.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
