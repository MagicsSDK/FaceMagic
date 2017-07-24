precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

varying vec2 v_texcoord0;

//uniform vec2 tex0size;
//uniform vec2 texcoordClip;


void main()
{
//    v_texcoord0 = (aTexcoord0*tex0size - 0.5)*texcoordClip  + 0.5;

    v_texcoord0 = aTexcoord0;
    vec4 t_pos = vec4(aPosition.x,-aPosition.y,0.0,1.0);
    gl_Position = t_pos;
}
