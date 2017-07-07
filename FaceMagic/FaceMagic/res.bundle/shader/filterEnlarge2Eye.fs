precision mediump float;

uniform sampler2D aTexture0;
varying vec2 v_texcoord0;

uniform vec2    samplerSteps;
uniform vec2    leftEyePos; //Real position for pixels.
uniform vec2    rightEyePos;
uniform vec2    radius; //Range: [1.0, 1000.0]
uniform float   intensity; //Range: [-1.0, 1.0]

void main()
{
    float offset;
    vec2 step;
    vec2 realPosition = v_texcoord0 / samplerSteps;
    vec2 dis = leftEyePos - realPosition;
    float len = length(dis);
    
    if(len < radius.x)
    {
        offset = 1.0 - len / radius.x;
        offset = smoothstep(0.0, 1.0, offset);// offset * offset * (3.0 - 2.0 * offset);
        step = intensity * dis * samplerSteps * offset;
        gl_FragColor = texture2D(aTexture0, v_texcoord0 + step);
        return;
    }
    
    dis = rightEyePos - realPosition;
    len = length(dis);
    
    if(len < radius.y)
    {
        offset = 1.0 - len / radius.y;
        offset = smoothstep(0.0, 1.0, offset);// offset * offset * (3.0 - 2.0 * offset);
        step = intensity * dis * samplerSteps * offset;
        gl_FragColor = texture2D(aTexture0, v_texcoord0 + step);
        return;
    }
    //gl_FragColor = texture2D(aTexture0, v_texcoord0);
}
