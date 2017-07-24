precision mediump float;

varying vec2        v_texcoord0;
uniform sampler2D   aTexture0;
uniform vec2        samplerSteps;
uniform vec2        centralPos; //Real position for pixels.
uniform float       radius; //Range: [1.0, 1000.0]
uniform float       intensity; //Range: [-1.0, 1.0]

void main()
{
    vec2 realPosition = v_texcoord0 / samplerSteps;
    float dis = length(centralPos - realPosition);
    float len = dis/radius;
    if(len > 1.0)
    {
        gl_FragColor = texture2D(aTexture0, v_texcoord0);
    }
    else
    {
        float offset = 1.0 - len;
        offset = offset * offset * (3.0 - 2.0 * offset); //smoothstep:
        vec2 delta = centralPos - realPosition;
        vec2 step = intensity * delta * samplerSteps * offset;
        gl_FragColor = texture2D(aTexture0, v_texcoord0 + step);//*0.5 + vec4(0.0,1.0,0.0,1.0)*0.5;vec4(1.0,0.0,0.0,1.0);//
    }
}