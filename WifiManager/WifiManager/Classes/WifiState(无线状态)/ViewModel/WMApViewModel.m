//
//  WMApViewModel.m
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApViewModel.h"

@implementation WMApViewModel

/**初始化构造方法*/
-(instancetype)initWithAccessPoint:(WMAccessPoint *)ap
{
    if (self = [super init]) {
        self.ap = ap;
        
        //1 初始化其他属性
        [self instanceAttributes:ap];
    }
    return self;
}

-(void)setAp:(WMAccessPoint *)ap
{
    _ap = ap;
    [self instanceAttributes:ap];
}

-(void)setIsUnFold:(BOOL)isUnFold
{
    _isUnFold = isUnFold;
    NSString *imgName = isUnFold ? @"Fold" : @"unFold";
    self.moreBtnImage = [UIImage imageNamed:imgName];
    
}



/**初始化其他属性*/
-(void)instanceAttributes:(WMAccessPoint *)ap
{
    //1 初始化状态
    NSString *imgName = ap.status == ApStatusOnline ? @"online" : @"offline";
    self.statusImage = [UIImage imageNamed:imgName];
    
    //2 初始化可显示用户数
    self.usercountStr = [NSString stringWithFormat:@"%zd人",ap.usercount];
    
    //3 初始化可显示流量
    self.flowStr = [NSString stringWithFormat:@"%0.2fbps/%0.2fbps",ap.send,ap.recv];
    
    //4 初始化位置
    self.postionStr = ap.position.length == 0 ? @"暂未标记位置" : ap.position;
    
    
}




@end
