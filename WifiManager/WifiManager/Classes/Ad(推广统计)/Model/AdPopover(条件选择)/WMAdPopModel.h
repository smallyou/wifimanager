//
//  WMAdPopModel.h
//  WifiManager
//
//  Created by 陈华 on 16/10/14.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMAdPopModel : NSObject

@property(nonatomic,copy) NSString *Id;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) NSDictionary *push;

/**当前模型是否选中*/
@property(nonatomic,assign,getter=isSelected) BOOL selected;

@end
