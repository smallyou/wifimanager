//
//  WMTextField.m
//  WifiManager
//
//  Created by 陈华 on 16/8/31.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMTextField.h"

@implementation WMTextField

-(void)awakeFromNib
{
    NSDictionary *dict = @{NSForegroundColorAttributeName:[[UIColor whiteColor]colorWithAlphaComponent:0.5]};
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:self.placeholder attributes:dict];
    
    self.attributedPlaceholder = attr;
}

@end
