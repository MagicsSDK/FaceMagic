precision mediump float;

varying vec2 v_texcoord0;
uniform sampler2D aTexture0;

uniform vec2 samplerSteps;
uniform vec2 PointPosL; //Real position for pixels.
uniform vec2 PointPosR; //Real position for pixels.
uniform vec2 PointPos;
uniform float radius; //Range: [1.0, 1000.0]
uniform float intensity; //Range: [-1.0, 1.0]

void main()
{
    vec2 realPosition = v_texcoord0 / samplerSteps;
    float disL = length(PointPosL - realPosition);
    float disR = length(PointPosR - realPosition);
    float len = (disL+disR)/(2.0*radius);
    if(len > 1.0)
    {
        gl_FragColor = texture2D(aTexture0, v_texcoord0);
    }
    else
    {
        vec2 dis = PointPos - realPosition;
        float offset = 1.0 - len ;
        offset = offset * offset * (3.0 - 2.0 * offset);
        vec2 step = intensity * dis * samplerSteps * offset;
        gl_FragColor = texture2D(aTexture0, v_texcoord0 + step);//*0.5 + vec4(1.0,0.0,0.0,1.0)*0.5;;vec4(1.0,0.0,0.0,1.0);//
    }
}
