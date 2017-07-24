precision mediump float;
varying vec2 v_texcoord0;
uniform sampler2D aTexture0;
void main() {
    
    vec4 color = texture2D(aTexture0, v_texcoord0);
    gl_FragColor = color.bgra;
//        gl_FragColor = vec4(1.0,0.0,0.0,1.0);
}
