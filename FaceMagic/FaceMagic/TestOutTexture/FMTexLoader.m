//
//  FMTexLoader.m
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/28.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import "FMTexLoader.h"
#import "FMTextureMgr.h"
@implementation FMTexLoader
+ (FMTexture *)createTextureWithImagePath:(NSString *)imagePath {
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        NSLog(@"fail load:%@",imagePath);
        return 0;
    }
    unsigned int t_w = 0;
    unsigned int t_h = 0;
    CGImageRef spriteImage = image.CGImage;
    t_w = image.size.width;
    t_h = image.size.height;
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(spriteImage));
    unsigned char *pixels = (GLubyte *)CFDataGetBytePtr(data);
    FMTexture *t_texture = nil;
    if (pixels != NULL) {
        NSString *t_texName = [imagePath lastPathComponent];
        t_texName = [t_texName stringByDeletingPathExtension];
        t_texture = [self createRGBATexture:pixels Width:t_w Height:t_h Name:t_texName];
    }else{
        NSLog(@"pixels Null");
    }
    
    CFRelease(data);
    return t_texture;
}


+ (FMTexture *)createRGBATexture:(unsigned char*)pixels Width:(int)width Height:(int)height Name:(NSString*)name{
    GLuint t_textureID = 0;
    glGenTextures(1, &t_textureID);
    glBindTexture(GL_TEXTURE_2D, t_textureID);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    FMTexture *t_texture = [[FMTexture alloc]init];
    t_texture.texName = name;
    t_texture.texID = t_textureID;
    t_texture.texWidth = width*1.0;
    t_texture.texHeight = height*1.0;
    [[FMTextureMgr shareInst] pushTexture:t_texture];
    return t_texture;
}
@end
