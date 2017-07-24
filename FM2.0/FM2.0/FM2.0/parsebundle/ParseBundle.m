//
//  ParseBundle.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/11.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "ParseBundle.h"

@implementation ParseBundle
- (instancetype)init{
    self = [super init];
    if (self) {
        self.enableSensor = false;
    }
    return self;
}
- (void) loadRes:(NSString*)_path{
    self.effectName = [_path lastPathComponent];
    self.effectName = [self.effectName stringByDeletingPathExtension];
    NSURL* jsonURL = [self sGetResURL:_path :nil :@"config.json"];
    NSData* jsonData = [NSData dataWithContentsOfURL:jsonURL];
    if(jsonData == nil)
    {
        NSLog(@"❌未找到配置文件(config.json)");
        return ;
    }
    NSError* err = nil;
    id configDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err || configDict == nil)
    {
        NSLog(@"😂config.json error: %@", err);
        return ;
    }
    
    NSArray *prompt = configDict[@"prompt"];
    if (prompt.count > 0) {
        
        
        
    }
    id paramObj = configDict[@"param"];
    if (paramObj) {
        for (NSDictionary *dic in paramObj) {
            id arObj = dic[@"AR"];
            if (arObj) {
                if ([arObj[@"Sensor"] intValue] == 1) {
                    NSDictionary *sensorDict = @{@"sensor":@"open"};
                    self.enableSensor = true;
                    
                }else{
                    NSDictionary *sensorDict = @{@"sensor":@"close"};
                    self.enableSensor = false;
                    
                }
            }else{
                NSDictionary *sensorDict = @{@"sensor":@"close"};
                self.enableSensor = false;
                
            }
        }
    }
}

- (NSURL*) sGetResURL:(NSString*) path :(NSBundle*) bundle :(NSString*) filename
{
    if(bundle != nil)
    {
        char name[512] = "", ext[512] = "";
        sscanf([filename UTF8String], "%[^.].%s", name, ext);
        return [bundle URLForResource:@(name) withExtension:@(ext)];
    }
    if( filename == nil )
    {
        return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", path] isDirectory:NO];;
    }
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, filename] isDirectory:NO];
}
@end
