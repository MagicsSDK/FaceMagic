precision mediump float;

uniform sampler2D aTexture0;

varying vec2 v_texcoord0;
varying vec3 v_ppos;
varying vec3 v_pnormal;

uniform vec3 uLightDir;
uniform vec3 uLightColor;
uniform vec3 uMatDiffuse;

void main()
{
    //    vec3 uLightDir = vec3(0.0,0.0,1.0);
    
    vec3 ambient = uLightColor*0.2; //
    vec3 diffuse = dot(v_pnormal,-uLightDir)*uLightColor;
    
    
    vec3 campos = vec3(360.0,640.0,369.515);
    vec3 viewDir = normalize(campos-v_ppos);
    
    vec3 lightPos = vec3(360.0,200,369.515);
    
    vec3 lightDir = normalize(lightPos - v_ppos);
    
    vec3 reflectDir = reflect(-lightDir,v_pnormal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0),2.0);
    
    vec3 specular = 0.1* spec * uLightColor;
    vec4 texcolor = texture2D(aTexture0,v_texcoord0);
    
    gl_FragColor.rgb = (ambient + diffuse + specular)*uMatDiffuse*texcolor.rgb;
    //    gl_FragColor.rgb =  specular;
    gl_FragColor.a = texcolor.a;
}
