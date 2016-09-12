//
//  WMPlusPopViewController.h
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBack)(NSString *authName);


@interface WMPlusPopViewController : UITableViewController

@property(nonatomic,copy) CallBack myBlock;

@end
