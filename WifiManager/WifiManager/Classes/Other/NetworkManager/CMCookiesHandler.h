//
//  CMCookiesHandler.h
//  01-WifiManager
//
//  Created by 23 on 16/8/19.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCookiesHandler : NSObject

/**持久化cookies*/
+(void)cookiesPersistence;

/**取出持久化cookies,并设置请求cookies*/
+(void)cookiesSetForRequest;

@end
