uniform sampler2D mytexture;
uniform highp vec4 LightPosition;
uniform mediump vec3 AmbientMaterial;
uniform mediump vec3 SpecularMaterial;
uniform mediump vec3 DiffuseMaterial;
uniform mediump float Shininess;

varying mediump vec2 f_texcoord;
varying highp vec4 f_eyeSpaceNormal;
varying highp vec4 f_position;

void main(void) {
//    mediump vec2 flipped_texcoord = vec2(f_texcoord.x, 1.0 - f_texcoord.y);
//    gl_FragColor = texture2D(mytexture, flipped_texcoord) * DestinationColor;
    
    highp vec3 N = normalize(f_eyeSpaceNormal.xyz);
    highp vec3 L = normalize(LightPosition.xyz - f_position.xyz);
    highp vec3 E = vec3(0,0,1);
    highp vec3 H = normalize(L + E);
    
    
    highp float df = max(0.0,dot(N,L));
    highp float sf = max(0.0, dot(N, H));
    sf = pow(sf, Shininess);
    lowp vec3 color = AmbientMaterial + df * DiffuseMaterial + sf * SpecularMaterial;
//    if (0.0 <= df && df < 0.25 ) {
//        color = vec3(1.0,0.0,0.0);
//    }
//    if (0.25 <= df && df <= 0.5 ) {
//        color = vec3(1.0,0.0,1.0);
//    }
//    if (0.5 <= df && df < 0.75 ) {
//        color = vec3(1.0,1.0,0.0);
//    }
//    if (0.75 <= df && df <= 1.0 ) {
//        color = vec3(0.0,0.0,1.0);
//    }
    gl_FragColor = vec4(color, 1);
    //gl_FragColor = DestinationColor;
    //gl_FragColor = vec4(1.0,0.0,0.8,1.0);
}