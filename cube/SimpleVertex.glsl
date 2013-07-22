attribute vec4 Position;
attribute vec4 Normal;
attribute vec2 texcoord;
uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat4 NormalMatrix;
uniform vec3 LightPosition;
uniform vec3 AmbientMaterial;
uniform vec3 SpecularMaterial;
uniform vec3 DiffuseMaterial;
uniform float Shininess;
varying vec4 DestinationColor;
varying vec2 f_texcoord;
void main(void)
{

    NormalMatrix * 0.3;
    vec4 NormalTest = Normal;
    vec4 N4 =  Modelview * Normal;
    vec3 N = N4.xyz;
    
    N = normalize(N);
    vec3 L = normalize(LightPosition);
    vec3 E = vec3(0, 0, 1);
    vec3 H = normalize(L + E);
    float df = max(0.0, dot(N, L));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, Shininess);
    vec3 d = DiffuseMaterial;
    vec3 s = SpecularMaterial;
    vec3 a = AmbientMaterial;
    vec3 color = AmbientMaterial + df * DiffuseMaterial + sf * SpecularMaterial;
    //vec3 color = SpecularMaterial;
//    if (sf == 0.0) {
//        color = vec3(1.0,0.0,0.0);
//    }
//    else
//    {
//        color = vec3(0.0,1.0,0.0);
//    }
    DestinationColor = vec4(color,1.0);
    f_texcoord = texcoord;
    gl_Position = Projection * Modelview * Position;
}
