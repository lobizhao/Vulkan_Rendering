
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs
// Bezier control points from vertex buffer
// for orientaion root positon
layout(location = 0) in vec4 v0;
// for height
layout(location = 1) in vec4 v1;
// for width
layout(location = 2) in vec4 v2;
// for stiffness paramenter
layout(location = 3) in vec4 up;

// Output
layout(location = 0) out vec4 out_v0;
layout(location = 1) out vec4 out_v1;
layout(location = 2) out vec4 out_v2;
layout(location = 3) out vec4 out_up;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs
	// Pass through v0 position as gl_Position
	gl_Position = vec4(v0.xyz, 1.0);
	
	// Pass Bezier control points to tessellation stage
	out_v0 = v0;
	out_v1 = v1;
	out_v2 = v2;
	out_up = up;
}
