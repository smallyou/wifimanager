//
//  WMApManageCell.m
//  WifiManager
//
//  Created by 陈华 on 16/9/11.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApManageCell.h"

@interface WMApManageCell()

#pragma mark - 控件属性

/**cell背景imageView*/
@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroudView;
/**AP名称*/
@property (weak, nonatomic) IBOutlet UILabel *apNameLabel;
/**IP地址*/
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;
/**MAC地址*/
@property (weak, nonatomic) IBOutlet UILabel *MACLabel;
/**频宽*/
@property (weak, nonatomic) IBOutlet UILabel *bandWidthLabel;
/**功率*/
@property (weak, nonatomic) IBOutlet UILabel *txPowerLabel;
/**信道*/
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
/**位置*/
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@end

@implementation WMApManageCell


#pragma mark - 设置UI

/**初始化界面*/
- (void)awakeFromNib {
    
    //1 设置背景色
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //2 设置cell的圆角
    self.cellBackgroudView.layer.cornerRadius = 20;
    self.cellBackgroudView.layer.masksToBounds = YES;
    
}

/**设置cell的尺寸*/
-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    frame.size.width -=20;
    frame.origin.x += 10;
    [super setFrame:frame];
}

#pragma mark - 设置数据
-(void)setViewModel:(WMApInfoViewModel *)viewModel
{
    _viewModel = viewModel;
    
    //1 取出Model
    WMApInfo *apInfo = viewModel.apInfo;
    
    //2 设置AP名称
    self.apNameLabel.text = apInfo.name;
    
    //3 设置IP地址
    self.IPLabel.text = viewModel.ipStr;
    
    //4 设置MAC地址
    self.MACLabel.text = viewModel.macStr;
    
    //5 设置频宽
    self.bandWidthLabel.text = viewModel.bandWidthStr;
    
    //6 设置功率
    self.txPowerLabel.text = viewModel.txPowerStr;
    
    //7 设置信道
    self.channelLabel.text = viewModel.channelStr;
    
    //8 设置位置
    self.positionLabel.text = viewModel.positionStr;
}


@end














