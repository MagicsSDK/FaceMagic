precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

varying vec2 v_texcoord0;
uniform vec2 texcoordClip;
uniform vec2 tex0size;
uniform vec2 tex1size;

void main()
{
    v_texcoord0 = (aTexcoord0*tex0size - 0.5)*texcoordClip  + 0.5;
    gl_Position.x = aPosition.x*tex1size.x*2.0 - 1.0;
    gl_Position.y = 1.0 - 2.0*aPosition.y*tex1size.y;
    gl_Position.z = 0.0;
    gl_Position.w = 1.0;
    gl_PointSize = 3.0;
}
