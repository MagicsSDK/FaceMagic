precision mediump float;
uniform vec4 u_color;
uniform sampler2D aTexture0;
varying vec2 v_texcoord0;


void main()
{
    mediump vec4 color1=texture2D(aTexture0, v_texcoord0);
    if(color1.a>0.0){
    gl_FragColor = u_color;
    }else{
     gl_FragColor = vec4(1.0,0.0,0.0,0.0);
    }

}

