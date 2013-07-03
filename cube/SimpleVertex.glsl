attribute vec4 Position; 
attribute vec4 SourceColor; 
//attribute vec3 coord3d;
attribute vec2 texcoord;
varying vec2 f_texcoord;
varying vec4 DestinationColor; 

uniform mat4 Projection;
uniform mat4 Modelview;

void main(void) {
    DestinationColor = SourceColor; 
    gl_Position = Projection * Modelview * Position;
    f_texcoord = texcoord;
}

