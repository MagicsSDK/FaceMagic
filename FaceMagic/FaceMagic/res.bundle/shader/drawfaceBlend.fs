precision mediump float;

varying vec2 v_texcoord0;
uniform sampler2D aTexture0;
varying vec2 v_texcoord1;
uniform sampler2D aTexture1;
varying vec2 v_texcoord2;
uniform sampler2D aTexture2;
//uniform float blendfrac;

void main()
{
    vec4 color0 =texture2D(aTexture0,v_texcoord0);      //mask
    vec4 color1 =texture2D(aTexture1,v_texcoord1);      //real background
    vec4 color2 =texture2D(aTexture2,v_texcoord2);      //alpha
    
    gl_FragColor.a = 1.0;
//    gl_FragColor.rgb = color0.rgb;
//    gl_FragColor.rgb = color2.rgb;
//    gl_FragColor.rgb = vec3(color2.r);
//    gl_FragColor.rgb = color0.rgb*vec3(color2.a);
//    gl_FragColor.rgb = vec3(1.0,0.0,0.0);
    gl_FragColor.rgb = color0.rgb*vec3(color2.a) +  color1.rgb*vec3(1.0-color2.a);
}
