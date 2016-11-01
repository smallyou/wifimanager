//
//  WMTempoGuestCell.h
//  WifiManager
//
//  Created by 陈华 on 16/10/6.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGuestAccoutModel,WMTempoGuestCell;

@protocol WMTempoGuestCellDelegate <NSObject>

-(void)tempoGuestCell:(WMTempoGuestCell *)guestCell didLongPress:(UILongPressGestureRecognizer *)longPress;

@end


@interface WMTempoGuestCell : UITableViewCell

@property(nonatomic,strong) WMGuestAccoutModel *accout;
@property(nonatomic,weak) id<WMTempoGuestCellDelegate> delegate;

@end
