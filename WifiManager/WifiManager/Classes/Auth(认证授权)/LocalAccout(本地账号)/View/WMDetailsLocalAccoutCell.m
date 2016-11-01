//
//  WMDetailsLocalAccoutCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/6.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMDetailsLocalAccoutCell.h"
#import "WMGroupAccoutModel.h"

@interface WMDetailsLocalAccoutCell()

/**用户名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**描述信息*/
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
/**过期时间*/
@property (weak, nonatomic) IBOutlet UILabel *expirTimeLabel;
/**删除按钮*/
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end




@implementation WMDetailsLocalAccoutCell

- (void)awakeFromNib {
    // Initialization code
    
    
}


#pragma mark - 事件监听
/**删除按钮点击后的事件*/
- (IBAction)removeBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(detailsLocalAccoutCell:didRemoveBtnClick:)]) {
     
        [self.delegate detailsLocalAccoutCell:self didRemoveBtnClick:sender];
        
    }
}



#pragma mark - 动画及进入编辑状态
/**让当前cell进入可编辑状态*/
-(void)enableEditState
{
    [self setAnimation];
    self.removeButton.hidden = NO;
}

/**禁用编辑状态*/
-(void)disableEditState
{
   
    [self.layer removeAnimationForKey:@"rotation"];
    self.removeButton.hidden = YES;
}

/**设置动画*/
-(void)setAnimation
{
    [self.layer removeAnimationForKey:@"rotation"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.values = @[@(-0.02),@(0),@(0.02),@(0)];
    animation.duration = 0.25;
    animation.repeatCount = CGFLOAT_MAX;
    [self.layer addAnimation:animation forKey:@"rotation"];
}



#pragma mark - 设置数据
-(void)setAccout:(WMGroupAccoutModel *)accout
{
    _accout = accout;
    
    self.nameLabel.text = accout.name;
    self.descLabel.text = accout.desc;
    self.expirTimeLabel.text = accout.expiration;
    
    if (accout.edit) {
        [self enableEditState];
    }else{
        [self disableEditState];
    }
    
}


@end
