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
    vec4 t_pos = aMatrixVP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
    v_texcoord1.x = t_pos.x/t_pos.w*0.5+0.5;
    v_texcoord1.y = 0.5-t_pos.y/t_pos.w*0.5;
    gl_Position = t_pos;
}


