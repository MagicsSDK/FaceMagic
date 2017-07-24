//
//  FileUtil.m
//  HarryPhoto
//
//  Created by xuye on 13-1-12.
//  Copyright (c) 2013年 superteam. All rights reserved.
//

#import "FileUtil2.h"
#import <sys/xattr.h>
#import "util.h"

@interface FileUtil2 ()

@end

@implementation FileUtil2
static NSCondition *gWaitCondition;

+ (void)initContext
{
    if(!gWaitCondition) {
        gWaitCondition = [[NSCondition alloc] init];
    }
}

+ (NSString *)getPicturePath:(NSString *)uid fileName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@/magic", NSHomeDirectory(), uid];
    //NSLog(@"%@", filePath);
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        return [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    }
    if ([fm createDirectoryAtPath:filePath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil])
    {
        u_int8_t b = 1;
        setxattr([filePath fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
        //NSLog(@"%@/%@", filePath, fileName);
        return [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    }
    return nil;
}
//获取完整的文件路径
+ (NSString *)getFullFilePathInDocuments:(NSString *)subFilePath fileName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents%@", NSHomeDirectory(), subFilePath];
//    NSLog(@"function:%s,getFilePath %@", __FUNCTION__,filePath);
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        return [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    }
    if ([fm createDirectoryAtPath:filePath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil])
    {
        u_int8_t b = 1; 
        setxattr([filePath fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
        return [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    }
    return nil;
}

+ (void)removeFile:(NSString *)filePath
{
    NSError *e;
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:filePath error:&e];
}

+ (void)removeFilesInDocuments:(NSString *)subFilePath
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents%@", NSHomeDirectory(), subFilePath];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray *directoryContent = [fm contentsOfDirectoryAtPath:filePath error:NULL];
    for(NSInteger count = 0; count < (int)[directoryContent count]; count++)
    {
        @autoreleasepool {
            //NSLog(@"File %ld: %@", (count + 1), [directoryContent objectAtIndex:count]);
            NSError *e;
            [fm removeItemAtPath:[filePath stringByAppendingFormat:@"/%@", [directoryContent objectAtIndex:count]] error:&e];
        }
    }
}

+ (void)removeTmpFiles
{
    NSString *filePath = NSTemporaryDirectory();
    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray *directoryContent = [fm contentsOfDirectoryAtPath:filePath error:NULL];
    for(NSInteger count = 0; count < (int)[directoryContent count]; count++)
    {
        //NSLog(@"File %ld: %@", (count + 1), [directoryContent objectAtIndex:count]);
        NSError *e;
        [fm removeItemAtPath:[filePath stringByAppendingFormat:@"/%@", [directoryContent objectAtIndex:count]] error:&e];
        
    }
}

+ (void)moveFile:(NSString *)filePath to:(NSString *)targetFilePath
{
    NSError *error;
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm moveItemAtPath:filePath toPath:targetFilePath error:&error];
}

+ (void)copyFile:(NSString *)filePath to:(NSString *)targetFilePath
{
    NSError *error;
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm copyItemAtPath:filePath toPath:targetFilePath error:&error];
}

+ (BOOL)isFileExists:(NSString *)filePath
{
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

+ (NSArray *)getArrayFromFile:(NSString *)filePath
{
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    if(array == nil) {
        array = [NSArray array];
    }
    return array;
}

+ (NSDictionary *)getDictFromFile:(NSString *)filePath
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(dict == nil) {
        dict = [NSDictionary dictionary];
    }
    return dict;
}

+ (NSString *)getStringFromFile:(NSString *)filePath
{
    NSError *e;
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&e];
    return str;
}
//读取缓存图片
+ (NSMutableArray *)loadCachedPictures:(NSString *)cacheFileName inSubDir:(NSString *)subDir
{
    NSMutableArray *publishedPictureArray = [[NSMutableArray alloc] init];
    [gWaitCondition lock];
//    NSString *path = [self getFullFilePathInDocuments:subDir fileName:cacheFileName];
//    NSLog(@"path:%@",path);
    NSArray *array = [self getArrayFromFile:[self getFullFilePathInDocuments:subDir fileName:cacheFileName]];
   [gWaitCondition unlock];
    [publishedPictureArray addObjectsFromArray:array];
    return publishedPictureArray;
}

#pragma mark - 保存消息到本地 markByHem
+ (BOOL)saveCachedPictures:(NSArray *)pictures toFile:(NSString *)cacheFileName inSubDir:(NSString *)subDir
{
    [gWaitCondition lock];
    BOOL result = [pictures writeToFile:[self getFullFilePathInDocuments:subDir fileName:cacheFileName] atomically:YES];
    [gWaitCondition unlock];
    return result;
}

+ (BOOL)saveCachedPictures:(NSArray *)pictures toFilePath:(NSString *)filePath
{
    [gWaitCondition lock];
    BOOL result = [pictures writeToFile:filePath atomically:YES];
    [gWaitCondition unlock];
    return result;
}

+ (NSMutableArray *)loadCachedPictures:(NSString *)filePath
{
    NSMutableArray *publishedPictureArray = [[NSMutableArray alloc] init];
    [gWaitCondition lock];
    NSArray *array = [self getArrayFromFile:filePath];
    [gWaitCondition unlock];
    [publishedPictureArray addObjectsFromArray:array];
    return publishedPictureArray;
}

+ (void)copyDirectory:(NSString *)fromPath toPath:(NSString *)toPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
    }
    NSError *copyError = nil;
    if (![[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&copyError]) {
        NSLog(@"Error copying files: %@", [copyError localizedDescription]);
    }
}
@end
