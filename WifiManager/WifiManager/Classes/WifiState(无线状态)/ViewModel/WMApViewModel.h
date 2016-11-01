//
//  WMApViewModel.h
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMAccessPoint.h"
#import "WMApRadio.h"

@interface WMApViewModel : NSObject

/**拥有属性模型 -- 无线状态*/
@property(nonatomic,strong) WMAccessPoint *ap;

/**拥有模型属性 -- 无线射频参数数组 */
@property(nonatomic,strong) NSArray *apRadios;

/**当前的射频参数索引 indexPath*/
@property(nonatomic,strong) NSIndexPath *indexPath;


/**额外增加的属性*/

/**可显示状态图片*/
@property(nonatomic,strong) UIImage *statusImage;
/**可显示用户数*/
@property(nonatomic,copy) NSString *usercountStr;
/**可显示流量*/
@property(nonatomic,copy) NSString *flowStr;
/**是否展开*/
@property(nonatomic,assign,) BOOL isUnFold;
/**可显示位置*/
@property(nonatomic,copy) NSString *postionStr;

/**更多按钮的图片*/
@property(nonatomic,strong) UIImage *moreBtnImage;

/**初始化构造方法*/
-(instancetype)initWithAccessPoint:(WMAccessPoint *)ap;

@end
