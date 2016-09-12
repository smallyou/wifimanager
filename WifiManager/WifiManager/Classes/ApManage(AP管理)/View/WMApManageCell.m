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
@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroudView;


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


@end
