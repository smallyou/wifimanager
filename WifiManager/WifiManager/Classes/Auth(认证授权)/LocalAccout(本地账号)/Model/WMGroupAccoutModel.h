//
//  WMGroupAccoutModel.h
//  WifiManager
//
//  Created by 陈华 on 16/9/26.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMGroupAccoutModel : NSObject

/**是否默认组*/
@property(nonatomic,assign) BOOL isDefault;

/**描述*/
@property(nonatomic,copy) NSString *desc;

/**过期时间*/
@property(nonatomic,copy) NSString *expiration;

/**id*/
@property(nonatomic,copy) NSString *Id;

/**最近登录时间*/
@property(nonatomic,copy) NSString *logintime;

/**名称*/
@property(nonatomic,copy) NSString *name;

/**真实名称*/
@property(nonatomic,copy) NSString *realname;

/**状态*/
@property(nonatomic,assign) NSInteger status;

/**类型  1:用户组  0:用户*/
@property(nonatomic,assign) NSInteger type;

/**是否进入编辑状态*/
@property(nonatomic,assign) BOOL edit;

@end
