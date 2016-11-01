//
//  WMSummaryInfoModel.m
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMSummaryInfoModel.h"

@implementation WMSummaryInfoModel

-(NSMutableArray *)arrayWithTitles:(NSArray *)titles keys:(NSArray *)titleKeys
{
    //取出模型中的属性，创建数组
    NSMutableArray *arrayM = [NSMutableArray array];
    
    WMDetailsInfoModel *totalDetail = self.total;
    totalDetail.title = titles[arrayM.count];
    totalDetail.titleKey = titleKeys[arrayM.count];
    [arrayM addObject:totalDetail];
    
    WMDetailsInfoModel *knowDetail = self.known;
    knowDetail.title = titles[arrayM.count];
    knowDetail.titleKey = titleKeys[arrayM.count];
    [arrayM addObject:knowDetail];
    
    WMDetailsInfoModel *unknowDetail = self.unknown;
    unknowDetail.title = titles[arrayM.count];
    unknowDetail.titleKey = titleKeys[arrayM.count];
    [arrayM addObject:unknowDetail];
    
    WMDetailsInfoModel *onlineDetail = self.online;
    onlineDetail.title = titles[arrayM.count];
    onlineDetail.titleKey = titleKeys[arrayM.count];
    [arrayM addObject:onlineDetail];
    
    WMDetailsInfoModel *keywordDetail = self.keyword;
    keywordDetail.title = titles[arrayM.count];
    keywordDetail.titleKey = titleKeys[arrayM.count];
    [arrayM addObject:keywordDetail];
    
    WMDetailsInfoModel *appaccessDetail = self.appaccess;
    appaccessDetail.title = titles[arrayM.count];
    appaccessDetail.titleKey = titleKeys[arrayM.count];
    if (self.appaccess != nil) {
        
        [arrayM addObject:appaccessDetail];
    }
    
    return arrayM;
}

@end
