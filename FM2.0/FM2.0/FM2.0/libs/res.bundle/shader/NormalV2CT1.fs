precision mediump float;

uniform sampler2D aTexture0;

varying vec4 v_color;
varying vec2 v_texcoord0;

void main()
{
    vec4 color1 = texture2D(aTexture0,v_texcoord0);
    gl_FragColor.rgba = v_color*color1;
}
