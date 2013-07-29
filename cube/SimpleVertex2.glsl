attribute vec4 Position;
attribute vec3 Normal;
attribute vec2 texcoord;

uniform mat4 NormalMatrix;
uniform mat4 View;
uniform mat4 Projection;
uniform mat4 Model;

varying vec4 f_eyeSpaceNormal;
varying vec2 f_texcoord;
varying vec4 f_position;

void main(void)
{    
    f_texcoord = texcoord;
    mat4 nm = NormalMatrix;
    f_eyeSpaceNormal = NormalMatrix * vec4(Normal,0.0);
    //f_eyeSpaceNormal = View * Model * vec4(Normal,0.0);
    f_position = View * Model * Position;
    gl_Position = Projection * View * Model * Position;
}
