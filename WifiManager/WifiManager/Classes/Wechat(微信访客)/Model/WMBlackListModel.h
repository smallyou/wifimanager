//
//  WMBlackListModel.h
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMBlackListModel : NSObject

@property(nonatomic,copy) NSString *addTime;
@property(nonatomic,copy) NSString *event;
@property(nonatomic,copy) NSString *mac;
@property(nonatomic,copy) NSString *releaseTime;

/**额外增加的属性*/
@property(nonatomic,copy) NSString *rate;
@property(nonatomic,copy) NSString *unit;



@end
