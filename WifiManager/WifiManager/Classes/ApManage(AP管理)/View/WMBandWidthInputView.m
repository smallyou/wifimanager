//
//  WMBandWidthInputView.m
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMBandWidthInputView.h"

@implementation WMBandWidthInputView

+(instancetype)bandWidthInputView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}


@end
