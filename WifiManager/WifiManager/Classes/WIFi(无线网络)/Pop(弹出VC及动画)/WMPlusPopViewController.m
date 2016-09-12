//
//  WMPlusPopViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/9/10.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMPlusPopViewController.h"
#import "WMAddPskViewController.h"

@interface WMPlusPopViewController()

@property(nonatomic,strong) NSArray *datas;

@end

@implementation WMPlusPopViewController

-(NSArray *)datas
{
    if (_datas == nil) {
        _datas = @[@"PSK个人认证",@"短信认证",@"微信认证",@"二维码认证"];
    }
    return _datas;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //1 设置背景图片
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = self.view.bounds;
    bgImageView.image = [UIImage imageNamed:@"popover_background_right"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
}


#pragma mark - UITableViewDataSource数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textColor = WMColor(86, 171, 228);
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate协议方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.myBlock) {
        self.myBlock(self.datas[indexPath.row]);
    }
   
}

#pragma mark - 事件监听



@end
