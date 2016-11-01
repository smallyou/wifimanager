//
//  WMCustomMenuCell.h
//  WifiManager
//
//  Created by 陈华 on 16/10/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMCustomMenuModel.h"

@class WMCustomMenuCell;

typedef void(^AnimationCompetaion)(WMCustomMenuCell *cell);

@interface WMCustomMenuCell : UICollectionViewCell

@property(nonatomic,strong) WMCustomMenuModel *customMenu;
@property(nonatomic,copy) AnimationCompetaion animationCompetationBlock;

-(void)setAnimation;

@end
