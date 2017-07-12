precision highp float;

attribute vec3 aPosition;
attribute vec2 aTexcoord0;
attribute vec3 aNormal;
attribute vec4 aBoneID;
attribute vec4 aBoneWeight;

varying vec2 v_texcoord0;
//varying vec3 v_Normal0;
//varying vec3 WorldPos0;

const int MAX_BONES = 30;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;
uniform mat4 gBones[MAX_BONES];

void main()
{
     mat4 BoneTransform = gBones[int(floor(aBoneID[0]))] * aBoneWeight[0];
     BoneTransform     += gBones[int(floor(aBoneID[1]))] * aBoneWeight[1];
     BoneTransform     += gBones[int(floor(aBoneID[2]))] * aBoneWeight[2];
     BoneTransform     += gBones[int(floor(aBoneID[3]))] * aBoneWeight[3];

     vec4 PosL    = BoneTransform * vec4(aPosition, 1.0);
     gl_Position  = aMatrixVP * aMatrixM * PosL;
     v_texcoord0    = aTexcoord0;
    //vec4 NormalL = BoneTransform * vec4(aNormal, 0.0);
    //Normal0      = (aMatrixM * aNormal).xyz;
    //WorldPos0    = (aMatrixM * PosL).xyz;

}