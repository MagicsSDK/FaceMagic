precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;

varying vec2 vTexcoord0;
varying vec2 vTexcoord1;


uniform mat4 aMatrixM;
uniform mat4 aMatrixP;
uniform mat4 aMatrixV;
uniform mat4 aMatrixVP;
uniform mat4 aMatrixMVP;
void main()
{    
    vTexcoord0 = aTexcoord0;
    vTexcoord1 = aTexcoord0;
    vec4 t_pos = aMatrixVP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
//    vec4 t_pos = aMatrixMVP*vec4(aPosition.xy,0.0,1.0);
//    vec4 t_pos = aMatrixP*aMatrixV*aMatrixM*vec4(aPosition.xy,0.0,1.0);
//    vec4 t_pos = vec4(aPosition.xy,0.0,1.0)*aMatrixM*aMatrixP*aMatrixV;
//     vec4 t_pos = aMatrixV*aMatrixP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
//    vec4 t_pos = vec4(aPosition.xy,0.0,1.0);
    t_pos = t_pos/t_pos.w;
//    vec4 t_pos = vec4(aPosition.xy,0.0,1.0);
    gl_Position = t_pos;
}
