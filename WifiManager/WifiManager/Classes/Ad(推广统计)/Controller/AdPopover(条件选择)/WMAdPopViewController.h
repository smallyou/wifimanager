//
//  WMAdPopViewController.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMFlowTrendCellItem,WMAdPopModel;

typedef void(^WMConfirmBtnClickBlock)(WMAdPopModel *);


@interface WMAdPopViewController : UIViewController

@property(nonatomic,strong) WMFlowTrendCellItem *cellItem;

@property(nonatomic,copy) WMConfirmBtnClickBlock confirmBtnClick;

@end
