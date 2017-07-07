precision highp float;

varying vec2 v_texcoord0;
//varying vec3 v_Normal0;
//varying vec3 WorldPos0;

uniform sampler2D aTexture0;

void main()
{
    mediump vec4 color1 = texture2D(aTexture0,v_texcoord0);
    gl_FragColor.rgba = color1;//color1.rgb*0.5+vec3(1.0,0.0,0.0)*0.5;
}
