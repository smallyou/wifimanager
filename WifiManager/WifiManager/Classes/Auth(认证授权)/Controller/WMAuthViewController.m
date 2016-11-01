//
//  WMAuthViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAuthViewController.h"
#import <Masonry.h>
#import "WMLocalAccoutVC.h"
#import "WMTempoVistorVC.h"

@interface WMAuthViewController () <UIScrollViewDelegate>

/**顶部的菜单view*/
@property(nonatomic,weak) UIView *menuView;
/**底部的内容视图*/
@property(nonatomic,weak) UIScrollView *contentView;


/**菜单按钮名称*/
@property(nonatomic,strong) NSArray *titles;

/**上个被选中的菜单按钮*/
@property(nonatomic,weak) UIButton *selectedBtn;

@end

@implementation WMAuthViewController

#pragma mark - 懒加载
-(UIView *)menuView
{
    if (_menuView == nil) {
        UIView *menuView = [[UIView alloc]init];
        [self.view addSubview:menuView];
        _menuView = menuView;
    }
    return _menuView;
}

-(UIScrollView *)contentView
{
    if (_contentView == nil) {
        UIScrollView *contentView = [[UIScrollView alloc]init];
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

-(NSArray *)titles
{
    if (_titles ==  nil) {
        _titles = @[@"本地用户",@"临时访客"];
    }
    return _titles;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.menuView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //设置UI
    [self setupUI];
    
    
}

#pragma mark - 设置UI
/**设置UI*/
-(void)setupUI
{
    //1 设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //2 设置导航栏
    self.title = @"认证授权";
    
    //3 设置子控件
    [self setupChildView];
}

/**设置子控件*/
-(void)setupChildView
{
    //1 设置顶部的menuView
    self.menuView.backgroundColor = WMColor(86, 171, 228);
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CMNavigationBarMaxY);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(CMAuthMenuViewHeight);
    }];
    //2 添加菜单按钮
    [self addMenuButton];
    
    
    
    //3 设置底部的contentView
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.pagingEnabled = YES;
    self.contentView.delegate = self;
    
    self.contentView.bounces = NO;
    
    //4 添加子控制器
    [self addChildVc];
    
}

/**添加菜单按钮*/
-(void)addMenuButton
{
    for(int i = 0 ; i < self.titles.count ; i++)
    {
        NSString *title = self.titles[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setContentEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        button.tag = i;
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:button];
    }
}

/**添加子控制器*/
-(void)addChildVc
{
    [self addChildViewController:[[WMLocalAccoutVC alloc]init]];
    [self addChildViewController:[[WMTempoVistorVC alloc]init]];
    
}


/**布局子控件*/
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    /**布局菜单按钮*/
    int index = 0;
    for(UIButton *button in self.menuView.subviews)
    {
        if (index == 0) {
            self.selectedBtn.selected = NO;
            button.selected = YES;
            self.selectedBtn = button;
        }
        button.frame = CGRectMake(index * self.menuView.cm_width * 0.5, 0, self.menuView.cm_width*0.5, self.menuView.cm_height);
        index++;
    }
    
    /**设置contentView的内容尺寸*/
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.contentView.cm_width, self.contentView.cm_height);
    
    
    /**加载第一个子控制器*/
    [self loadChildViewWithIndex:0];
}


/**根据索引，加载子控制器的View到contentView上面，懒加载的形式*/
-(void)loadChildViewWithIndex:(NSInteger)index
{
    UIView *childView = self.childViewControllers[index].view;
    childView.frame = CGRectMake(index * self.contentView.cm_width, 0, self.contentView.cm_width, self.contentView.cm_height);
    [self.contentView addSubview:childView];
}

#pragma mark - UIScrollViewDelegate监听contentView的滚动事件等

/**停止滚动后调用的事件*/
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前的x轴偏移量
    CGFloat offX = scrollView.contentOffset.x;
    
    //计算当前的索引
    NSInteger index = offX / scrollView.cm_width;
    
    //设置当前的按钮为选中状态
    UIButton *button = self.menuView.subviews[index];
    [self menuBtnClick:button];
    
    
}



#pragma mark - 事件监听
-(void)menuBtnClick:(UIButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    //加载对应的子控制器view
    [self loadChildViewWithIndex:button.tag];
    
    //设置contentView的偏移量
    [self.contentView setContentOffset:CGPointMake(button.tag * self.contentView.cm_width, 0) animated:YES];
    
}

@end

































