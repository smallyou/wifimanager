//
//  WMAlertEventCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAlertEventCell.h"
#import "WMAlertEventModel.h"

@interface WMAlertEventCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailsLabel;

@end

@implementation WMAlertEventCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setAlertEvent:(WMAlertEventModel *)alertEvent
{
    _alertEvent = alertEvent;
    
    self.timeLabel.text = alertEvent.time;
    self.typeLabel.text = alertEvent.type;
    self.eventDetailsLabel.text = alertEvent.event;
    
}




@end
