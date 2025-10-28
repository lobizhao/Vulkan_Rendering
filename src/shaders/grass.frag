#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 in_normal;
layout(location = 1) in float in_height;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
    //directional lighting
    vec3 lightDir = normalize(vec3(0.5, 1.0, 0.4));
    float diffuse = max(dot(normalize(in_normal), lightDir), 0.0) * 0.5 + 0.5;
    
    //grass clo 
    vec3 baseColor = vec3(0.1, 0.4, 0.1); 
    vec3 tipColor = vec3(0.3, 0.8, 0.2);
    vec3 grassColor = mix(baseColor, tipColor, in_height);
    outColor = vec4(grassColor * diffuse, 1.0);
}
