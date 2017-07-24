precision highp float;
varying vec2 v_texcoord0;
uniform sampler2D aTexture0;
uniform float width;
uniform float height;
void main(void) {
     vec3 ycoeff = vec3(0.256816, 0.504154, 0.0979137);
     vec2 nowTxtPos = v_texcoord0;
     vec2 texStep = vec2(1.0/width,1.0/height);
     if (v_texcoord0.x < 0.25) {
         vec4 texel1 = texture2D(aTexture0, v_texcoord0*vec2(4.0,1.0) + texStep*vec2(0.0,0.0));
         vec4 texel2 = texture2D(aTexture0, v_texcoord0*vec2(4.0,1.0) + texStep*vec2(1.0,0.0));
         vec4 texel3 = texture2D(aTexture0, v_texcoord0*vec2(4.0,1.0) + texStep*vec2(2.0,0.0));
         vec4 texel4 = texture2D(aTexture0, v_texcoord0*vec2(4.0,1.0) + texStep*vec2(3.0,0.0));
         y1 = dot(texel1.rgb, ycoeff) + 0.625;
         y2 = dot(texel2.rgb, ycoeff) + 0.625;
         y3 = dot(texel3.rgb, ycoeff) + 0.625;
         y4 = dot(texel4.rgb, ycoeff) + 0.625;
         gl_FragColor = vec4(y1, y2, y3, y4);
     }
     else {
         gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
     }
}