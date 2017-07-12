precision mediump float;

varying vec2 vTexcoord0;
varying vec2 vTexcoord1;

uniform sampler2D aTexture0;
uniform sampler2D aTexture1;

uniform float blendfrac;

void main()
{
    mediump vec4 color1 = texture2D(aTexture0,vTexcoord0);
    mediump vec4 color2 = texture2D(aTexture1,vTexcoord1);
    gl_FragColor = (color1*(1.0 - blendfrac) + color2*blendfrac);
//    gl_FragColor = color1;
//    gl_FragColor.a = 1.0f;
}
