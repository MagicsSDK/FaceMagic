precision highp float;

varying highp vec2 v_texcoord0;
uniform sampler2D aTexture0;

uniform float verticesLeftFace[8];
uniform float verticesRightFace[8];

uniform float verticesRightEyes[5];
uniform float verticesLeftEyes[5];

uniform float verticesMouth[5];

uniform float isTrackingFace;
//uniform float verticesTracker[134];

uniform int width;
uniform int height;

//uniform float curve[256];
uniform float curve1[200];
uniform float curve2[56];
uniform float mvSmoothSize;
uniform float mvBlurDegree;

float contains(vec2 p) {
    vec2 f1 = vec2(0.0, 0.0);
    vec2 f2 = vec2(0.0, 0.0);
    float d = 0.0;
    float dist = 0.0;
    float constantLine = 0.0;
    float k = 0.0;
    float b = 0.0;

//            // Tracker data
//    vec2 pTracker = vec2(0.0, 0.0);
//    for (int i=0; i<34; i=i+2) {
//        pTracker = vec2(verticesTracker[i], verticesTracker[i+1]);
//        dist = distance(p, pTracker);
//        if (dist <= 0.005) {
//            return 3.0;
//        }
//    }

//            // Tracker data nose
//    pTracker = vec2(0.0, 0.0);
//    for (int i=54; i<62; i=i+2) {
//        pTracker = vec2(verticesTracker[i], verticesTracker[i+1]);
//        dist = distance(p, pTracker);
//        if (dist <= 0.005) {
//            return 3.0;
//        }
//    }
//
//            // Face center
//    vec2 pFaceCenter = vec2(verticesTracker[132], verticesTracker[133]);
//    dist = distance(p, pFaceCenter);
//    if (dist <= 0.005) {
//        return 3.0;
//    }
//
//            // Focus1
//    pTracker = vec2(verticesRightFace[0], verticesRightFace[1]);
//    dist = distance(p, pTracker);
//    if (dist <= 0.005) {
//        return 3.0;
//    }
//
//            // Focus2
//    pTracker = vec2(verticesRightFace[2], verticesRightFace[3]);
//    dist = distance(p, pTracker);
//    if (dist <= 0.005) {
//        return 3.0;
//    }
//
//            // Focus1
//    pTracker = vec2(verticesLeftFace[0], verticesLeftFace[1]);
//    dist = distance(p, pTracker);
//    if (dist <= 0.005) {
//        return 3.0;
//    }
//
//            // Focus2
//    pTracker = vec2(verticesLeftFace[2], verticesLeftFace[3]);
//    dist = distance(p, pTracker);
//    if (dist <= 0.005) {
//        return 3.0;
//    }

            // Left eyes
    f1 = vec2(verticesLeftEyes[0], verticesLeftEyes[1]);
    f2 = vec2(verticesLeftEyes[2], verticesLeftEyes[3]);
    d = verticesLeftEyes[4];
    dist = distance(p, f1) + distance(p, f2);
    if (dist <= d) { // in the Left eyes
        return 0.0;
    } else if (dist < 1.1*d){ // near the Left eyes
        return (dist/d - 1.0)*10.0;
    }

            // Right Eyes
    f1 = vec2(verticesRightEyes[0], verticesRightEyes[1]);
    f2 = vec2(verticesRightEyes[2], verticesRightEyes[3]);
    d = verticesRightEyes[4];
    dist = distance(p, f1) + distance(p, f2);
    if (dist <= d) {
        return 0.0;
    } else if (dist < 1.1*d){
        return (dist/d - 1.0)*10.0;
    }

            // Mouth
    f1 = vec2(verticesMouth[0], verticesMouth[1]);
    f2 = vec2(verticesMouth[2], verticesMouth[3]);
    d = verticesMouth[4];
    dist = distance(p, f1) + distance(p, f2);
    if (dist <= d) {
        return 0.0;
    } else if (dist < 1.1*d){
        return (dist/d - 1.0)*10.0;
    }

            // Left Face
    f1 = vec2(verticesLeftFace[0], verticesLeftFace[1]);
    f2 = vec2(verticesLeftFace[2], verticesLeftFace[3]);
    d = verticesLeftFace[4];
    constantLine = verticesLeftFace[5];
    k = verticesLeftFace[6];
    b = verticesLeftFace[7];

    if (constantLine > 0.0) {
        if (p.y > f1.y) {
            dist = distance(p, f1) + distance(p, f2);
            if (dist <= d) {
                return 1.0;
            } else if (dist < 1.1*d){
                return 1.0 - (dist/d - 1.0)*10.0;
            }
        } else {
        }
    } else {
        if (p.y > (k*p.x+b)) {
            dist = distance(p, f1) + distance(p, f2);
            if (dist <= d) {
                return 1.0;
            } else if (dist < 1.1*d){
                return 1.0 - (dist/d - 1.0)*10.0;
            }
        } else {
        }
    }
            
            // Right Face
    f1 = vec2(verticesRightFace[0], verticesRightFace[1]);
    f2 = vec2(verticesRightFace[2], verticesRightFace[3]);
    d = verticesRightFace[4];
    constantLine = verticesRightFace[5];
    k = verticesRightFace[6];
    b = verticesRightFace[7];

    if (constantLine > 0.0) {
        if (p.y < f1.y) {
            dist = distance(p, f1) + distance(p, f2);
            if (dist <= d) {
//                return 5.0+1.0;
                return 1.0;
            } else if (dist < 1.1*d){
//                return 5.0+1.0 - (dist/d - 1.0)*10.0;
                return 1.0 - (dist/d - 1.0)*10.0;
            }
        } else {
        }
    } else {
        if (p.y < (k*p.x+b)) {
            dist = distance(p, f1) + distance(p, f2);
            if (dist <= d) {
//                return 5.0+1.0;
                return 1.0;
            } else if (dist < 1.1*d){
//                return 5.0+1.0 - (dist/d - 1.0)*10.0;
                return 1.0 - (dist/d - 1.0)*10.0;
            }
        } else {
        }
    }

            // The Rest Part
    return 0.0;
}


float mv_green_mix(float g1, float g2)
{
    float g = g2 + 1.0 - 2.0 * g1;
    g = clamp(g, 0.0, 1.0);
    return mix(g, g2, 0.5);
}
            
            
float mv_high_mix(float hg, float flag)
{
    float g = clamp(hg, 0.0001, 0.9999);
    return mix(g/(2.0*(1.0-g)), 1.0 - (1.0-g)/(2.0*g), flag);
}


void main(void)
{
    vec2 uv  = v_texcoord0.xy;
    float factor = 0.0;
    if (isTrackingFace < 0.0) {
        factor = 1.0;
    } else {
        factor = 0.0;//contains(uv);
    }
            
    if (factor > 0.0) {
        vec4 init_color = texture2D(aTexture0, v_texcoord0);
        float smoothSize = mvSmoothSize * 0.02;
        vec4 blur_color  = texture2D(aTexture0, v_texcoord0 + smoothSize * vec2(-0.326212, -0.405805));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2(-0.840144, -0.073580));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2(-0.203345,  0.620716));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2( 0.962340, -0.194983));

        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2( 0.519456,  0.767022));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2( 0.185461, -0.893124));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2( 0.896420,  0.412458));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2(-0.321940, -0.932615));

        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2(-0.695914,  0.457137));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2( 0.473434, -0.480026));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2( 0.507431,  0.064425));
        blur_color += texture2D(aTexture0, v_texcoord0 + smoothSize * vec2(-0.791559, -0.597705));

        blur_color /= 12.0;


        ///highpass
        float hg = mv_green_mix(blur_color.g, init_color.g);

        float flag = step(hg, 0.5);
        hg = mv_high_mix(hg, flag);
        hg = mv_high_mix(hg, flag);
        hg = mv_high_mix(hg, flag);

        hg = clamp(hg, 0.0, 1.0);
        if(hg > 0.2){
            hg = pow((hg - 0.2) * 1.25, 0.5)/1.25 + 0.2;
        }
        hg = 1.0 - hg;

        vec4 high_color;
        high_color.a = 1.0;

//   high_color.r = curve[int(init_color.r*255.0)];
//   high_color.g = curve[int(init_color.g*255.0)];
//   high_color.b = curve[int(init_color.b*255.0)];
        int num = 0;
        num = int(init_color.r*255.0);
        if (num <= 199) {
            high_color.r = curve1[num];
        } else {
            high_color.r = curve2[num-200];
        }

        num = int(init_color.g*255.0);
        if (num <= 199) {
            high_color.g = curve1[num];
        } else {
            high_color.g = curve2[num-200];
        }

        num = int(init_color.b*255.0);
        if (num <= 199) {
            high_color.b = curve1[num];
        } else {
            high_color.b = curve2[num-200];
        }
            
        smoothSize = mvSmoothSize * 0.2 + 0.2;
        high_color = (init_color + smoothSize * hg * (high_color - init_color));

        ///overlap
        float tx = 1.0 / float(width);
        float ty = 1.0 / float(height);

        float lg = texture2D(aTexture0, v_texcoord0 + vec2(-tx,0.0)).g;
        lg += texture2D(aTexture0, v_texcoord0 + vec2(tx,0.0)).g;
        lg += texture2D(aTexture0, v_texcoord0 + vec2(0.0,-ty)).g;
        lg += texture2D(aTexture0, v_texcoord0 + vec2(0.0,ty)).g;
        lg = init_color.g * 0.5 + lg * 0.125;

        float a = mv_green_mix(lg, init_color.g);

        flag = step(0.5, a);
        init_color = mix((2.0 * a * high_color), (1.0 - 2.0 * (1.0-a) * (1.0-high_color)), flag);
        high_color = mix(init_color, high_color, 0.1);
            
        vec4 beautify_color = mix(high_color, blur_color, mvBlurDegree);
        init_color = texture2D(aTexture0, v_texcoord0);
        gl_FragColor = mix(init_color, beautify_color, factor);
        //gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
//        vec4 beautify_color = vec4(0.0, 1.0, 1.0, 1.0);
//        gl_FragColor = mix(init_color, beautify_color, factor);
//    } else if (factor > 4.9) {
//        factor -= 5.0;
//        vec4 init_color = texture2D(aTexture0, v_texcoord0);
//        vec4 beautify_color = vec4(1.0, 1.0, 0.0, 1.0);
//        gl_FragColor = mix(init_color, beautify_color, factor);
//    } else if (factor < 3.5 && factor > 2.5) {
//        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    } else {
        //gl_FragColor = texture2D(aTexture0, v_texcoord0);
        gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
//        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    }
}