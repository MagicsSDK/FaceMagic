precision mediump float;

uniform sampler2D aTexture0;    //纹理色
uniform sampler2D aTexture1;    //法线图
uniform sampler2D aTexture2;

uniform vec3 uLightDir;
uniform vec3 uLightColor;
uniform vec3 uMatDiffuse;

varying vec2 v_texcoord0;

void main()
{
    vec3 normal = texture2D(aTexture1,v_texcoord0).rgb;
    vec3 texdiffuse = texture2D(aTexture0,v_texcoord0).rgb;
    vec3 diffuse = dot(-uLightDir,normal)*uLightColor*uMatDiffuse*texdiffuse;
    gl_FragColor.rgb = diffuse;
    gl_FragColor.a = 1.0;
}
