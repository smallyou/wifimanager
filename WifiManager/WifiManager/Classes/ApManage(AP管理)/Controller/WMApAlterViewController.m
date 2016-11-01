//
//  WMApAlterViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/9/12.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMApAlterViewController.h"
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"
#import "WMBandWidthInputView.h"
#import <MJExtension.h>

@interface WMApAlterViewController ()

#pragma mark - 控件属性

@property (weak, nonatomic) IBOutlet UIImageView *bgImageViewFor2;


/**2.4G*/
@property (weak, nonatomic) IBOutlet UITextField *bandWidth_2G_TextField;
@property (weak, nonatomic) IBOutlet UITextField *channel_2G_TextField;
@property (weak, nonatomic) IBOutlet UITextField *txpower_2G_TextField;

/**5.8G*/
@property (weak, nonatomic) IBOutlet UITextField *bandWidth_5G_TextField;
@property (weak, nonatomic) IBOutlet UITextField *channel_5G_TextField;
@property (weak, nonatomic) IBOutlet UITextField *txpower_5G_TextField;

/**键盘遮挡相关*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewYConstaint;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *alterButton;








@end

@implementation WMApAlterViewController

#pragma mark - 系统回调
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 设置UI
    [self setupUI];
    
    //2 设置数据
    if (self.ap) {
        [self setupFromState];
    }else{
        [self setDataWithApInfo:self.viewModel.apInfo];;
    }
    
    //3 注册键盘改变通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)dealloc
{
    // 移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置UI
/**设置UI*/
-(void)setupUI
{
    //1 设置导航栏
    self.navigationItem.title = @"参数设置";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(saveBtnClick:) image:nil highImage:nil title:@"保存"];
    
    //2 设置圆角
    self.bgImageViewFor2.layer.cornerRadius = 15;
    self.bgImageViewFor2.layer.masksToBounds = YES;

    
    //3 设置键盘
    [self setupInputView];
}

/**设置输入键盘*/
-(void)setupInputView
{

}



#pragma mark - 数据设置

-(void)setDataWithApInfo:(WMApInfo *)apInfo
{
    //1 设置2.4G参数
    self.bandWidth_2G_TextField.text = apInfo.power2.bandwidth;
    self.txpower_2G_TextField.text = apInfo.power2.txpower;
    self.channel_2G_TextField.text = apInfo.power2.channel;
    
    //2 设置5.8G参数
    self.bandWidth_5G_TextField.text = apInfo.power5.bandwidth;
    self.txpower_5G_TextField.text = apInfo.power5.txpower;
    self.channel_5G_TextField.text = apInfo.power5.channel;
}


#pragma mark - 从无线状态跳转过来的
-(void)setupFromState
{
    // 请求指定MAC地址的AP信息
    [self getSpecialApInfo];
    
}





#pragma mark - 事件监听
/**修改按钮点击后的事件*/
- (IBAction)saveBtnClick:(id)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确认修改？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //1 修改模型
        self.viewModel.apInfo.power2.channel = self.channel_2G_TextField.text;
        self.viewModel.apInfo.power2.bandwidth = self.bandWidth_2G_TextField.text;
        self.viewModel.apInfo.power2.txpower = self.txpower_2G_TextField.text;
        
        self.viewModel.apInfo.power5.channel = self.channel_5G_TextField.text;
        self.viewModel.apInfo.power5.bandwidth = self.bandWidth_5G_TextField.text;
        self.viewModel.apInfo.power5.txpower = self.txpower_5G_TextField.text;
        
        //2 保存
        [self modifyApInfo:self.viewModel];
        

        
    }];
    [alertVc addAction:save];
    [alertVc addAction:cancel];
    
    alertVc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)keyboardChangeFrame:(NSNotification *)notice
{
     
    // 获取键盘弹出来的时间
    NSNumber *timeNum = notice.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGFloat duration = timeNum.floatValue;
    
    // 获取键盘结束动画后的frame
    NSValue *endFrameNum = notice.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = endFrameNum.CGRectValue;
    
    //获取contentView的最大的Y值
    CGFloat maxY = CGRectGetMaxY(self.contentView.frame);
   
    if (endFrame.origin.y < maxY) {
        //有遮挡
        self.contentViewYConstaint.constant = endFrame.origin.y - maxY;
    }else{
        self.contentViewYConstaint.constant = 0;
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
        
    }];
    
}


#pragma mark - 网络请求
/**根据AP的mac地址获取指定AP的信息*/
-(void)getSpecialApInfo
{
    //1 取出服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //提示
    [SVProgressHUD showWithStatus:@"loading"];
    
    //2 发起网络请求
    [CMNetworkManager requestForApInfo:server start:0 limit:CMNetworkLimit groupId:self.ap.group_id.integerValue search:self.ap.mac competation:^(NSError *error, NSArray *result) {
        //判断错误
        if(error){
            [SVProgressHUD errorWithString:@"失败，请重试!"];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        //字典转模型
        NSArray *array = [WMApInfo mj_objectArrayWithKeyValuesArray:result];
        if (array.count!=0) {
            WMApInfo *apInfo = array.firstObject;
            //更新UI
            [self setDataWithApInfo:apInfo];
            //更新viewModel
            self.viewModel = [[WMApInfoViewModel alloc]initWithApInfo:apInfo];
            [SVProgressHUD dismiss];
        }
    }];
}


/**修改AP信息*/
-(void)modifyApInfo:(WMApInfoViewModel *)viewModel
{
    //1 取出服务器地址
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    
    //2 设置按钮可用状态
    self.contentView.userInteractionEnabled = NO;
    
    //3 发送网络请求
    [SVProgressHUD showWithStatus:@"正在修改..."];
    [CMNetworkManager modifyRadio:server apInfo:viewModel.apInfo competation:^(BOOL success) {
       
        if (success) {
            [SVProgressHUD successWithString:@"修改成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.myBlock) {
                self.myBlock(self.viewModel);
            }
        }
        else{
            [SVProgressHUD errorWithString:@"修改失败，请重试!"];
        }
        self.contentView.userInteractionEnabled = YES;
        
    }];
}



@end
