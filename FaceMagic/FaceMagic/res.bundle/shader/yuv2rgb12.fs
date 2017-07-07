precision mediump float;

varying highp vec2 v_texcoord0;
uniform sampler2D aTexture0;    //l texture
uniform sampler2D aTexture1;    //l-r texture

void main (void){
    
    /*
    float cy = texture2D(aTexture0, v_texcoord0).r;
    float cb = texture2D(aTexture1, v_texcoord0).r;
    float cr = texture2D(aTexture1, v_texcoord0).a;
    mediump vec3 rgb;
    rgb = mat3(1,       1,         1,
               0,       -0.39465,  2.03211,
               1.13983, -0.58060,  0) * vec3(cy,cb-0.5,cr-0.5);
    gl_FragColor = vec4(rgb, 1.0);
     */
    
    mediump vec3 yuv;
    lowp vec3 rgb;
    //We had put the Y values of each pixel to the R,G,B components by
    //GL_LUMINANCE, that's why we're pulling it from the R component,
    //we could also use G or B
    vec4 c =vec4(texture2D(aTexture0, v_texcoord0).r-16.0/255.0)*1.164;
    //We had put the U and V values of each pixel to the A and R,G,B
    //components of the texture respectively using GL_LUMINANCE_ALPHA.
    //Since U,V bytes are interspread in the texture, this is probably
    //the fastest way to use them in the shader
    vec4 u= vec4(texture2D(aTexture1, v_texcoord0).r - 0.5);
    vec4 v = vec4(texture2D(aTexture1, v_texcoord0).a - 0.5);
    c += v * vec4(1.596, -0.813, 0, 0);
    c += u * vec4(0, -0.392, 2.017, 0);
    c.a = 1.0;
    
    //The numbers are just YUV to RGB conversion constants
    
    
    //We finally set the RGB color of our pixel
    gl_FragColor = c;

    
}
