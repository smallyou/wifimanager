//
//  WMLoginView.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMLoginView.h"
#import "WMTextField.h"
#import "CMNetworkManager.h"
#import <SVProgressHUD.h>
#import "WMUserAccout.h"
#import "WMUserAccoutViewModel.h"
#import "WMTabBarViewController.h"
#import "CMCookiesHandler.h"

typedef void(^loginViewBlock)();


typedef NS_ENUM(NSInteger,CMLoginStatus) {
    CMLoginStatusSuccessed = 0, //登录成功
    CMLoginStatusFailed = 1, //登录失败
    CMLoginStatusBeingLogin = 2 , //正在登录中
};


@interface WMLoginView() <UITextFieldDelegate>

#pragma mark - 控件属性
@property (weak, nonatomic) IBOutlet WMTextField *serverTextField;
@property (weak, nonatomic) IBOutlet WMTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet WMTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *remberPwdSwitch;


@property(nonatomic,weak) UIView *cover;


@end


@implementation WMLoginView

#pragma mark - 懒加载
//蒙板
-(UIView *)cover
{
    if (_cover == nil) {
        UIView *view = [[UIView alloc]init];
        view.frame = [UIScreen mainScreen].bounds;
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        _cover = view;
    }
    return _cover;
}




#pragma mark - 系统回调方法

-(void)awakeFromNib
{
    //1 监听文本框内容改变事件
    [self.serverTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.usernameTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    //2 获取viewModel
    WMUserAccoutViewModel *viewModel = [WMUserAccoutViewModel shareInstance];
    
    //3 从沙盒中读取userAccout
    WMUserAccout *userAccout = [viewModel getAccoutFromSandBox];
    
    //4 初始化界面
    if (userAccout.isRemberPwd) {
        self.remberPwdSwitch.on = userAccout.isRemberPwd;
        self.autoLoginSwitch.on = userAccout.autoLogin;
        self.serverTextField.text = userAccout.server;
        self.usernameTextField.text = userAccout.username;
        self.passwordTextField.text = userAccout.password;
    }
    
    if (userAccout.autoLogin && !viewModel.isLogout) {
        [self loginBtnClick];
    }
    
    //5 手动触发检查文本是否为空，按钮是否可用
    [self textChanged:self.usernameTextField];
    
    
}


#pragma mark - 事件监听

/**当文本框内容改变的时候调用---用来控制登录按钮是否可用*/
-(void)textChanged:(UITextField *)tf
{
    if (self.serverTextField.hasText && self.usernameTextField.hasText && self.passwordTextField.hasText) {
        self.loginButton.enabled = YES;
    }
    else{
        self.loginButton.enabled = NO;
    }
}

/**点击登录按钮后的点击事件*/
- (IBAction)loginBtnClick {
    
    //0 添加登录提示
    [self setupTipsStatus:CMLoginStatusBeingLogin];
    
    //1 获取文本输入框中的内容
    NSString *server = self.serverTextField.text;
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    //2 判断server中是否有https，如果没有自动加上
    if (![server containsString:@"https://"]) {
        server = [NSString stringWithFormat:@"https://%@",server];
    }
    
    //3 发起登录请求
    [self requestForLogin:server username:username password:password];
}

/**开关按钮改变事件*/
- (IBAction)switchValueChange:(id)sender {
    
    if (sender == self.autoLoginSwitch) {
        if (self.autoLoginSwitch.isOn) {
            [self.remberPwdSwitch setOn:YES animated:YES];
        }
        else{
            [self.remberPwdSwitch setOn:self.remberPwdSwitch.isOn animated:YES];
        }
        
    }
    else{
        if (!self.remberPwdSwitch.isOn) {
            [self.autoLoginSwitch setOn:NO animated:YES];
        }
        else{
            [self.autoLoginSwitch setOn:self.autoLoginSwitch.isOn animated:YES];
        }
    }
    
}



#pragma mark - 数据请求

/**登录请求*/
-(void)requestForLogin:(NSString *)server username:(NSString *)username password:(NSString *)password
{
    [CMNetworkManager loginRequest:server username:username password:password competation:^(BOOL success, NSError *error) {
        
        if (success) {
            //登录成功
            //3.1 取消提示
            [self setupTipsStatus:CMLoginStatusSuccessed];
            
            //3.2 创建用户信息对象
            WMUserAccout *userAccout = [[WMUserAccout alloc]init];
            userAccout.server = server;
            userAccout.username = username;
            userAccout.password = password;
            userAccout.autoLogin = self.autoLoginSwitch.isOn;
            userAccout.remberPwd = self.remberPwdSwitch.isOn;
            
            //3.3 保存用户信息
            WMUserAccoutViewModel *accoutViewModel =  [WMUserAccoutViewModel shareInstance];
            accoutViewModel.userAccout = userAccout;
            
            //3.4 保存cookies
            [CMCookiesHandler cookiesPersistence];
            
            //3.5 请求控制台的超时时间
            [self requestForConsoleTimeout:server];
            
        }
        else{
            //登录失败
            WMLog(@"登录失败...");
            
            
            //取消提示，各控件可用
            [self setupTipsStatus:CMLoginStatusFailed];
        }
    }];
}

/**请求控制台超时时间*/
-(void)requestForConsoleTimeout:(NSString *)server
{
    [CMNetworkManager requestForConsoleTimeout:server competation:^(BOOL isSuccess, NSTimeInterval timeout, NSError *error) {
        if (isSuccess) {
            //1 将超时时间赋值给对象
            [WMUserAccoutViewModel shareInstance].userAccout.timeout_time = timeout;
            
            //2 保存userAccout
            [[WMUserAccoutViewModel shareInstance] savedUserAccoutToSandBox];
            [WMUserAccoutViewModel shareInstance].logout = NO;
            
            //3 跳转页面
            [UIApplication sharedApplication].keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        }
        else{
            NSLog(@"请求失败");
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请重试！"];
        }
    }];
}


#pragma mark - 登录状态相关UI
/**设置登录提示、蒙板*/
-(void)setupTipsStatus:(CMLoginStatus)status
{
    if (status == CMLoginStatusBeingLogin) {
        //正在登录
        [self cover];
        [SVProgressHUD showWithStatus:@"正在登录..."];
    }
    else if(status == CMLoginStatusFailed){
        //登录失败
        [self.cover removeFromSuperview];
        [SVProgressHUD showErrorWithStatus:@"登录失败，请检查参数"];
    }
    else if(status == CMLoginStatusSuccessed)
    {
        //登录成功
        [self.cover removeFromSuperview];
        [SVProgressHUD dismiss];
    }
}



@end
