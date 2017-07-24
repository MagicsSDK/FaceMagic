precision highp float;

varying highp vec2 v_texcoord0;
uniform sampler2D aTexture0;

uniform float verticesLeftFace[8];
uniform float verticesRightFace[8];

uniform float verticesRightEyes[5];
uniform float verticesLeftEyes[5];

uniform float verticesMouth[5];

uniform float isTrackingFace;

uniform int width;
uniform int height;

uniform float curveR0[200];
uniform float curveR1[56];
uniform float curveG0[200];
uniform float curveG1[56];
uniform float curveB0[200];
uniform float curveB1[56];

uniform float mvSmoothSize;
uniform float mvBlurDegree;

uniform float debugType;
uniform float useCurveAdjust;


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
    factor = 1.0;
    if (factor > 0.5) {
        vec4 init_color = texture2D(aTexture0, v_texcoord0);
        
        float addnum = 8.0;
        vec4 blur_color = init_color * addnum;
        float threth = 30.0/255.0;
        float location_x = 1.0 / float(width);
        float location_y = 1.0 / float(height);
        vec4 compare_color = texture2D(aTexture0, v_texcoord0 + mvSmoothSize*vec2( -4.0 * location_x, 0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += compare_color;
            addnum += 1.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + mvSmoothSize*vec2( -3.0 * location_x, 0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0*compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + mvSmoothSize*vec2( -2.0 * location_x,  0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0*compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + mvSmoothSize*vec2( -1.0 * location_x, 0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 3.0 *compare_color;
            addnum += 3.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 4.0 * location_x, 0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += compare_color;
            addnum += 1.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 3.0 * location_x,  0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0*compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 2.0 * location_x, 0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0 *compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( location_x, 0.0));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 3.0*compare_color;
            addnum += 3.0;
        }
        
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0,  -4.0 * location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += compare_color;
            addnum += 1.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0, -3.0 * location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0*compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0, -2.0 * location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0*compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0, -1.0 * location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 3.0*compare_color;
            addnum += 3.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0,  4.0 * location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += compare_color;
            addnum += 1.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0, 3.0 * location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0*compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0, 2.0 * location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 2.0*compare_color;
            addnum += 2.0;
        }
        compare_color = texture2D(aTexture0, v_texcoord0 + 1.0 * mvSmoothSize*vec2( 0.0, location_y));
        if(abs(compare_color.r - init_color.r) < threth)
        {
            blur_color += 3.0*compare_color;
            addnum += 3.0;
        }
        blur_color /= addnum;
        
        //highpass
        float hg = mv_green_mix(blur_color.r, init_color.r);
        float flag = step(hg, 0.5);
        hg = mv_high_mix(hg, flag);
        hg = mv_high_mix(hg, flag);
        hg = mv_high_mix(hg, flag);
        
        hg = clamp(hg, 0.0, 1.0);
        if(hg > 0.2){
            hg = pow((hg - 0.2) * 1.25, 0.5)*0.8 + 0.2;
        }
        hg = 1.0 - hg;
        hg = hg + 0.6;
        hg = clamp(hg, 0.0, 1.0);
        hg = hg - 0.6;
        hg = clamp(hg, 0.0, 1.0);
        hg = (hg-0.2)*4.0;
        hg = (hg-0.7)*2.0;
        hg = clamp(hg, 0.0, 1.0);
        vec4 diff = init_color - blur_color;
        blur_color += vec4(diff.r*hg, diff.r*hg, diff.r*hg, 0.0);
        blur_color = clamp(blur_color, vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0));
        
        if (useCurveAdjust > 0.5) {
            int index = 0;
            index = int(blur_color.r*255.0);
            if (index < 200) {
                blur_color.r = curveR0[index];
            } else {
                blur_color.r = curveR1[index-200];
            }
            index = int(blur_color.g*255.0);
            if (index < 200) {
                blur_color.g = curveG0[index];
            } else {
                blur_color.g = curveG1[index-200];
            }
            index = int(blur_color.b*255.0);
            if (index < 200) {
                blur_color.b = curveB0[index];
            } else {
                blur_color.b = curveB1[index-200];
            }
        }
        
        if (2.5 > debugType && debugType > 1.5) {
            gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
        } else if (1.5 > debugType && debugType > 0.5) {
            gl_FragColor = blur_color;
        } else {
            gl_FragColor = vec4(0.0, 1.0, 1.0, 1.0);
        }
    } else {
        if (0.5 < useCurveAdjust && useCurveAdjust < 1.5) {
            vec4 blur_color = texture2D(aTexture0, v_texcoord0);
            int index = 0;
            
            index = int(blur_color.r*255.0);
            if (index < 200) {
                blur_color.r = curveR0[index];
            } else {
                blur_color.r = curveR1[index-200];
            }
            index = int(blur_color.g*255.0);
            
            if (index < 200) {
                blur_color.g = curveG0[index];
            } else {
                blur_color.g = curveG1[index-200];
            }
            index = int(blur_color.b*255.0);
            
            if (index < 200) {
                blur_color.b = curveB0[index];
            } else {
                blur_color.b = curveB1[index-200];
            }
            gl_FragColor = blur_color;
        } else if (-0.5 < useCurveAdjust && useCurveAdjust < 0.5) {
            // five color bar rgb: (50,40,30) (100,80,60) (150,120,90) (200,180,150) (240,210,200)
            vec2 xy = v_texcoord0.xy;
            vec4 test_color = vec4(0.0, 0.0, 0.0, 1.0);
            if (xy.y < 0.2) {
                test_color = vec4(50.0/255.0, 40.0/255.0, 30.0/255.0, 1.0);
                test_color.r = curveR0[50];
                test_color.g = curveG0[40];
                test_color.b = curveB0[30];
            } else if (xy.y < 0.4) {
                test_color = vec4(100.0/255.0, 80.0/255.0, 60.0/255.0, 1.0);
                test_color.r = curveR0[100];
                test_color.g = curveG0[80];
                test_color.b = curveB0[60];
            } else if (xy.y < 0.6) {
                test_color = vec4(150.0/255.0, 120.0/255.0, 90.0/255.0, 1.0);
                test_color.r = curveR0[150];
                test_color.g = curveG0[120];
                test_color.b = curveB0[90];
            } else if (xy.y < 0.8) {
                test_color = vec4(200.0/255.0, 180.0/255.0, 150.0/255.0, 1.0);
                test_color.r = curveR1[0];
                test_color.g = curveG0[180];
                test_color.b = curveB0[150];
            } else {
                test_color = vec4(240.0/255.0, 210.0/255.0, 200.0/255.0, 1.0);
                test_color.r = curveR1[40];
                test_color.g = curveG1[10];
                test_color.b = curveB1[0];
            }
            
            int test_curve = 2;
            if (test_curve > 3) {
                int index = 0;
                
                index = int(test_color.r*255.0);
                if (index < 200) {
                    //test_color.r = curveR0[index];
                } else {
                    //test_color.r = curveR1[index-200];
                }
                
                index = int(test_color.g*255.0);
                if (index < 200) {
                    //test_color.g = curveG0[index];
                } else {
                    //test_color.g = curveG1[index-200];
                }
                
                index = int(test_color.b*255.0);
                if (index < 200) {
                    //test_color.b = curveB0[index];
                } else {
                    //test_color.b = curveB1[index-200];
                }
            }
            gl_FragColor = test_color;
        } else {
            //gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
            gl_FragColor = texture2D(aTexture0, v_texcoord0);
        }
    }
}
