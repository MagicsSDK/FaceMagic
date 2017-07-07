precision mediump float;

attribute vec3 aPosition;
attribute vec3 aNormal;
attribute vec2 aTexcoord0;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;

varying vec2 v_texcoord0;
varying vec3 v_ppos;
varying vec3 v_pnormal;

void main()
{
    v_texcoord0 = aTexcoord0;
    vec4 p_pos = aMatrixM*vec4(aPosition.xyz,1.0);
    v_ppos = p_pos.rgb;
//    vec4 p_normal =  aMatrixM*vec4(aNormal.xyz,1.0);
    v_pnormal = aNormal;
    gl_Position = aMatrixVP*aMatrixM*vec4(aPosition.xyz,1.0);
}
