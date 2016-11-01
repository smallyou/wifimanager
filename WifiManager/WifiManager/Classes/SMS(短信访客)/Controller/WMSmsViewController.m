//
//  WMSmsViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/8/30.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMSmsViewController.h"
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"

@interface WMSmsViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;


@end

@implementation WMSmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    //设置UI
    [self setupUI];
    
}

#pragma mark - 设置UI
-(void)setupUI
{
    self.title = @"全局排除";
    
    [self.addressTF addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - 业务

-(void)textChanged:(UITextField *)tf
{
    if (self.addressTF.hasText) {
        self.commitButton.enabled = YES;
    }
    else{
        self.commitButton.enabled = NO;
    }
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    
    
    if (!self.addressTF.text.length) {
        [SVProgressHUD infoWithString:@"地址不能为空"];
    }
    
    NSString *desc = @"";
    if (self.remarkTF.text.length) {
        desc = self.remarkTF.text;
    }
    NSString *address = self.addressTF.text;
    
    
    NSString *server = [WMUserAccoutViewModel shareInstance].userAccout.server;
    [CMNetworkManager requestForAddGlobalExIP:server descirption:desc iplist:address competation:^(BOOL success,NSString *info) {
       
        if (info.length) {
            [SVProgressHUD errorWithString:info];
        }else{
            [SVProgressHUD successWithString:@"添加成功"];
        }
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
