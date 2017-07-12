//
//  FMTexture.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2017/2/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTexture : NSObject
@property(assign,nonatomic)int texID;
@property(assign,nonatomic)float texWidth;
@property(assign,nonatomic)float texHeight;
@property(copy,nonatomic)NSString *texName;
@end
