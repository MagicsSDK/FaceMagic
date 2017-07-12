//
//  FMScreenRender.m
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import "FMScreenRender.h"
#import "FMParameterGlobal.h"
#import "FMGlobalDef.h"
#import "FMShader.h"
#import "FMTexLoader.h"
#import "FMMainFBO.h"
@interface FMScreenRender(){
    GLuint  m_ScreenTextureID;
    GLuint  m_verID;
    GLuint  m_texcoordID;
    GLuint  m_indexID;
    GLuint  m_programmeID;
    float   m_texcoord_flip[2];
    int   m_Width;
    int   m_Height;
    unsigned char* rgbaBuffer;
}
@end
@implementation FMScreenRender
static FMScreenRender* m_Inst;
static dispatch_once_t onceToken;
+ (instancetype)shareInst {
    
    dispatch_once(&onceToken, ^{
        m_Inst = [[self alloc]init];
    });
    return m_Inst;
    
}
- (void)destory {
    glDeleteTextures(1, &m_ScreenTextureID);
    onceToken = 0;
    m_Inst = nil;
}
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;

}
- (void)initialize {
    m_Width = [FMParameterGlobal shareInst].m_Width;
    m_Height = [FMParameterGlobal shareInst].m_Height;
    m_texcoord_flip[0] = 1.0;
    m_texcoord_flip[1] = 1.0;
    
    m_programmeID = [[FMShader shareInst] getProgramme:@"screen"];
    [self createScreenTexture];
    [self initializeData];
}
- (void)createScreenTexture {
    FMTexture *t_backgroundTex = [FMTexLoader createRGBATexture:NULL Width:(int)m_Width Height:(int)m_Height Name:@"rgbaBackground"];
    m_ScreenTextureID = t_backgroundTex.texID;

}

- (void)setRGBAData:(GLubyte *)rgbaData {

    glBindTexture(GL_TEXTURE_2D, m_ScreenTextureID);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_Width, m_Height, GL_RGBA, GL_UNSIGNED_BYTE, rgbaData);
    
}

- (void)initializeData {
        m_verID = 0;
        m_texcoordID = 0;
        m_indexID = 0;
        //顶点
        glGenBuffers(1, &m_verID);
        glBindBuffer(GL_ARRAY_BUFFER, m_verID);
        GLfloat t_ver_point[8] = { -1.0f,-1.0f, 1.0f,-1.0f, -1.0f,1.0f, 1.0f,1.0f};
        glBufferData(GL_ARRAY_BUFFER, 8*sizeof(GLfloat), t_ver_point, GL_STATIC_DRAW);
        //纹理
        glGenBuffers(1, &m_texcoordID);
        glBindBuffer(GL_ARRAY_BUFFER, m_texcoordID);
//        GLfloat t_tex_point[8] = {0.0f,1.0f, 1.0f,1.0f, 0.0f,0.0f, 1.0f,0.0f};
        GLfloat t_tex_point[8] = {0.0f,0.0f, 1.0f,0.0f, 0.0f,1.0f, 1.0f,1.0f};
        glBufferData(GL_ARRAY_BUFFER, 8*sizeof(GLfloat), t_tex_point, GL_STATIC_DRAW);
        //索引
        glGenBuffers(1, &m_indexID);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexID);
        GLushort t_index[6] = {0,1,2,2,1,3};
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6*sizeof(GLushort), t_index, GL_STATIC_DRAW);
}
- (void)setTexcoordFlipX:(float)x_flip Y:(float)y_flip{
    m_texcoord_flip[0] = x_flip;
    m_texcoord_flip[1] = y_flip;
}
- (void)update {

    GLuint t_programmeID = m_programmeID;
    glUseProgram(t_programmeID);
    [self setTexcoordFlipX:1.0 Y:-1.0];
   // int t_blend_farc = glGetUniformLocation(t_programmeID, BLEND_FARC);
   // int t_texcoord_rot = glGetUniformLocation(t_programmeID, TEXCOORD_ROT);
    int u_texcoord_flip_loc = glGetUniformLocation(t_programmeID, TEXCOORD_FLIP);
    glUniform2fv(u_texcoord_flip_loc, 1, m_texcoord_flip);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, m_ScreenTextureID);
    int u_texture0_loc = glGetUniformLocation(t_programmeID, NAME_TEX0);
    glUniform1i(u_texture0_loc, 0);
    
}
- (void)render {

    [[FMMainFBO shareInst] activeContext];
    
    [self update];
    glDisable(GL_BLEND);
    
    glBindBuffer(GL_ARRAY_BUFFER, m_verID);
    glEnableVertexAttribArray(CHANNEL_POSITION);
    glVertexAttribPointer(CHANNEL_POSITION, 2, GL_FLOAT, GL_FALSE, 0, NULL);
    
    glBindBuffer(GL_ARRAY_BUFFER, m_texcoordID);
    glEnableVertexAttribArray(CHANNEL_TEXCOORD0);
    glVertexAttribPointer(CHANNEL_TEXCOORD0, 2, GL_FLOAT, GL_FALSE, 0, NULL);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_indexID);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, 0);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    glDisableVertexAttribArray(CHANNEL_POSITION);

    glDisableVertexAttribArray(CHANNEL_TEXCOORD0);
    
    glFinish();
}
- (int)getTexture{
    return m_ScreenTextureID;
}
@end
