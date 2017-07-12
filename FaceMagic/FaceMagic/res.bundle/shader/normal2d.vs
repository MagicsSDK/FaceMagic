precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;

varying vec2 v_texcoord0;

void main()
{
    v_texcoord0 = aTexcoord0;
    gl_Position = aMatrixVP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
}