precision mediump float;

varying vec2 vTexcoord0;
uniform sampler2D aTexture0;

void main(){
    
    vec4 color = texture2D(aTexture0,vTexcoord0);
    gl_FragColor = vec4(color.b,color.g,color.r,color.a);
//    gl_FragColor = texture2D(aTexture0,vTexcoord0);
}
