//
//  WMCustomMenuModel.h
//  WifiManager
//
//  Created by 陈华 on 16/10/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMCustomMenuModel : NSObject

@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *opr;
@property(nonatomic,copy) NSString *timeRange;

+(NSMutableArray *)customMenu;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
+(instancetype)customMenuWithDictionary:(NSDictionary *)dict;
@end
