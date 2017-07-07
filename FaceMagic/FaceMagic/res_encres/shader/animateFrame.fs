precision mediump float;

varying vec2 v_texcoord0;
varying vec2 v_texcoord1;

uniform sampler2D aTexture0;
uniform sampler2D aTexture1;

uniform float blendfrac;

void main()
{
    mediump vec4 color1 = texture2D(aTexture0,v_texcoord0);
    mediump vec4 color2 = texture2D(aTexture1,v_texcoord1);
    gl_FragColor = (color1*(1.0 - blendfrac) + color2*blendfrac);
}