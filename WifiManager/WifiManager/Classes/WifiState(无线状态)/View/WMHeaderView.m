//
//  WMHeaderView.m
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMHeaderView.h"
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

@interface WMHeaderView()


/**AP名称*/
@property(nonatomic,weak) UIButton *nameButton;

/**用户数*/
@property(nonatomic,weak) UIButton *usercountButton;

/**流量*/
@property(nonatomic,weak) UIButton *dataButton;

/**查看更多标示*/
@property(nonatomic,weak) UIImageView *moreIconView;

@end


@implementation WMHeaderView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        //1 初始化子控件
        [self setupChildControl];
        
        //2 设置背景色
        self.contentView.backgroundColor = WMColor(202, 235, 255);
        
        //3 添加点击手势
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidClick:)]];
        
    }
    return self;
}

#pragma mark - 界面设置
/**初始化子控件*/
-(void)setupChildControl
{    
    
    //初始化AP名称按钮
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:nameButton];
    [nameButton setTitle:@"APName" forState:UIControlStateNormal];
    [nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nameButton.userInteractionEnabled = NO;
    nameButton.selected = YES;
    //        nameButton.backgroundColor = [UIColor redColor];
    [nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.nameButton = nameButton;
    //添加约束
    [nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    
    //初始化用户数按钮
    UIButton *usercountButton = [[UIButton alloc]init];
    [self.contentView addSubview:usercountButton];
    [usercountButton setImage:[UIImage imageNamed:@"userCount"] forState:UIControlStateNormal];
    [usercountButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [usercountButton setTitle:@"11人" forState:UIControlStateNormal];
    usercountButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    usercountButton.userInteractionEnabled = NO;
    usercountButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.usercountButton = usercountButton;
    //        usercountButton.backgroundColor = [UIColor purpleColor];
    [usercountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameButton.mas_left);
        make.top.equalTo(self.nameButton.mas_bottom).offset(10);
        make.height.equalTo(16);
    }];
    
    //初始化流量按钮
    UIButton *dataButton = [[UIButton alloc]init];
    [self.contentView addSubview:dataButton];
    [dataButton setImage:[UIImage imageNamed:@"flow"] forState:UIControlStateNormal];
    [dataButton setTitle:@"123.0bps / 123.0bps" forState:UIControlStateNormal];
    [dataButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dataButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    dataButton.userInteractionEnabled = NO;
    dataButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.dataButton = dataButton;
    [dataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usercountButton.mas_top);
        make.left.equalTo(self.contentView.mas_centerX).offset(-100);
        make.height.equalTo(16);
    }];
    
    //初始化查看更多标示
    UIImageView *moreIconView = [[UIImageView alloc]init];
    [self.contentView addSubview:moreIconView];
    moreIconView.image = self.viewModel.moreBtnImage;
    self.moreIconView = moreIconView;
    //添加约束
    [moreIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(16);
        make.width.equalTo(16);
        make.centerY.equalTo(self.nameButton.mas_centerY);
        
    }];
    

}

/**重写setFrame方法，用来设置分割线*/
-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    frame.size.width -=20;
    frame.origin.x += 10;
    [super setFrame:frame];
}

#pragma mark - 事件监听
-(void)viewDidClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(headerViewDidViewClick:)]) {
        [self.delegate headerViewDidViewClick:self];
    }
}

#pragma mark - 设置数据
-(void)setViewModel:(WMApViewModel *)viewModel
{
    _viewModel = viewModel;
    
    //1 设置名称
    [self.nameButton setTitle:viewModel.ap.name forState:UIControlStateNormal];
    
    //2 设置状态
    [self.nameButton setImage:viewModel.statusImage forState:UIControlStateNormal];
    
    //3 设置用户数
    [self.usercountButton setTitle:viewModel.usercountStr forState:UIControlStateNormal];
    
    //4 设置流量
    [self.dataButton setTitle:viewModel.flowStr forState:UIControlStateNormal];
    
    //5 更多按钮的图片
    if (viewModel.moreBtnImage == nil) {
        self.moreIconView.image = [UIImage imageNamed:@"unFold"];
    }else{
        
        self.moreIconView.image = viewModel.moreBtnImage;
    }
}



@end
