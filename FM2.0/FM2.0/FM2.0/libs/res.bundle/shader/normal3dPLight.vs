precision mediump float;

attribute vec3 aPosition;
attribute vec2 aTexcoord0;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;

varying vec2 v_texcoord0;

void main()
{
    v_texcoord0 = aTexcoord0;
    gl_Position = aMatrixVP*aMatrixM*vec4(aPosition.xyz,1.0);
}
