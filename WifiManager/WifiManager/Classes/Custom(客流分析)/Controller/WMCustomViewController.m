//
//  WMCustomViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMCustomViewController.h"
#import "WMCustomMenuCell.h"
#import "WMCustomMenuModel.h"
#import "WMCustomChartVC.h"

@interface WMCustomViewController ()

@property(nonatomic,strong) NSArray *array;

@end

@implementation WMCustomViewController

static NSString * const ID = @"cell";
static NSInteger const count = 3;

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((WMScreenWidth - (count + 1) * margin) / count , (WMScreenWidth - (count + 1) * margin) / count);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setupUI];
    
    //设置数据
    self.array = [WMCustomMenuModel customMenu];
}


/**设置UI*/
-(void)setupUI
{
    //设置导航栏
    self.title = @"客流分析";
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WMCustomMenuCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    //设置其他
    //设置其他属性
    self.collectionView.backgroundColor = WMColor(86, 171, 228);
    self.collectionView.contentInset = UIEdgeInsetsMake(margin, margin, 0, margin);
}



#pragma mark - UITableViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WMCustomMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    
    cell.customMenu = self.array[indexPath.row];
         
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前选中的cell
    WMCustomMenuCell *cell = (WMCustomMenuCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    //设置cell的动画
    [cell setAnimation];
    
    //动画完成后调用的block
    __weak  WMCustomViewController *wSelf = self;
    cell.animationCompetationBlock = ^(WMCustomMenuCell *mycell)
    {
       //打开控制器
        WMCustomChartVC *vc = [[WMCustomChartVC alloc]init];
        vc.customMenu = mycell.customMenu;
        [wSelf presentViewController:vc animated:YES completion:nil];
        
    };
}


@end
