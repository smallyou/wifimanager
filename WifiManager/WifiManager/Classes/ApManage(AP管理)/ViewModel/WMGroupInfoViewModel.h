//
//  WMGroupInfoViewModel.h
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGroupInfo.h"

@interface WMGroupInfoViewModel : NSObject <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) WMGroupInfo *groupInfo;


@end
