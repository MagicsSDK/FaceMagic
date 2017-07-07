precision mediump float;

attribute vec3 aPosition;
attribute vec3 aNormal;
attribute vec2 aTexcoord0;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;


void main()
{
    gl_Position = aMatrixVP*aMatrixM*vec4(aPosition.xyz,1.0);
    //gl_Position = t_pos;
}
