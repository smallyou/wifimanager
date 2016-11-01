//
//  WMFlowView.m
//  WifiManager
//
//  Created by 陈华 on 16/9/24.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMFlowView.h"

@interface WMFlowView ()

/**时间数组*/
@property(nonatomic,strong) NSArray *times;
/**自身信道利用率数据数组*/
@property(nonatomic,strong) NSArray *apChannels;
/**环境整体信道利用率数据数组*/
@property(nonatomic,strong) NSArray *enveranceChannels;



@end

@implementation WMFlowView





- (void)drawRect:(CGRect)rect {
    
    //1 转换坐标系
    [self changeAxes:rect];
    
    //2 画AP信道利用率
    [self drawApChannelChartFlow:rect];
    
    //3 画总的信道利用率
    [self drawEnverChannelChartFlow:rect];

}

/**转换坐标系*/
-(void)changeAxes:(CGRect)rect
{
    //1 获取当前上下文
    CGContextRef ref =  UIGraphicsGetCurrentContext();
    
    //2 将坐标系向下及向右移动
    CGContextTranslateCTM(ref, 0, rect.size.height);
    
    //3 将y轴缩放至-1，使得y轴朝上
    CGContextScaleCTM(ref, 1, -1);
}

/**画信道利用率折线图*/
-(void)drawChannelChartFlow:(CGRect)rect channels:(NSArray *)channels color:(UIColor*)color
{
    //1 分别获取x轴和y轴的最大长度
    CGFloat maxX = rect.size.width;
    CGFloat maxY = rect.size.height;
    
    //创建贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //遍历数据
    // 获取数据个数
    NSInteger count = self.times.count;
    CGFloat xMargin = maxX / (count + 1);
    for (int i = 0; i < count; i++) {
        
        //2 取出Ap自身信道利用率
        CGFloat apChannel = [channels[i] floatValue];
        
        
        //3 计算数据点
        CGFloat x = (i + 1) * xMargin;
        CGFloat y = ( apChannel / 100.0 ) * maxY;
        CGPoint point = CGPointMake( x, y);
        
        
        //4 设置起点
        if (i == 0) {
            [path moveToPoint:point];
        }
        
        //5 绘制
        [path addLineToPoint:point];
        
    }
    //6 渲染
    [color set];
    path.lineWidth = 3;
    [path stroke];
    
}

/**画AP信道利用率*/
-(void)drawApChannelChartFlow:(CGRect)rect
{
    [self drawChannelChartFlow:rect channels:self.apChannels color:[UIColor redColor]];
}

/**画总的信道利用率*/
-(void)drawEnverChannelChartFlow:(CGRect)rect
{
    [self drawChannelChartFlow:rect channels:self.enveranceChannels color:[UIColor greenColor]];
}






/**设置数据*/
-(void)setData:(NSArray *)data
{
    _data = data;
    
    for (NSDictionary *dict in data) {
        
        if ([dict[@"name"] isEqualToString:@"time"]) {
            
            self.times = dict[@"data"];
            
            
        }else if ([dict[@"name"] isEqualToString:@"总信道利用率（本AP信道利用率+环境信道利用率）"]) {
            
            self.enveranceChannels = dict[@"data"];
            
            
        
        }else if ([dict[@"name"] isEqualToString:@"接入点本身信道利用率"]) {
            
            self.apChannels = dict[@"data"];
            
        }
        
    }
    
    [self setNeedsDisplay]; //重绘
    
}







/**画坐标轴->箭头*/
-(void)drawAxes:(CGRect)rect
{
    //1 分别获取x轴和y轴的最大长度
    CGFloat maxX = rect.size.width;
    CGFloat maxY = rect.size.height;

    
    //2 绘制坐标轴箭头 -- Y轴箭头
    UIBezierPath *arrowYPath = [UIBezierPath bezierPath];
    [arrowYPath moveToPoint:CGPointMake(0, maxY)];
    [arrowYPath addLineToPoint:CGPointMake(-5, maxY - 2 * 5)];
    [arrowYPath addLineToPoint:CGPointMake(5, maxY - 2 * 5)];
    [arrowYPath closePath];
    [[UIColor blackColor] setFill];
    [arrowYPath fill];
    
    //3 绘制坐标箭头  -- X轴箭头
    UIBezierPath *arrowXPath = [UIBezierPath bezierPath];
    [arrowXPath moveToPoint:CGPointMake(maxX, 0)];
    [arrowXPath addLineToPoint:CGPointMake(maxX - 2 * 5, 5)];
    [arrowXPath addLineToPoint:CGPointMake(maxX - 2 * 5, -5)];
    [arrowXPath closePath];
    [[UIColor blackColor] setFill];
    [arrowXPath fill];
    
    
}

 

@end
