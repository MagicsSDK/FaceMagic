precision mediump float;

uniform sampler2D aTexture0;
varying vec2 v_texcoord0;
uniform float offsetX;
uniform float offsetY;

void main()
{
    vec2 t_coord = v_texcoord0 + vec2(offsetX,offsetY);
    if(t_coord.y < 0.0 )
    {
        t_coord.y = (1.0 + t_coord.y) ;
    }
    else if(t_coord.y > 1.0 )
    {
        t_coord.y = (t_coord.y - 1.0) ;
    }
    if(t_coord.x < 0.0 )
    {
        t_coord.x = (1.0 + t_coord.x) ;
    }
    else if(t_coord.x > 1.0 )
    {
        t_coord.x = (t_coord.x - 1.0) ;
    }
    gl_FragColor = texture2D(aTexture0,t_coord);
}

