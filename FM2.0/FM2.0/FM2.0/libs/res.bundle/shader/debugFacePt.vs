precision mediump float;

attribute vec2 aPosition;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;
uniform vec2 tex0size;
uniform float ptsize;

void main()
{
    vec4 t_pos = aMatrixVP*aMatrixM*vec4(aPosition.x,aPosition.y,0.0,1.0);
    t_pos = t_pos/t_pos.w;
    gl_Position = t_pos;
    gl_PointSize = 10.0;
}