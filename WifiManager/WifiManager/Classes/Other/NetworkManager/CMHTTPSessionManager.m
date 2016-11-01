//
//  CMHTTPSessionManager.m
//  01-WifiManager
//
//  Created by 23 on 16/8/19.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "CMHTTPSessionManager.h"
#import "CMCookiesHandler.h"

@implementation CMHTTPSessionManager

-(instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration ]) {
        
        //1 设置请求头
        [self.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

       
        
        //2 设置Cookies
        [CMCookiesHandler cookiesSetForRequest];
        
        //3 设置请求相关属性
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html"]];
        self.requestSerializer.HTTPShouldHandleCookies = YES;
    }
    return self;
}

@end
