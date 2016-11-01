//
//  WMCellItem.h
//  WifiManager
//
//  Created by 陈华 on 16/10/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WMCellClickBlock)(id);


@interface WMCellItem : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *leftDetail;
@property(nonatomic,copy) NSString *image;
@property(nonatomic,copy) WMCellClickBlock option;

+(instancetype)cellItemWithTitle:(NSString *)title leftDetail:(NSString *)leftDetail image:(NSString *)image;

@end
