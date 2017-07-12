precision mediump float;

varying vec2 v_texcoord0;
uniform sampler2D aTexture0;

void main()
{
    vec4 color0 = texture2D(aTexture0,v_texcoord0);
    gl_FragColor = color0*0.5 + 0.5*vec4(1.0, 1.0, 0.0, 0.5);
    gl_FragColor = color0;
}
