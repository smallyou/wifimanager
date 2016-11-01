//
//  WMCustomMenuCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMCustomMenuCell.h"

@interface WMCustomMenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WMCustomMenuCell

- (void)awakeFromNib {
    // Initialization code
}



-(void)setCustomMenu:(WMCustomMenuModel *)customMenu
{
    _customMenu = customMenu;
    self.iconImageView.image = [UIImage imageNamed:customMenu.icon];
    self.titleLabel.text = customMenu.title;
}


/**设置动画*/
-(void)setAnimation
{
    [self.layer removeAnimationForKey:@"rotation"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @0;
    animation.toValue = @(M_PI);
    animation.fillMode = kCAFillModeForwards;
    animation.repeatDuration = 1;
    animation.repeatCount = 1;
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:@"rotation"];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        //动画结束
        if (self.animationCompetationBlock) {
            self.animationCompetationBlock(self);
        }
    }
}

@end
