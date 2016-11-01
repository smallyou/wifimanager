//
//  WMFlowTrendCellItem.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WMSepartorType) {
    WMSepartorTypeNone = 0,
    WMSepartorTypeShort,
    WMSepartorTypeLong
};

typedef void(^WMCellClickBlock)(id,id);

@interface WMFlowTrendCellItem : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *leftDetail;
@property(nonatomic,copy) NSString *image;
@property(nonatomic,copy) WMCellClickBlock option;
/**子菜单*/
@property(nonatomic,strong) NSArray *childMenus;

/**样式相关*/

/**分割线的样式*/
@property(nonatomic,assign) WMSepartorType separtorType;

+(instancetype)cellItemWithTitle:(NSString *)title leftDetail:(NSString *)leftDetail image:(NSString *)image;

@end
