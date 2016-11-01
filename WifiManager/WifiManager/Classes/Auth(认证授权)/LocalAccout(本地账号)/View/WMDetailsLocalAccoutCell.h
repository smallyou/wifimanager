//
//  WMDetailsLocalAccoutCell.h
//  WifiManager
//
//  Created by 陈华 on 16/10/6.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMGroupAccoutModel,WMDetailsLocalAccoutCell;


@protocol  WMDetailsLocalAccoutCellDelegate <NSObject>

-(void)detailsLocalAccoutCell:(WMDetailsLocalAccoutCell *)accoutCell didRemoveBtnClick:(UIButton *)button;


@end


@interface WMDetailsLocalAccoutCell : UICollectionViewCell

@property(nonatomic,strong) WMGroupAccoutModel *accout;

@property(nonatomic,weak) id<WMDetailsLocalAccoutCellDelegate> delegate;



@end
