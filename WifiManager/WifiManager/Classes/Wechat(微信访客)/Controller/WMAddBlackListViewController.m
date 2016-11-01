//
//  WMAddBlackListViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMAddBlackListViewController.h"
#import "WMBlackListModel.h"


typedef void(^ConfirmBtnBlock)(WMBlackListModel *blackList);


@interface WMAddBlackListViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *macTextField;
@property (weak, nonatomic) IBOutlet UITextField *rateTextField; //冻结时间
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSegment; //单位



@property(nonatomic,strong) NSArray *values;

@end

@implementation WMAddBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.values = @[@"hour",@"minute",@"seconds"];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - 事件监听

- (IBAction)cancelBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)comfirmBtnClick:(UIButton *)sender {
    
    if (self.macTextField.text.length && self.rateTextField.text.length) {
        
        //正则表达式--匹配格式
        NSString *regex = @"[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]";
        
        //根据正则表达式将NSPredicate的格式设置好
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        //判断正则表达式能否正确匹配_textFiedld.text的内容
        BOOL isMatch = [pred evaluateWithObject:self.macTextField.text];
        if(!isMatch){
            
            [SVProgressHUD errorWithString:@"MAC地址格式不正确"];
            
            return;
        }
        
        if (self.confirmBtnBlock) {
            WMBlackListModel *blackList = [[WMBlackListModel alloc]init];
            blackList.mac = self.macTextField.text;
            blackList.rate = self.rateTextField.text;
            blackList.unit = self.values[self.unitSegment.selectedSegmentIndex];
            self.confirmBtnBlock(blackList);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [SVProgressHUD errorWithString:@"请填写完整..."];
        
    }
    
    
    
}


@end
