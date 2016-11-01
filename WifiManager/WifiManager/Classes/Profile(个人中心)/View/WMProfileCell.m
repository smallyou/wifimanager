//
//  WMProfileCell.m
//  WifiManager
//
//  Created by 陈华 on 16/10/13.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMProfileCell.h"
#import "WMAccessoryCellItem.h"

@implementation WMProfileCell



-(void)setItem:(WMCellItem *)item
{
    _item = item;
    
    
    
    //赋值
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.leftDetail;
    self.imageView.image = [UIImage imageNamed:item.image];
    
    
    
    //设置cell
    [self setupCell];
    
}


#pragma mark - 设置UI
-(void)setupCell
{
    
    if ([self.item isKindOfClass:[WMAccessoryCellItem class]]) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellArrow"]];
        self.accessoryView = imgView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault; //默认的选中类型
    }else
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
}



@end
