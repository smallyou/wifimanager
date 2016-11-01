//
//  WMAddTempoVistorVC.m
//  WifiManager
//
//  Created by 陈华 on 16/10/7.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAddTempoVistorVC.h"
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"

@interface WMAddTempoVistorVC ()
@property (weak, nonatomic) IBOutlet UITextField *accoutLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *expireValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *expireTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation WMAddTempoVistorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"新增临时访客账号";
    
    
    [self.accoutLabel addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordLabel addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.expireValueLabel addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)expireTypeBtnClick:(UIButton *)sender {
    
    self.expireTypeButton.selected = !self.expireTypeButton.isSelected;
    
}

- (IBAction)creatBtnClick:(UIButton *)sender {
    
    //获取账户名
    NSString *accout = self.accoutLabel.text;
    //获取密码
    NSString *password = self.passwordLabel.text;
    //获取有效期类型
    NSString *type = self.expireTypeButton.currentTitle;
    if([type isEqualToString:@"天"]){
        type = @"day";
    }else{
        type = @"hour";
    }
    //获取有效期值
    NSString *value = self.expireValueLabel.text;
    //获取备注
    NSString *remark = self.remarkLabel.text;
    
    //创建账号
    //1 获取当前登陆的userAccout
    WMUserAccout *userAccout = [WMUserAccoutViewModel shareInstance].userAccout;
    
    //2 获取服务器地址
    NSString *server = userAccout.server;
    
    //3 拼接信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = accout;
    dict[@"psw"] = password;
    dict[@"remark"] = remark;
    dict[@"type"] = type;
    dict[@"value"] = value;


    [CMNetworkManager requestForAddTempoGuest:server dict:dict competation:^(BOOL success) {
       
        if (success) {
            [SVProgressHUD successWithString:@"添加成功"];
        }else{
            [SVProgressHUD errorWithString:@"添加失败"];
        }
        
    }];
}

/**当文本框内容改变的时候调用---用来控制登录按钮是否可用*/
-(void)textChanged:(UITextField *)tf
{
    if (self.accoutLabel.hasText && self.passwordLabel.hasText && self.expireValueLabel.hasText) {
        self.createButton.enabled = YES;
    }
    else{
        self.createButton.enabled = NO;
    }
}



@end
