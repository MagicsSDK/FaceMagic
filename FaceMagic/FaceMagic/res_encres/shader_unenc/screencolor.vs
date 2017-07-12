precision mediump float;

attribute vec2 aPosition;
attribute vec2 aColor0;
attribute vec2 aTexcoord0;

void main()
{
    gl_PointSize = 4.0;
    gl_Position = vec4(aPosition.xy,0.0,1.0);
}
