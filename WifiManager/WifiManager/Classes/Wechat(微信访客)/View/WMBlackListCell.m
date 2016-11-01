//
//  WMBlackListCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMBlackListCell.h"
#import "WMBlackListModel.h"


@interface WMBlackListCell ()

@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;

@end



@implementation WMBlackListCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setBlackList:(WMBlackListModel *)blackList
{
    _blackList = blackList;
    
    self.macLabel.text = blackList.mac;
    self.addTimeLabel.text = blackList.addTime;
    self.reasonLabel.text = blackList.event;
    self.releaseTimeLabel.text = blackList.releaseTime;
    
    
}


@end
