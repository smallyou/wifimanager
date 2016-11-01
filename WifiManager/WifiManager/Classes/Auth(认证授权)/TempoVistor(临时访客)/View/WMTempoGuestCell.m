//
//  WMTempoGuestCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/6.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMTempoGuestCell.h"
#import "WMGuestAccoutModel.h"

@interface WMTempoGuestCell ()

/**账户名和备注标签*/
@property (weak, nonatomic) IBOutlet UILabel *nameAndRemarkLabel;
/**过期时间标签*/
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;


@end

@implementation WMTempoGuestCell

- (void)awakeFromNib {
    // Initialization code
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCell:)];
    [self addGestureRecognizer:longPress];
    
    
}

-(void)longPressCell:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        if ([self.delegate respondsToSelector:@selector(tempoGuestCell:didLongPress:)]) {
            [self.delegate tempoGuestCell:self didLongPress:longPress];
        }
    }
}



-(void)setAccout:(WMGuestAccoutModel *)accout
{
    _accout = accout;
    
    if (accout.expired) {
        //如果过期了
        self.nameAndRemarkLabel.textColor = [UIColor redColor];
    }else{
        self.nameAndRemarkLabel.textColor = [UIColor blackColor];
    }
    
    NSString *nameRemark = [NSString stringWithFormat:@"%@ | %@",accout.account,accout.remark];
    self.nameAndRemarkLabel.text = nameRemark;
    
    NSString *expireTime = [NSString stringWithFormat:@"%@ 截止",accout.endtime];
    self.expireTimeLabel.text = expireTime;
}

@end
