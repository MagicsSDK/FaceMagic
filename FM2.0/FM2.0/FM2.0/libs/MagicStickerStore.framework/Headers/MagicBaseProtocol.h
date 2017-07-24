//
//  MagicBaseProtocol.h
//  魔贴商店Demo
//
//  Created by 村长在开会～ on 2017/5/24.
//  Copyright © 2017年 村长在开会～. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 排序依据
 */
typedef NS_ENUM(NSUInteger, OrderingType){
    /**
     *  评价
     */
    OrderingTypeScore = 1,
    /**
     *  id
     */
    OrderingTypeId = 2,
    /**
     *  降序
     */
    OrderingTypeDesc = 3,
    /**
     *  升序
     */
    OrderingTypeAsc = 4,
};

@interface MagicBaseProtocol : NSObject


//初始化MagicStickerStore SDK
+ (void)registerNetWorkWithClinetID:(NSString *)clinetID andClientSecret:(NSString *)secret success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure;

// 获取所有魔贴分类 返回所有分类 id 名字 下载量
+ (void)getMaigicStickerAllCategorySortField:(OrderingType)sortField andSortOrder:(OrderingType)sortOrder Success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure;

// 获取特定分类下的魔贴
+ (void)getAppointCategoryWithID:(NSString *)categorgID andPage:(NSString *)page andPageSize:(NSString *)pageSize success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure;

// 下载特定魔贴
+ (void)downloadStickerZipWithName:(NSString *)stickerName andSavePath:(NSString *)path networkingDownloadProgress:(void (^)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))downloadProgress success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure;
@end
