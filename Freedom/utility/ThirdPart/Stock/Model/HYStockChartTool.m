//
//  HYStockChartTool.m
//  jimustock
#import "HYStockChartTool.h"
#import "HYStockChartConstant.h"
///K线图的宽度，默认20
static CGFloat HYStockChartKLineWidth = 6;
///K线图的间隔，默认1
static CGFloat HYStockChartKLineGap = 1;
static NSString *HYStockChartStockChineseName = nil;
static NSString *HYStockChartStockSymbol = nil;
static HYStockType HYStockChartStockType;
@implementation HYStockChartTool
+(NSString *)currencySymbol{
    HYStockType stockType = [HYStockChartTool stockType];
    switch (stockType) {
        case HYStockTypeUSA:return @"$";break;
        case HYStockTypeHK:return @"HKD";break;
        default:return @"￥";break;
    }
}
///K线图的宽度，默认20
+(CGFloat)kLineWidth{
    return HYStockChartKLineWidth;
}
+(void)setkLineWith:(CGFloat)kLineWidth{
    if (kLineWidth > HYStockChartKLineMaxWidth) {
        kLineWidth = HYStockChartKLineMaxWidth;
    }else if (kLineWidth < HYStockChartKLineMinWidth){
        kLineWidth = HYStockChartKLineMinWidth;
    }
    HYStockChartKLineWidth = kLineWidth;
}
/// K线图的间隔，默认1
+(CGFloat)kLineGap{
    return HYStockChartKLineGap;
}
+(void)setkLineGap:(CGFloat)kLineGap{
    HYStockChartKLineGap = kLineGap;
}
///股票中文名
+(NSString *)stockChineseName{
    return HYStockChartStockChineseName;
}
+(void)setStockChineseName:(NSString *)chineseName{
    HYStockChartStockChineseName = chineseName;
}
/// 股票代号
+(NSString *)stockSymbol{
    return HYStockChartStockSymbol;
}
+(void)setStockSymbol:(NSString *)symbol{
    HYStockChartStockSymbol = symbol;
}
/// 股票类型
+(void)setStockType:(HYStockType)stockType{
    HYStockChartStockType = stockType;
}
+(HYStockType)stockType{
    return HYStockChartStockType;
}
@end
