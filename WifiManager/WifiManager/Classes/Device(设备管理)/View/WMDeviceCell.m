//
//  WMDeviceCell.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMDeviceCell.h"

@interface WMDeviceCell()
//图片的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
//label的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeightConstraint;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation WMDeviceCell

- (void)awakeFromNib {
    // Initialization code
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //重新布局约束
    self.imageViewHeightConstraint.constant = self.cm_height * 0.7;
    self.nameLabelHeightConstraint.constant = self.cm_height * 0.3;
    
    
}


-(void)setDevice:(WMDeviceIcon *)device
{
    _device = device;
    self.iconImageView.image = [UIImage imageNamed:device.icon];
    self.nameLabel.text = device.name;
}


@end
