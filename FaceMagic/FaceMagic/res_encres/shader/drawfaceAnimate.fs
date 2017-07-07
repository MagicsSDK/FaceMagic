precision mediump float;

varying vec2 v_texcoord0;
uniform sampler2D aTexture0;
uniform sampler2D aTexture1;

void main()
{
    vec4 color0 = texture2D(aTexture0,v_texcoord0);
    vec4 color1 = texture2D(aTexture1,v_texcoord0);
    gl_FragColor.rgb = color0.rgb*(1.0-color1.a) + color1.rgb*color1.a;
    gl_FragColor.a = color0.a;
}