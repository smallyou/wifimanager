//
//  WMApAlterViewController.h
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMApInfoViewModel.h"
#import "WMAccessPoint.h"

typedef void(^ModifyBlock)(WMApInfoViewModel *viewModel);


@interface WMApAlterViewController : UIViewController



@property(nonatomic,strong) WMApInfoViewModel *viewModel;

@property(nonatomic,copy) ModifyBlock myBlock;

/**从无线状态跳转过来携带的WMAccessPoint*/
@property(nonatomic,strong) WMAccessPoint *ap;

@end
