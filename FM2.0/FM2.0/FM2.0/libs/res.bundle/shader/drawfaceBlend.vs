precision mediump float;

attribute vec2 aPosition;
attribute vec2 aTexcoord0;
attribute vec2 aTexcoord1;
attribute vec2 aTexcoord2;

varying vec2 v_texcoord0;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;
uniform vec2 texcoordClip;
uniform vec2 tex0size;
uniform vec2 tex1size;
uniform vec2 tex2size;
uniform vec2 tex3size;
void main()
{
//    v_texcoord0 = (aTexcoord0*tex0size - 0.5)*texcoordClip  + 0.5;
//    gl_Position.x = aPosition.x*tex1size.x*2.0 - 1.0;
//    gl_Position.y = 1.0 - 2.0*aPosition.y*tex1size.y;
//    gl_Position.z = 0.0;
//    gl_Position.w = 1.0;
    
    v_texcoord0 = (aTexcoord0*tex0size - 0.5)*texcoordClip  + 0.5;
    v_texcoord1 = (aTexcoord1*tex1size - 0.5)*texcoordClip  + 0.5;
    v_texcoord2 = (aTexcoord2*tex2size - 0.5)*vec2(1.0,1.0)  + 0.5;
    gl_Position.x = aPosition.x*tex3size.x*2.0 - 1.0;
    gl_Position.y = 1.0 - 2.0*aPosition.y*tex3size.y;
    gl_Position.z = 0.0;
    gl_Position.w = 1.0;
//    gl_Position = vec4(aPosition.xy,0.0,1.0);
}
