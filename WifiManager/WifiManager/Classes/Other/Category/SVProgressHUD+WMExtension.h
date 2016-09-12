//
//  SVProgressHUD+WMExtension.h
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (WMExtension)

/**成功状态*/
+(void)successWithString:(NSString *)status;
/**失败状态*/
+(void)errorWithString:(NSString *)status;

@end
