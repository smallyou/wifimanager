//
//  WMAddBlackListViewController.h
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMBlackListModel;

typedef void(^ConfirmBtnBlock)(WMBlackListModel *blackList);

@interface WMAddBlackListViewController : UIViewController

@property(nonatomic,copy) ConfirmBtnBlock confirmBtnBlock;

@end
