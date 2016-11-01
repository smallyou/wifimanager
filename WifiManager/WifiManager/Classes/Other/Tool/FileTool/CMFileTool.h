//
//  CMFileTool.h
//  FileTool
//
//  Created by 陈华 on 15/8/9.
//  Copyright © 2015年 陈华. All rights reserved.
//
//  文件工具类
//

#import <Foundation/Foundation.h>

@interface CMFileTool : NSObject

/**获取某个目录下的文件总大小*/
+(void)getTotalSizeAtPath:(NSString *)dir competation:(void(^)(NSUInteger totalSize))competation;

/**删除某个目录下的所有文件*/
+(void)cleanItemAtPath:(NSString *)dir competation:(void(^)())competation;

/**将totalSize转换成格式化的字符串*/
+(NSString *)formatString:(NSUInteger )totalSize;

@end
