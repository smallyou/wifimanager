//
//  WMPieChart.m
//  WifiManager
//
//  Created by 陈华 on 16/10/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMPieChart.h"

@implementation WMPieChart

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.descriptionTextColor = [UIColor whiteColor];
        self.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:10.0];
        self.showOnlyValues = YES;
        self.shouldHighlightSectorOnTouch = YES;
        self.labelPercentageCutoff = 0.001;
    }
    return self;
}

-(void)recompute
{
    [super recompute];
    self.innerCircleRadius = 0;
    
}



@end
