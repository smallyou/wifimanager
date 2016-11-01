//
//  WMStateCell.h
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMApViewModel.h"

@class WMStateCell;

@protocol WMStateCellDelegate <NSObject>

-(void)stateCell:(WMStateCell *)stateCell didSettingBtnClick:(UIButton *)settingBtn;

@end

@interface WMStateCell : UITableViewCell

/**数据*/
@property(nonatomic,strong) WMApViewModel *viewModel;

/**代理*/
@property(nonatomic,weak) id<WMStateCellDelegate> delegate;

@end
