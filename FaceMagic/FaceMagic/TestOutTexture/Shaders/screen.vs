precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

varying vec2 vTexcoord0;
uniform vec2 uTexcoordFlip;
void main()
{
    vTexcoord0 = (aTexcoord0 - 0.5)*uTexcoordFlip + 0.5;
    gl_Position = vec4(aPosition.xy,0.0,1.0);

}
