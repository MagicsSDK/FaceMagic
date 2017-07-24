precision highp float;

attribute vec3 aPosition;
attribute vec2 aTexcoord0;
attribute vec3 aNormal;
attribute vec4 aBoneID;
attribute vec4 aBoneWeight;

varying vec2 v_texcoord0;

const int MAX_BONES = 30;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;
uniform mat4 gBones[MAX_BONES];

void main()
{
    vec4 PosL    = vec4(aPosition, 1.0);
    gl_Position  = aMatrixVP * aMatrixM * PosL;
    v_texcoord0    = aTexcoord0;
    
}
