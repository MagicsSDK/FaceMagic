precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;
attribute vec2 aTexcoord1;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;

varying vec2 v_texcoord0;
varying vec2 v_texcoord1;

void main()
{
    v_texcoord0 = aTexcoord0;
    v_texcoord1 = aTexcoord1;
    vec4 t_pos = aMatrixVP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
    gl_Position = t_pos;
}