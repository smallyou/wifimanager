//
//  WMHeaderView.h
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMApViewModel.h"

@class WMHeaderView;

#pragma mark - 定义协议
@protocol WMHeaderViewDelegate <NSObject>

-(void)headerViewDidViewClick:(WMHeaderView *)headerView;

@end



@interface WMHeaderView : UITableViewHeaderFooterView

/**设置代理属性*/
@property(nonatomic,weak) id<WMHeaderViewDelegate> delegate;

/**设置数据*/
@property(nonatomic,strong) WMApViewModel *viewModel;


@end
