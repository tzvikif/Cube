varying lowp vec4 DestinationColor;
//uniform lowp float fade;
void main(void) {
    //gl_FragColor = DestinationColor; // New
    gl_FragColor = vec4(DestinationColor.x,DestinationColor.y,DestinationColor.z,1.0);
}