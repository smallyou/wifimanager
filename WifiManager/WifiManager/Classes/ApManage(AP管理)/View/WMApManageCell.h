//
//  WMApManageCell.h
//  WifiManager
//
//  Created by 陈华 on 16/9/11.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMApInfoViewModel.h"

@interface WMApManageCell : UITableViewCell

/**提供属性供外界传值*/
@property(nonatomic,strong) WMApInfoViewModel *viewModel;

@end
