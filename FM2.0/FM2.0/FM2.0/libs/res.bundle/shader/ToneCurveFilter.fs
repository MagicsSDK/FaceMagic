varying highp vec2 v_texcoord0;

uniform sampler2D   aTexture0;//这里输入的是原图
uniform sampler2D   aTexture1;//这里输入的是tonecurve图

 void main()
 {
     lowp vec4 textureColor = texture2D(aTexture0, v_texcoord0);
     lowp float redCurveValue = texture2D(aTexture1, vec2(textureColor.r, 0.0)).r;
     lowp float greenCurveValue = texture2D(aTexture1, vec2(textureColor.g, 0.0)).g;
     lowp float blueCurveValue = texture2D(aTexture1, vec2(textureColor.b, 0.0)).b;
     gl_FragColor = vec4(redCurveValue,greenCurveValue,blueCurveValue,1.0);
 }

