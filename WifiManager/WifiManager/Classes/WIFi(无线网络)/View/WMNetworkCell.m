//
//  WMNetworkCell.m
//  WifiManager
//
//  Created by 陈华 on 16/9/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMNetworkCell.h"
#import "WMNetworkViewModel.h"


@interface WMNetworkCell ()

#pragma mark - 控件属性
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *apsLabel;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bandLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroudView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *enableButton;
@property (weak, nonatomic) IBOutlet UIButton *disableButton;


#pragma mark - 控件约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationViewWidthConstrain;



@end


@implementation WMNetworkCell



#pragma mark - 设置UI

- (void)awakeFromNib {
    // Initialization code
    
    //1 设置背景色
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    //2 设置cell的圆角
    self.cellBackgroudView.layer.cornerRadius = 20;
    self.cellBackgroudView.layer.masksToBounds = YES;
    
    //3 设置约束
    self.operationViewWidthConstrain.constant = 0;
    
    //4 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    
    
}

-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    frame.size.width -=20;
    frame.origin.x += 10;
    [super setFrame:frame];
}

#pragma mark - 事件监听
/**更多按钮被点击事件*/
- (IBAction)moreBtnClick:(id)sender {
    
    
    //切换操作视图
    self.operationViewWidthConstrain.constant = self.operationViewWidthConstrain.constant == 0 ? 160 : 0;
    
    //修改模型
    self.viewModel.operationViewUnFold = self.operationViewWidthConstrain.constant == 160;
    
    //旋转
    [UIView animateWithDuration:0.25 animations:^{
        
        self.moreButton.transform = CGAffineTransformMakeRotation(M_PI);
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        self.moreButton.transform = CGAffineTransformIdentity;
    
    }];
    
}

/**删除按钮被点击事件*/
- (IBAction)deleteBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(networkCell:didDeleteBtnClick:competation:)]) {
        [self.delegate networkCell:self didDeleteBtnClick:sender competation:nil];
    }
}
/**启用按钮被点击事件*/
- (IBAction)enableBtnClick:(id)sender {
    self.enableButton.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(networkCell:didEnableBtnClick:competation:)]) {
        [self.delegate networkCell:self didEnableBtnClick:sender competation:^(BOOL success) {
            self.disableButton.enabled = success;
            self.enableButton.enabled = !success;
        }];
    }
}
/**禁用按钮被点击事件*/
- (IBAction)disableBtnClick:(id)sender {
    self.disableButton.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(networkCell:didDisableBtnClick:competation:)]) {
        [self.delegate networkCell:self didDisableBtnClick:sender competation:^(BOOL success) {
            self.enableButton.enabled = success;
            self.disableButton.enabled = !success;
        }];
    }
}

/**点击手势*/
- (void)tapView
{
//    [self moreBtnClick:self.moreButton];
}

#pragma mark - 属性赋值
-(void)setViewModel:(WMNetworkViewModel *)viewModel
{
    _viewModel = viewModel;
    
    //1 判断当前的操作视图是否展开
    self.operationViewWidthConstrain.constant = viewModel.isOperationViewUnFold ? 160 : 0;
    
    //2 取出模型
    WMNetwork *network = viewModel.network;
    
    //3 设置SSID
    self.ssidLabel.text = network.ssid;
    
    //4 设置接入点
    self.apsLabel.text = viewModel.apsStr;
    
    //5 设置认证方式
    self.authLabel.text = viewModel.authStr;
    
    //6 设置数据模式
    self.modeLabel.text = viewModel.modeStr;
    
    //7 设置协议类型
    self.bandLabel.text = viewModel.bandStr;
    
    //8 操作按钮的状态
    self.disableButton.enabled = network.enable;
    self.enableButton.enabled = !network.enable;
    
    
}





@end
