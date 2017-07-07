precision mediump float;

varying vec4 v_color;
varying vec2 v_texcoord0;
uniform sampler2D aTexture0;

void main()
{
    mediump vec4 color1 = texture2D(aTexture0,v_texcoord0);
    gl_FragColor.rgba = v_color*color1;//color1.rgb*0.5+vec3(1.0,0.0,0.0)*0.5;
}
