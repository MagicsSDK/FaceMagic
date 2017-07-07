precision mediump float;

varying vec2 v_texcoord0;
varying vec2 v_texcoord1;
uniform sampler2D aTexture0;
uniform sampler2D aTexture1;
uniform float blendFrac;

void main()
{
    vec4 color1 = texture2D(aTexture0,v_texcoord0);
    vec4 color2 = texture2D(aTexture1,v_texcoord1);
    gl_FragColor.rgb = color1.rgb*color2.rgb;
    gl_FragColor.a = color1.a*color2.r;

}

