//
//  FMMainFBO.m
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import "FMMainFBO.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <GLKit/GLKit.h>
@interface FMMainFBO(){
    
    GLuint  m_MainFboID;
    GLuint  m_Main_TextureID;
    EAGLContext *m_context;

}
@end

@implementation FMMainFBO
static FMMainFBO* m_Inst;
static dispatch_once_t onceToken;
+ (instancetype)shareInst {
    
    dispatch_once(&onceToken, ^{
        m_Inst = [[self alloc]init];
    });
    return m_Inst;
    
}
- (void)destory {
    if (m_Main_TextureID) {
        glDeleteTextures(1, &m_Main_TextureID);
        m_Main_TextureID = 0;
    }
    if (m_MainFboID) {
        glDeleteFramebuffers(1, &m_MainFboID);
        m_MainFboID = 0;
    }
    onceToken = 0;
    m_Inst = nil;
}
- (instancetype)init {
    
    self = [super init];
    if (self) {
        m_context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:m_context];
        m_MainFboID = 0;
        m_Main_TextureID = 0;
    }
    return self;
}
- (void)activeContext{
    
    [EAGLContext setCurrentContext:m_context];
   
}
- (void)bindFBO {
     glBindFramebuffer(GL_FRAMEBUFFER, m_MainFboID);
}
- (EAGLContext *)getContext{
    return m_context;
}
- (int)getTexture{
    return m_Main_TextureID;
}
- (void)initializeFBOWidth:(int)width Height:(int)height {
    
    [EAGLContext setCurrentContext:m_context];
    if (m_Main_TextureID == 0) {
    
        glGenTextures(1, &m_Main_TextureID);
        
    }
    glBindTexture(GL_TEXTURE_2D, m_Main_TextureID);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    if (m_MainFboID == 0) {
        glGenFramebuffers(1, &m_MainFboID);
        
    }
    glBindFramebuffer(GL_FRAMEBUFFER, m_MainFboID);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, m_Main_TextureID, 0);
    GLenum check = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (check != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"GenFramebuffer failed");
    }
    
}
@end
