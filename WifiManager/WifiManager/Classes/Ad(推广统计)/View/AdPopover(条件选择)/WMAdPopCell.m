//
//  WMAdPopCellCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAdPopCell.h"
#import "WMAdPopModel.h"

@interface WMAdPopCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *choseImageView;




@end


@implementation WMAdPopCell

- (void)awakeFromNib {
    // Initialization code
    self.choseImageView.hidden = YES;
    self.titleLabel.highlighted = NO;
}


-(void)setPopModel:(WMAdPopModel *)popModel
{
    _popModel = popModel;
    
    self.choseImageView.hidden = !popModel.isSelected;
    self.titleLabel.highlighted = popModel.isSelected;
    self.titleLabel.text = popModel.name;
}




@end
