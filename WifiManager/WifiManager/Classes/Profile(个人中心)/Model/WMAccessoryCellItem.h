//
//  WMAccessoryCellItem.h
//  WifiManager
//
//  Created by 陈华 on 16/10/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMCellItem.h"

@interface WMAccessoryCellItem : WMCellItem

@property(nonatomic,assign) Class destinationVC;  //除了包含父类的三个重要数据外，还包含了点击后跳转的控制器所属类

@end
