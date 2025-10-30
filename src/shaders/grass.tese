#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
// Input: Bezier control points from tessellation control shader
layout(location = 0) in vec4 in_v0[];
layout(location = 1) in vec4 in_v1[];
layout(location = 2) in vec4 in_v2[];
layout(location = 3) in vec4 in_up[];

// Output: Pass data to fragment shader
layout(location = 0) out vec3 out_normal;
layout(location = 1) out float out_height;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	vec3 v0 = in_v0[0].xyz;
	vec3 v1 = in_v1[0].xyz;
	vec3 v2 = in_v2[0].xyz;
	vec3 up = in_up[0].xyz;
	
	float orientation = in_v0[0].w;
	float height = in_v1[0].w;
	float width = in_v2[0].w;

	//compute Bezier curve position along height
	//(1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
	float t = v;
	vec3 bezierPos = (1.0 - t) * (1.0 - t) * v0 + 
	                 2.0 * (1.0 - t) * t * v1 + 
	                 t * t * v2;
	
	vec3 tangent = 2.0 * (1.0 - t) * (v1 - v0) + 2.0 * t * (v2 - v1);
	if (length(tangent) > 0.0001) {
		tangent = normalize(tangent);
	} else {
		tangent = normalize(v2 - v0);
	}
	
	float cosTheta = cos(orientation);
	float sinTheta = sin(orientation);
	vec3 facing = normalize(cross(up, vec3(sinTheta, 0.0, cosTheta)));
	
	//triangular blade

	float widthCoeff = 1.0 - v;
	float currentWidth = width * widthCoeff;
	
	//width offset
	vec3 worldPos = bezierPos + (u - 0.5) * currentWidth * facing;
	gl_Position = camera.proj * camera.view * vec4(worldPos, 1.0);
    //normal and height
	out_normal = normalize(cross(tangent, facing));
	out_height = v;
}
