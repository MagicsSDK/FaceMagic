precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

uniform vec2 texcoordClip;

varying vec2 v_texcoord0;

void main()
{
    v_texcoord0 = (aTexcoord0 - 0.5)*texcoordClip  + 0.5;

    vec4 t_pos = vec4(aPosition.x,aPosition.y,0.0,1.0);
    gl_Position = t_pos;

}
