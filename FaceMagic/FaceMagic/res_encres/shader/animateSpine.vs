precision mediump float;

attribute vec2 aPosition;
attribute vec4 aColor;
attribute vec2 aTexcoord0;
varying vec4 v_color;
varying vec2 v_texcoord0;

uniform mat4 aMatrixM;
uniform mat4 aMatrixVP;

void main()
{    
    v_texcoord0 = aTexcoord0;
    v_color = aColor/255.0;
    gl_Position = aMatrixVP*aMatrixM*vec4(aPosition.xy,0.0,1.0);
}