//
//  WMAdSummayCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAdSummayCell.h"
#import "WMDetailsInfoModel.h"

@interface WMAdSummayCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *last30dayLabel;


@end

@implementation WMAdSummayCell

- (void)awakeFromNib {
    // Initialization code
}


#pragma mark - 设置数据
-(void)setDetailsInfo:(WMDetailsInfoModel *)detailsInfo
{
    _detailsInfo = detailsInfo;
    
    
    self.titleLabel.text = detailsInfo.title;
    self.totalLabel.text = detailsInfo.total;
    self.todayLabel.text = detailsInfo.lastDay;
    self.last30dayLabel.text = detailsInfo.lastMonth;
    
    
}

@end
