precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;
uniform vec2 tex0size;
uniform vec2 tex1size;
uniform vec2 texcoordClip;
varying vec2 v_texcoord0;

void main()
{
    v_texcoord0 = aTexcoord0*tex0size;//(aTexcoord0*tex0size - 0.5)*texcoordClip  + 0.5;
    vec4 t_pos = aMatrixVP*aMatrixM*vec4(aPosition.x,aPosition.y,0.0,1.0);
    //gl_Position.x = aPosition.x*tex1size.x*2.0 - 1.0;
    //gl_Position.y = 1.0 - 2.0*aPosition.y*tex1size.y;
    //gl_Position.z = 0.0;
    gl_Position = t_pos;
    gl_PointSize = 10.0;
}
