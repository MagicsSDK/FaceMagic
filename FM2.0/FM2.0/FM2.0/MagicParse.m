//
//  MagicParse.m
//  FM2.0
//
//  Created by 刘铭 on 2017/7/21.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "MagicParse.h"

@implementation MagicParse

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *) loadJsonWithPath:(NSString*)path{
    NSArray *jsonArray;
    NSData *JSONData = [NSData dataWithContentsOfFile:path];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    jsonArray = dataDic[@"cfg"];
    
    return jsonArray;
}

@end
