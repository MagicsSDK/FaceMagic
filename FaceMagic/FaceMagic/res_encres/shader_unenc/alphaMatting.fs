precision mediump float;

varying vec2 v_texcoord0;
uniform sampler2D aTexture0;

uniform vec4 colorMin;
uniform vec4 colorMax;
uniform vec4 colorOut;

uniform float blackValueMin;
uniform float blackValueMax;

uniform float graySaturationMin;
uniform float graySaturationMax;
uniform float grayValueMin;
uniform float grayValueMax;

uniform float whiteSaturationMin;
uniform float whiteSaturationMax;
uniform float whiteValueMin;
uniform float whiteValueMax;

uniform float redHueMin;
uniform float redHueMax;

uniform float orangeHueMin;
uniform float orangeHueMax;

uniform float yellowHueMin;
uniform float yellowHueMax;

uniform float greenHueMin;
uniform float greenHueMax;

uniform float cyanHueMin;
uniform float cyanHueMax;

uniform float blueHueMin;
uniform float blueHueMax;

uniform float purpleHueMin;
uniform float purpleHueMax;

uniform float pinkHueMin;
uniform float pinkHueMax;

//bool isTest()
//{
//    if (v_texcoord0.y > v_texcoord0.x) {
//        return true;
//    }
//    return false;
//}

vec4 rgb2hsv(vec4 colorRGB)
{
    if (colorRGB.r >= colorRGB.g && colorRGB.r >= colorRGB.b) {
        float v = colorRGB.r;
        float minC = 0.0;
        if (colorRGB.g >= colorRGB.b) {
            minC = colorRGB.b;
        } else {
            minC = colorRGB.g;
        }
        float s = 0.0;
        if (v > 0.0) {
            s = 1.0 - minC/v;
        } else {
            s = 0.0;
        }
        float h = 60.0*(colorRGB.g - colorRGB.b)/(v-minC);
        if (h<0.0) {
            h = h+360.0;
        }
        return vec4(h,s,v,colorRGB.a);
    }
    else if (colorRGB.g >= colorRGB.r && colorRGB.g >=colorRGB.b) {
        float v = colorRGB.g;
        float minC = 0.0;
        if (colorRGB.r >= colorRGB.b) {
            minC = colorRGB.b;
        } else {
            minC = colorRGB.r;
        }
        float s = 0.0;
        if (v > 0.0) {
            s = 1.0 - minC/v;
        } else {
            s = 0.0;
        }
        float h = 120.0+60.0*(colorRGB.b - colorRGB.r)/(v-minC);
        if (h<0.0) {
            h = h+360.0;
        }
        return vec4(h,s,v,colorRGB.a);
    }
    else if (colorRGB.b >= colorRGB.r && colorRGB.b >=colorRGB.g) {
        float v = colorRGB.b;
        float minC = 0.0;
        if (colorRGB.r >= colorRGB.g) {
            minC = colorRGB.g;
        } else {
            minC = colorRGB.r;
        }
        float s = 0.0;
        if (v > 0.0) {
            s = 1.0 - minC/v;
        } else {
            s = 0.0;
        }
        float h = 240.0+60.0*(colorRGB.r - colorRGB.g)/(v-minC);
        if (h < 0.0) {
           h = h+360.0;
        }
        return vec4(h,s,v,colorRGB.a);
    }
}

bool isBackGroundHSV()
{
    float colorSumR = 0.0;
    float colorSumG = 0.0;
    float colorSumB = 0.0;
    float colorSumA = 0.0;

    float colorAvgR = 0.0;
    float colorAvgG = 0.0;
    float colorAvgB = 0.0;
    float colorAvgA = 0.0;

    float j = 0.0;
    for (int i=0; i<10; i++) {
        float tx = 0.01;
        float ty = 0.99-0.015*j;
        vec4 colorLeft = texture2D(aTexture0, vec2(tx,ty));
        colorSumR += colorLeft.r;
        colorSumG += colorLeft.g;
        colorSumB += colorLeft.b;
        colorSumA += colorLeft.a;
        j = j + 1.0;
    }

    j = 0.0;
    for (int i=0; i<20; i++) {
        float tx = 0.01+0.04*j;
        float ty = 0.99;
        vec4 colorTop = texture2D(aTexture0, vec2(tx,ty));
        colorSumR += colorTop.r;
        colorSumG += colorTop.g;
        colorSumB += colorTop.b;
        colorSumA += colorTop.a;
        j = j + 1.0;
    }

    j = 0.0;
    for (int i=0; i<10; i++) {
        float tx = 0.99;
        float ty = 0.99-0.015*j;
        vec4 colorRight = texture2D(aTexture0, vec2(tx,ty));
        colorSumR += colorRight.r;
        colorSumG += colorRight.g;
        colorSumB += colorRight.b;
        colorSumA += colorRight.a;
        j = j + 1.0;
    }

    colorAvgR = colorSumR*0.025;
    colorAvgG = colorSumG*0.025;
    colorAvgB = colorSumB*0.025;
    colorAvgA = colorSumA*0.025;

    vec4 colorAvgHSV = rgb2hsv(vec4(colorAvgR, colorAvgG, colorAvgB, colorAvgA));

    vec4 colorTex = texture2D(aTexture0, v_texcoord0);
    vec4 colorTexHSV = rgb2hsv(colorTex);
    float minDelta = 0.2;
    float maxDelta = 0.2;
    colorAvgHSV.r = colorAvgHSV.r/360.0;

    if ((colorAvgHSV.r-minDelta*3.0) <= colorTexHSV.r && colorTexHSV.r <= (colorAvgHSV.r+maxDelta*3.0)
        && (colorAvgHSV.g-minDelta) <= colorTexHSV.g && colorTexHSV.g <= (colorAvgHSV.g+maxDelta)
        && (colorAvgHSV.b-minDelta) <= colorTexHSV.b && colorTexHSV.b <= (colorAvgHSV.b+maxDelta)
        ) {
        return true;
    } else {
        return false;
    }
}

//bool isBackGround()
//{
//    float colorSumR = 0.0;
//    float colorSumG = 0.0;
//    float colorSumB = 0.0;
//    float colorSumA = 0.0;
//
//    float colorAvgR = 0.0;
//    float colorAvgG = 0.0;
//    float colorAvgB = 0.0;
//    float colorAvgA = 0.0;
//
//    float j = 0.0;
//    for (int i=0; i<10; i++) {
//        float tx = 0.01;
//        float ty = 0.99-0.015*j;
//        vec4 colorLeft = texture2D(aTexture0, vec2(tx,ty));
//        colorSumR += colorLeft.r;
//        colorSumG += colorLeft.g;
//        colorSumB += colorLeft.b;
//        colorSumA += colorLeft.a;
//        j = j + 1.0;
//    }
//
//    j = 0.0;
//    for (int i=0; i<20; i++) {
//        float tx = 0.01+0.04*j;
//        float ty = 0.99;
//        vec4 colorTop = texture2D(aTexture0, vec2(tx,ty));
//        colorSumR += colorTop.r;
//        colorSumG += colorTop.g;
//        colorSumB += colorTop.b;
//        colorSumA += colorTop.a;
//        j = j + 1.0;
//    }
//
//    j = 0.0;
//    for (int i=0; i<10; i++) {
//        float tx = 0.99;
//        float ty = 0.99-0.015*j;
//        vec4 colorRight = texture2D(aTexture0, vec2(tx,ty));
//        colorSumR += colorRight.r;
//        colorSumG += colorRight.g;
//        colorSumB += colorRight.b;
//        colorSumA += colorRight.a;
//        j = j + 1.0;
//    }
//
//    colorAvgR = colorSumR*0.025;
//    colorAvgG = colorSumG*0.025;
//    colorAvgB = colorSumB*0.025;
//    colorAvgA = colorSumA*0.025;
//
//    vec4 colorTex = texture2D(aTexture0, v_texcoord0);
//    //float minFactor = 0.75;
//    //float maxFactor = 1.25;
//    float minDelta = 0.2;
//    float maxDelta = 0.2;
//
//    //if (colorAvgR*minFactor <= colorTex.r && colorTex.r <= colorAvgR*maxFactor
//    //    && colorAvgG*minFactor <= colorTex.g && colorTex.g <= colorAvgG*maxFactor
//    //    && colorAvgB*minFactor <= colorTex.b && colorTex.b <= colorAvgB*maxFactor
//    //    && colorAvgA*minFactor <= colorTex.a && colorTex.a <= colorAvgA*maxFactor) {
//    if ((colorAvgR-minDelta) <= colorTex.r && colorTex.r <= (colorAvgR+maxDelta)
//        && (colorAvgG-minDelta) <= colorTex.g && colorTex.g <= (colorAvgG+maxDelta)
//        && (colorAvgB-minDelta) <= colorTex.b && colorTex.b <= (colorAvgB+maxDelta)
//        && (colorAvgA-minDelta) <= colorTex.a && colorTex.a <= (colorAvgA+maxDelta)) {
//        return true;
//    } else {
//        return false;
//    }
//}


int getColorIndex(vec4 colorHSV)
{
    int index = 0;
    float h = colorHSV.r;
    float s = colorHSV.g;
    float v = colorHSV.b;

    if (v <= blackValueMax) {
        index = 0;
    } else if (s <= graySaturationMax) {
        if (v <= grayValueMax) {
            index = 1;
        } else {
            index = 2;
        }
    } else {
        if (redHueMin <= h || h <= redHueMax) {
            index = 3;
        } else if (orangeHueMin <= h && h <= orangeHueMax) {
            index = 4;
        } else if (yellowHueMin <= h && h <= yellowHueMax) {
            index = 5;
        } else if (greenHueMin <= h && h <= greenHueMax) {
            index = 6;
        } else if (cyanHueMin <= h && h <= cyanHueMax) {
            index = 7;
        } else if (blueHueMin <= h && h <= blueHueMax) {
            index = 8;
        } else if (purpleHueMin <= h && h <= purpleHueMax) {
            index = 9;
        } else if (pinkHueMin <= h && h <= pinkHueMax) {
            index = 10;
        }
    }

    return index;
}

int getBackGroundColorIndex()
{
    int colorDistribution[11];
    colorDistribution[0] = 0;
    colorDistribution[1] = 0;
    colorDistribution[2] = 0;
    colorDistribution[3] = 0;
    colorDistribution[4] = 0;
    colorDistribution[5] = 0;
    colorDistribution[6] = 0;
    colorDistribution[7] = 0;
    colorDistribution[8] = 0;
    colorDistribution[9] = 0;
    colorDistribution[10] = 0;
    int halfnum = 20;

    float j = 0.0;
    for (int i=0; i<10; i++) {
        float tx = 0.01;
        float ty = 0.99-0.015*j;
        vec4 colorLeft = texture2D(aTexture0, vec2(tx,ty));
        vec4 colorLeftHSV = rgb2hsv(colorLeft);
        int index = getColorIndex(colorLeftHSV);
        colorDistribution[index]++;
        if (colorDistribution[index] >= halfnum) {
            return index;
        }
        j = j + 1.0;
    }

    j = 0.0;
    for (int i=0; i<20; i++) {
        float tx = 0.01+0.04*j;
        float ty = 0.99;
        vec4 colorTop = texture2D(aTexture0, vec2(tx,ty));
        vec4 colorTopHSV = rgb2hsv(colorTop);
        int index = getColorIndex(colorTopHSV);
        colorDistribution[index]++;
        if (colorDistribution[index] >= halfnum) {
            return index;
        }
        j = j + 1.0;
    }

    j = 0.0;
    for (int i=0; i<10; i++) {
        float tx = 0.99;
        float ty = 0.99-0.015*j;
        vec4 colorRight = texture2D(aTexture0, vec2(tx,ty));
        vec4 colorRightHSV = rgb2hsv(colorRight);
        int index = getColorIndex(colorRightHSV);
        colorDistribution[index]++;
        if (colorDistribution[index] >= halfnum) {
            return index;
        }
        j = j + 1.0;
    }
    return -1;
}

bool isBackGroundColorIndex(int index, vec4 color)
{
    vec4 colorHSV = rgb2hsv(color);
    int colorIndex = getColorIndex(colorHSV);
    if (colorIndex == index) {
        return true;
    } else {
        return false;
    }
}

void main()
{
    vec4 color = texture2D(aTexture0,v_texcoord0);
    //if (colorMin.r <= color.r && color.r <= colorMax.r
    //    && colorMin.g <= color.g && color.g <= colorMax.g
    //    && colorMin.b <= color.b && color.b <= colorMax.b
    //    && colorMin.a <= color.a && color.a <= colorMax.a) {
    //    gl_FragColor = colorOut;
    //} else {
    //    gl_FragColor = color;
    //}

    //vec4 colorHSV = rgb2hsv(color);
    //colorHSV.r = 1.0;
    int colorBGIndex = getBackGroundColorIndex();
    bool isBG = isBackGroundColorIndex(colorBGIndex, color);
    //bool isBG = isBackGround();
    //bool isBG = isTest();
    //bool isBG = true;
    if (isBG) {
        //gl_FragColor = vec4(color.r, color.g, color.b, 0.0);
        gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
    } else {
        //gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
        gl_FragColor = color;
    }

    //gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);

}