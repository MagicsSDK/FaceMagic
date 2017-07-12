//
//  FMShader.m
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import "FMShader.h"
#import <OpenGLES/ES2/glext.h>
#import "FMGlobalDef.h"
#import "FMMainFBO.h"
@interface FMShader(){
    NSMutableDictionary *m_fsID_Dict;
    NSMutableDictionary *m_vsID_Dict;
    NSMutableDictionary *m_programmeID_Dict;
}
@end
@implementation FMShader
static FMShader* m_Inst;
static dispatch_once_t onceToken;
+ (instancetype)shareInst {
    
    dispatch_once(&onceToken, ^{
        m_Inst = [[self alloc]init];
    });
    return m_Inst;
    
}
- (void)destory {
    onceToken = 0;
    m_Inst = nil;
}
- (instancetype)init {
    
    self = [super init];
    if (self) {
        m_fsID_Dict = [[NSMutableDictionary alloc]init];
        m_vsID_Dict = [[NSMutableDictionary alloc]init];
        m_programmeID_Dict = [[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)initializeAllShaders {
    [[FMMainFBO shareInst] activeContext];
    NSString *shaderconfPath = [[NSBundle mainBundle] pathForResource:@"shaderconf" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:shaderconfPath];
    if (!data) {
        NSLog(@"don't have shaderconf");
        return;
    }
    NSError* err = nil;
    NSDictionary *shaderDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
//    NSDictionary *shaderDict = [[NSDictionary alloc]initWithContentsOfFile:shaderconfPath];
   
    
    NSArray *conf = shaderDict[@"shader"];
    for (NSDictionary *dic in conf) {
        NSString *programmeName = dic[@"programme"];
        NSString *vsName = dic[@"vs"];
        NSString *fsName = dic[@"fs"];
        NSString *screen_vs_path = [[NSBundle mainBundle]pathForResource:vsName ofType:@"vs"];
        GLuint t_vs_id = [self loadVSEx:screen_vs_path Name:vsName];
        
        NSString *screen_fs_path = [[NSBundle mainBundle]pathForResource:fsName ofType:@"fs"];
        GLuint t_fs_id = [self loadFSEx:screen_fs_path Name:fsName];
        
        [self createProgramWithVS:t_vs_id andFS:t_fs_id Name:programmeName];
    }
    
    
}
- (GLuint)createProgramWithVS:(GLuint)vsid andFS:(GLuint)fsid Name:(NSString*)name{
    NSNumber* t_id_num = [m_programmeID_Dict objectForKey:name];
    if( t_id_num == nil)
    {
        unsigned int t_programme_id = [self createProgramWithVS:vsid andFS:fsid ];
        NSNumber *t_programme_id_num = [NSNumber numberWithInt:t_programme_id];
        [m_programmeID_Dict setObject:  t_programme_id_num forKey:name];
        return t_programme_id;
    }
    else
    {
        return [t_id_num intValue];
    }
}
- (GLuint)createProgramWithVS:(GLuint)vsid andFS:(GLuint)psid {
    
    GLuint t_program_id = glCreateProgram();
    glAttachShader(t_program_id, vsid);
    glAttachShader(t_program_id, psid);
    
    //bind
    glBindAttribLocation(t_program_id, CHANNEL_POSITION, NAME_POSITION);
    glBindAttribLocation(t_program_id, CHANNEL_NORMAL, NAME_NORMAL);
    glBindAttribLocation(t_program_id, CHANNEL_COLOR, NAME_COLOR);
    glBindAttribLocation(t_program_id, CHANNEL_TEXCOORD0, NAME_TEXCOORD0);
    glBindAttribLocation(t_program_id, CHANNEL_TEXCOORD1, NAME_TEXCOORD1);
    glBindAttribLocation(t_program_id, CHANNEL_TEXCOORD2, NAME_TEXCOORD2);
    
    //
    glLinkProgram(t_program_id);
    GLint linkstatus;
    glGetProgramiv(t_program_id,GL_LINK_STATUS , &linkstatus);
    if( linkstatus == GL_FALSE )
    {
        //cerr << "Error" << endl;
    }
    else
    {
        glUseProgram(t_program_id);
    }
    
    return t_program_id;
}
- (GLuint)loadVSEx:(NSString*)filename Name:(NSString*)name{
    NSNumber* t_id_num = [m_vsID_Dict objectForKey:name];
    if( t_id_num == nil)
    {
        unsigned int t_vs_id = [self loadVS:filename];
        NSNumber *t_vs_id_num = [NSNumber numberWithInt:t_vs_id];
        [m_vsID_Dict setObject:  t_vs_id_num forKey:name];
        return t_vs_id;
    }
    else
    {
        return [t_id_num intValue];
    }
}

- (GLuint)loadFSEx:(NSString *)filename Name:(NSString*)name{
    NSNumber* t_id_num = [m_fsID_Dict objectForKey:name];
    if( t_id_num == nil)
    {
        unsigned int t_fs_id = [self loadFS:filename];
        NSNumber *t_fs_id_num = [NSNumber numberWithInt:t_fs_id];
        [m_fsID_Dict setObject:  t_fs_id_num forKey:name];
        return t_fs_id;
    }
    else
    {
        return [t_id_num intValue];
    }
}

- (GLuint)loadVS:(NSString*)filename {
    
    NSError *error;
    NSString *vs_string = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    const char* vs_shader = [vs_string UTF8String];
    
    if( vs_shader == NULL )
        return 0;
    GLuint m_vs_id = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(m_vs_id, 1, &vs_shader, 0);
    glCompileShader(m_vs_id);
    
    GLint compileErr = 0;
    glGetShaderiv(m_vs_id,GL_COMPILE_STATUS,&compileErr);
    if(GL_FALSE == compileErr )
    {
        GLint logLen;
        glGetShaderiv(m_vs_id, GL_INFO_LOG_LENGTH, &logLen);
        if(logLen>0){
            char* log = (char*)malloc(logLen);
            GLsizei written;
            glGetShaderInfoLog(m_vs_id, logLen, &written, log);
            printf("vs shader compile error log : \n %s \n",log);
            free(log);
        }
        m_vs_id = 0;
    }
    return m_vs_id;
}

- (GLuint)loadFS:(NSString *)filename {
    
    NSString *fs_string = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
    const char* fs_shader = [fs_string UTF8String];
    if( fs_shader == NULL )
        return 0;
    GLuint m_fs_id = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(m_fs_id, 1, &fs_shader, 0);
    glCompileShader(m_fs_id);
    
    GLint compileErr = 0;
    glGetShaderiv(m_fs_id,GL_COMPILE_STATUS,&compileErr);
    if(GL_FALSE == compileErr )
    {
        GLint logLen;
        glGetShaderiv(m_fs_id, GL_INFO_LOG_LENGTH, &logLen);
        if(logLen>0){
            char* log = (char*)malloc(logLen);
            GLsizei written;
            glGetShaderInfoLog(m_fs_id, logLen, &written, log);
            printf("fs shader compile error log : \n %s \n",log);
            free(log);
        }
        m_fs_id = 0;
    }
    return m_fs_id;
}
- (int)getProgramme:(NSString *)programmeName{
    NSNumber *programmeID_num = m_programmeID_Dict[programmeName];
    if (programmeID_num) {
        return [programmeID_num intValue];
    }
    
    return 0;
}
@end
