//
//  ParseBundle.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/11.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseBundle : NSObject
- (void) loadRes:(NSString*)_path;
@property(copy,nonatomic)NSString *effectName;
@property(assign,nonatomic)bool enableSensor;
@end
