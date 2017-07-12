precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

varying vec2 vTexcoord0;
uniform vec2 uTexcoordFlip;
uniform vec2 uTex0size;
uniform vec2 uTex1size;

void main()
{
    vTexcoord0 = (aTexcoord0*uTex0size - 0.5)*uTexcoordFlip  + 0.5;
    gl_Position.x = aPosition.x*uTex1size.x*2.0 - 1.0;
    gl_Position.y = 1.0 - 2.0*aPosition.y*uTex1size.y;
    gl_Position.z = 0.0;
    gl_Position.w = 1.0;
    gl_PointSize = 3.0;
}
