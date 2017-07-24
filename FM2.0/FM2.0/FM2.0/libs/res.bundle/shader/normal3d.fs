precision highp float;

uniform sampler2D aTexture0;
varying vec2 v_texcoord0;


void main()
{
    mediump vec4 color1 = texture2D(aTexture0,v_texcoord0);
    gl_FragColor.rgba = color1;
}
