precision mediump float;

attribute vec2 aPosition;
attribute vec4 aColor;
attribute vec2 aTexcoord0;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;
uniform vec2 texcoordClip;

varying vec4 v_color;
varying vec2 v_texcoord0;

void main()
{
    v_texcoord0 = (aTexcoord0 - 0.5)*texcoordClip + 0.5;
    v_color = aColor/255.0;
    gl_Position = aMatrixVP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
    gl_PointSize = 10.0;
}
