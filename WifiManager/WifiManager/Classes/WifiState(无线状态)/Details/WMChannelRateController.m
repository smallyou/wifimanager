//
//  WMChannelRateController.m
//  WifiManager
//
//  Created by 陈华 on 16/9/17.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMChannelRateController.h"
#import "WMChartView.h"
#import "CMNetworkManager.h"
#import "WMUserAccoutViewModel.h"

@interface WMChannelRateController () <UIScrollViewDelegate>

#pragma mark - 控件属性

/**底部的scrollView*/
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; //顶部的titleLabel
@property (weak, nonatomic) IBOutlet UILabel *currentValueLabel; //当前的value
@property (weak, nonatomic) IBOutlet UILabel *currentChannelLabel; //当前的信道


@property(nonatomic,weak) NSTimer *timer;




/**2.4G信道利用率折线图*/
@property (weak,nonatomic) WMChartView *channel2GView;
/**5.8G信道利用率折线图*/
@property (weak,nonatomic) WMChartView *channel5GView;





@end

@implementation WMChannelRateController

#pragma mark - 业务逻辑
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // 设置UI
    [self setupUI];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**加载图表数据*/
    [self loadChartData];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(loadChartData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;

    
}

/**当页面离开的时候，注销所有的网络请求*/
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止提示
    [SVProgressHUD dismiss];
    
    //取消所有的下载任务
    [[CMNetworkManager shareInstance].manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //终止定时器
    [self.timer invalidate];
    
}


#pragma mark - 设置UI

/**设置UI--总的接口*/
-(void)setupUI
{
    //创建并添加信道利用率折线图
    [self addChannelView];
    
    //设置scrollView
    [self setupScrollView];
    
    //设置界面控件的value
    [self setControlValue];
    
}

/**设置界面控件的值*/
-(void)setControlValue
{
    if(self.apViewModel.indexPath.row > self.apViewModel.apRadios.count - 1){
        return;  //说明只有一个频段
    }
    WMApRadio *radio = self.apViewModel.apRadios[self.apViewModel.indexPath.row];
    self.titleLabel.text = [NSString stringWithFormat:@"%@信道利用率分析",radio.type];
    self.currentValueLabel.text = [NSString stringWithFormat:@"%0.2f%%",radio.infoChannelRate];
    self.currentChannelLabel.text = [NSString stringWithFormat:@"channel %zd",radio.workInfoChannel];

}



/**创建并添加信道利用率折线图*/
-(void)addChannelView
{
    // 创建并添加2.4G信道利用率折线图
    WMChartView *view2 = [WMChartView chartView];
    view2.backgroundColor = WMColor(95, 180, 255);
    [self.scrollView addSubview:view2];
    self.channel2GView = view2;
    
    // 创建并添加5.8G信道利用率折线图
    WMChartView *view5 = [WMChartView chartView];
    view5.backgroundColor = WMColor(90, 171, 255);
    [self.scrollView addSubview:view5];
    self.channel5GView = view5;
}

/**设置信道利用率折线图的尺寸*/
-(void)setupChannelViewFrame
{
    // 设置2.4G折线图尺寸
    self.channel2GView.frame = self.scrollView.bounds;
    self.channel2GView.cm_x = 0;
    
    // 设置5.8G折线图尺寸
    self.channel5GView.frame = self.scrollView.bounds;
    self.channel5GView.cm_x = self.scrollView.cm_width;
    
    // 设置scrollView的内容尺寸
    self.scrollView.contentSize = CGSizeMake(2 * self.scrollView.cm_width, 0);
}

/**设置scrollView的其他属性*/
-(void)setupScrollView
{
    // 设置属性
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
}

/**根据模型，滚动到合适的视图*/
-(void)scrollToCurrentView
{
    //根据当前的模型，确认打开的是2.4G还是5.8G，并设置scrollView的偏移量
    WMApRadio *radio = self.apViewModel.apRadios[self.apViewModel.indexPath.row];
    NSString *type = radio.type;
    if ([type isEqualToString:@"2.4G"]) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    else {
        self.scrollView.contentOffset = CGPointMake(WMScreenWidth, 0);
    }
}


/**布局子控件*/
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //布局信道利用率折线图的尺寸
    [self setupChannelViewFrame];
    
    //根据模型，滚动到合适的视图
    [self scrollToCurrentView];
    
}





#pragma mark - 事件监听
/**关闭按钮点击后的事件*/
- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.apViewModel.apRadios.count != 2) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / scrollView.cm_width;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    self.apViewModel.indexPath = indexPath;
    [self setControlValue];
}



#pragma mark - 数据请求
/**加载图表信息*/
-(void)loadChartData
{
    WMApRadio *radio = self.apViewModel.apRadios.firstObject;
    
    [CMNetworkManager requestForChannelChartData:radio server:[WMUserAccoutViewModel shareInstance].userAccout.server competation:^(NSArray *data, NSError *error) {
        
        if (error) {
//            WMLog(@"网络错误或者取消");
            return;
        }
        if ([radio.type isEqualToString:@"2.4G"]) {
            //绘制2.4G频段的折线图
//            WMLog(@"绘制2.4G频段折线图");
            self.channel2GView.data = data;
            
            if (self.scrollView.contentOffset.x == 0) {
                CGFloat currentValue = [[data[1][@"data"] lastObject] floatValue];
                self.currentValueLabel.text = [NSString stringWithFormat:@"%0.1f%%",currentValue];
            }
            
        }
        else{
//            WMLog(@"绘制5.8G频段折线图");
            self.channel5GView.data = data;
            
            if (self.scrollView.contentOffset.x != 0) {
                CGFloat currentValue = [[data[1][@"data"] lastObject] floatValue];
                self.currentValueLabel.text = [NSString stringWithFormat:@"%0.1f%%",currentValue];
            }
            
        }
        
        
    }];
    
    
    if(self.apViewModel.apRadios.count == 2)
    {
        [CMNetworkManager requestForChannelChartData:self.apViewModel.apRadios[1] server:[WMUserAccoutViewModel shareInstance].userAccout.server competation:^(NSArray *data, NSError *error) {
            
            if (error) {
                 
                return;
            }
            
            //绘制5.8G频段的折线图
            
            self.channel5GView.data = data;
            
            if (self.scrollView.contentOffset.x != 0) {
                CGFloat currentValue = [[data[1][@"data"] lastObject] floatValue];
                self.currentValueLabel.text = [NSString stringWithFormat:@"%0.1f%%",currentValue];
            }
            
        }];
    }

}




@end
