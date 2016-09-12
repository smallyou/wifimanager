//
//  WMNetworkCell.h
//  WifiManager
//
//  Created by 陈华 on 16/9/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMNetworkViewModel,WMNetworkCell;

#pragma mark - 协议

@protocol WMNetworkCellDelegate <NSObject>

@optional
-(void)networkCell:(WMNetworkCell *)networkCell didEnableBtnClick:(UIButton *)enableButton competation:(void(^)(BOOL success))competation;
-(void)networkCell:(WMNetworkCell *)networkCell didDisableBtnClick:(UIButton *)disableButton competation:(void(^)(BOOL success))competation;
-(void)networkCell:(WMNetworkCell *)networkCell didDeleteBtnClick:(UIButton *)deleteButton competation:(void(^)(BOOL success))competation;

@end



@interface WMNetworkCell : UITableViewCell

@property(nonatomic,strong) WMNetworkViewModel *viewModel;
@property(nonatomic,weak) id<WMNetworkCellDelegate> delegate;

@end
