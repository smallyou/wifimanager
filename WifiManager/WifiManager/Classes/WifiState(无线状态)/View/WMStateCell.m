//
//  WMStateCell.m
//  WifiManager
//
//  Created by 陈华 on 16/9/16.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMStateCell.h"

@interface WMStateCell()

/**频段类型*/
@property (weak, nonatomic) IBOutlet UILabel *channelTypeLabel;
/**用户数*/
@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;
/**信道*/
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
/**功率*/
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
/**IP*/
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
/**分组*/
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
/**工作模式*/
@property (weak, nonatomic) IBOutlet UILabel *workModelLabel;
/**信道利用率*/
@property (weak, nonatomic) IBOutlet UILabel *channelRateLabel;
/**误码率*/
@property (weak, nonatomic) IBOutlet UILabel *errCodeRateLabel;
/**mac地址*/
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
/**位置*/
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;









@end


@implementation WMStateCell

#pragma mark - 设置UI

- (void)awakeFromNib {
    // Initialization code
    // 设置圆角
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
}

/**设置cell的尺寸*/
-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    frame.size.width -=20;
    frame.origin.x += 10;
    [super setFrame:frame];
}


#pragma mark - 设置数据

-(void)setViewModel:(WMApViewModel *)viewModel
{
    _viewModel = viewModel;
    
    //0 取出当前的radio
    WMApRadio *radio = viewModel.apRadios[viewModel.indexPath.row];
    
    //1 频段类型
    self.channelTypeLabel.text = [NSString stringWithFormat:@"%@频段",radio.type];
    
    //1 用户数 --> 改成重传率
    self.userCountLabel.text = [NSString stringWithFormat:@"用户数:%zd",radio.usercount];
//    self.userCountLabel.text = [NSString stringWithFormat:@"重传率:%0.2f%%",radio.repeatRate];
    
    //2 信道
//    self.channelLabel.text = [NSString stringWithFormat:@"信道:%ld",radio.channel];
    self.channelLabel.text = [NSString stringWithFormat:@"信道:%zd",radio.workInfoChannel];
    
    //3 功率
    self.powerLabel.text = [NSString stringWithFormat:@"功率:%zddBm",radio.ap_power];
    
    //4 IP
    self.ipLabel.text = [NSString stringWithFormat:@"IP:%@",viewModel.ap.ip];
    
    //5 分组
    self.groupLabel.text = viewModel.ap.group;
    
    //6 工作模式
    self.workModelLabel.text = [NSString stringWithFormat:@"工作模式:%@",radio.workmodel];
    
    //7 信道利用率
//    self.channelRateLabel.text = [NSString stringWithFormat:@"信道利用率:%0.2f%%",radio.channelRate];
    self.channelRateLabel.text = [NSString stringWithFormat:@"信道利用率:%0.2f%%",radio.infoChannelRate];
    
    //8 误码率
    self.errCodeRateLabel.text = [NSString stringWithFormat:@"误码率:%0.2f%%",radio.errCodeRate];
    
    //9 mac
    self.macLabel.text = [NSString stringWithFormat:@"MAC:%@",viewModel.ap.mac];
    
    //10 位置
    self.positionLabel.text = viewModel.postionStr;
}


#pragma mark - 事件监听

- (IBAction)settingRadio:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(stateCell:didSettingBtnClick:)]) {
        [self.delegate stateCell:self didSettingBtnClick:sender];
    }
    
}






@end
