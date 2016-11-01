//
//  SVProgressHUD+WMExtension.m
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "SVProgressHUD+WMExtension.h"

@implementation SVProgressHUD (WMExtension)



+(void)successWithString:(NSString *)status
{
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD showSuccessWithStatus:status];
}

+(void)errorWithString:(NSString *)status
{
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD showErrorWithStatus:status];
}

+(void)infoWithString:(NSString *)status
{
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD showInfoWithStatus:status];
    
}

@end
