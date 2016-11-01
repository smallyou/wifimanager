//
//  CMFileTool.m
//  02-FileTool
//
//  Created by 陈华 on 16/8/9.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "CMFileTool.h"

@implementation CMFileTool

/**获取某个目录下的文件总大小*/
+(void)getTotalSizeAtPath:(NSString *)dir competation:(void(^)(NSUInteger totalSize))competation
{
    //1 获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //2 如果当前路径不是目录或文件不存在，直接抛出异常
    BOOL isDirectory;
    BOOL isExsit = [fileManager fileExistsAtPath:dir isDirectory:&isDirectory];
    if (!isExsit || !isDirectory) {
        //创建异常
        NSException *exception = [NSException exceptionWithName:@"file error" reason:@"path not exist or not directory" userInfo:nil];
        //抛出异常
        [exception raise];
    }
    
    //开启子线程--计算尺寸，计算完成后回调
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //3 获取路径下所有的子目录以及文件的名称，子目录的子目录
        NSArray *subPath = [fileManager subpathsAtPath:dir];
        
        //4 遍历subPath
        NSUInteger totalSize = 0;
        for (NSString *pathname in subPath) {
            //5 拼接路径
            NSString *path = [dir stringByAppendingPathComponent:pathname];
            //6 如果文件不存在或者是目录，继续下一个
            BOOL isDirectory;
            BOOL isExsit = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
            if (!isExsit || isDirectory) {
                continue;
            }
            //7 如果是隐藏文件，不计算，继续下一个遍历
            if ([[path pathExtension]isEqualToString:@"DS"]) {
                continue;
            }
            //8 获取当前文件的属性字典
            NSDictionary *attrDict = [fileManager attributesOfItemAtPath:path error:nil];
            //9 获取尺寸
            totalSize+=[attrDict fileSize];
        }
        
        //10 回到主线程，并回调
        dispatch_async(dispatch_get_main_queue(), ^{
           //回调
            competation(totalSize);
            
        });
    });
    
}

/**将totalSize转换成格式化的字符串*/
+(NSString *)formatString:(NSUInteger )totalSize
{
    NSString *str = [NSString stringWithFormat:@"%zd",totalSize];
    if (totalSize > 1000 * 1000) {
        //MB
        str = [NSString stringWithFormat:@"%.1fMB",totalSize/1000000.0];
    }
    else if (totalSize > 1000)
    {
        //KB
        str = [NSString stringWithFormat:@"%.1fKB",totalSize/1000.0];
    }
    else if(totalSize > 0)
    {
        //B
        str = [NSString stringWithFormat:@"%.1fB",totalSize * 1.0];
    }
    else{
        str = @"暂无缓存";
    }
    return str;
}



/**删除某个目录下的所有文件*/
+(void)cleanItemAtPath:(NSString *)dir competation:(void(^)())competation
{
    //1 获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //2 如果当前路径不存在或者是文件，抛出异常
    BOOL isDirectory;
    BOOL isExsit = [fileManager fileExistsAtPath:dir isDirectory:&isDirectory];
    if (!isExsit || !isDirectory) {
        //创建异常
        NSException *exception = [NSException exceptionWithName:@"file error" reason:@"path not exist or not directory" userInfo:nil];
        //抛出异常
        [exception raise];
    }
    
    //开启子线程--遍历并删除
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //3 获取路径下，一级目录和文件（仅仅拿到一级目录即可）
        NSArray *itemArray = [fileManager contentsOfDirectoryAtPath:dir error:nil];
        
        //4 遍历
        for (NSString *pathname in itemArray) {
            //5 拼接路径
            NSString *path = [dir stringByAppendingPathComponent:pathname];
            //6 如果是隐藏文件，不删除，继续下一个遍历
            if ([[path pathExtension]isEqualToString:@"DS"]) {
                continue;
            }
            //7 删除当前路径目录或文件
            [fileManager removeItemAtPath:path error:nil];
        }
        
        //8 回到主线程，回调block
        dispatch_async(dispatch_get_main_queue(), ^{
           
            competation();
            
        });
        
    });
    
    
}





@end
