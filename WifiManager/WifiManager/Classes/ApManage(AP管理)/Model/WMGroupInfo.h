//
//  WMGroupInfo.h
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WMGroupInfo : NSObject

/**子节点数组*/
@property(nonatomic,strong) NSArray *children;
/**id*/
@property(nonatomic,assign) NSInteger Id;
/**是否是子节点*/
@property(nonatomic,assign) BOOL leaf;
/**组名称*/
@property(nonatomic,copy) NSString *name;
/**父节点ID*/
@property(nonatomic,assign) NSInteger pid;
/**分组类型*/
@property(nonatomic,copy) NSString *type;



@end
