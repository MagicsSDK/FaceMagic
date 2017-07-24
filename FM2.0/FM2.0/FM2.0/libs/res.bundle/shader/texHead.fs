precision mediump float;

uniform sampler2D aTexture0;
uniform sampler2D aTexture1;
uniform sampler2D aTexture2;

varying vec2 v_texcoord0;

void main()
{
    vec4 color1 = texture2D(aTexture0,v_texcoord0);
    vec4 color2 = texture2D(aTexture1,v_texcoord0);
    vec4 color3 = texture2D(aTexture2,v_texcoord0);

    gl_FragColor.rgb = color1.rgb*color2.rgb;
    gl_FragColor.a = color1.a*color2.r;

    gl_FragColor = gl_FragColor + color3;
}