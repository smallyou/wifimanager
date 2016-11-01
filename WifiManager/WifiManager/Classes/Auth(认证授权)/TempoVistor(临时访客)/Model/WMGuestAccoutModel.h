//
//  WMGuestAccoutModel.h
//  WifiManager
//
//  Created by 陈华 on 16/10/6.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMGuestAccoutModel : NSObject

/**账户名*/
@property(nonatomic,copy) NSString *account;
/**创建者*/
@property(nonatomic,copy) NSString *creator;
/**创建时间*/
@property(nonatomic,copy) NSString *ctime;
/**过期时间*/
@property(nonatomic,copy) NSString *endtime;
/**是否过期*/
@property(nonatomic,assign) BOOL expired;
/**分组*/
@property(nonatomic,copy) NSString *group;
/**id*/
@property(nonatomic,copy) NSString *Id;
/**密码*/
@property(nonatomic,copy) NSString *password;
/**备注*/
@property(nonatomic,copy) NSString *remark;
/**行号*/
@property(nonatomic,copy) NSString *row_id;

@end
