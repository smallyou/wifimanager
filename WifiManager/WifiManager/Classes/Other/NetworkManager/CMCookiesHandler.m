//
//  CMCookiesHandler.m
//  01-WifiManager
//
//  Created by 23 on 16/8/19.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "CMCookiesHandler.h"
#define CMCookiesStoredKey @"CMCookiesStoredKey"

@implementation CMCookiesHandler

/**持久化cookies*/
+(void)cookiesPersistence
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:CMCookiesStoredKey];
    [defaults synchronize];

}

/**取出持久化cookies,并设置请求cookies*/
+(void)cookiesSetForRequest
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: CMCookiesStoredKey]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}


@end
