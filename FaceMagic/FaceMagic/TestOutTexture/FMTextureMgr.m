//
//  FMTextureMgr.m
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2017/2/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "FMTextureMgr.h"

@interface FMTextureMgr(){
    NSMutableArray *texturesPool;
}
@end
@implementation FMTextureMgr
static FMTextureMgr* m_Inst;
static dispatch_once_t onceToken;
+ (instancetype)shareInst {
    
    dispatch_once(&onceToken, ^{
        m_Inst = [[self alloc]init];
    });
    return m_Inst;
    
}
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        texturesPool = [[NSMutableArray alloc]init];
        
    }
    return self;
}
- (void)pushTexture:(FMTexture *)texture{
    if (texture) {
        [texturesPool addObject:texture];
    }
}
- (void)removeTexture:(FMTexture *)texture {
    if (texture) {
        [texturesPool removeObject:texture];
    }
}
- (void)removeAllTextures {
    [texturesPool removeAllObjects];
}
- (FMTexture*)getTextureWithName:(NSString *)textureName {
    
    FMTexture *t_texture = nil;
    for (FMTexture *texture in texturesPool) {
        if ([texture.texName isEqualToString:textureName]) {
            t_texture = texture;
            break;
        }
    }
    return t_texture;
}
- (void)destory {
    
    onceToken = 0;
    m_Inst = nil;
}
@end
