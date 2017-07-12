precision mediump float;

attribute vec2 aPosition;
attribute vec4 aColor;

varying vec4 v_color;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;

void main()
{
    v_color = aColor/255.0;
    gl_Position = aMatrixVP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
    gl_PointSize = 10.0;
}
