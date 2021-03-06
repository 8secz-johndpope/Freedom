//
//  HYKLineView.m
//  JimuStockChartDemo
#import "HYKLineView.h"
#import "HYStockChartConstant.h"
#import "HYKLineAboveView.h"
#import "KLineModel.h"
#import "HYKLineBelowView.h"
#import "StockCategory.h"
#import "HYStockChartTool.h"
@class HYKLineModel;
/************************K线长按的简介view************************/
@interface HYKLineLongPressProfileView : UIView
@property(nonatomic,strong) HYKLineModel *kLineModel;
/**
 *  工厂方法加载一个HYKLineLongPressProfileViewxib
 */
+(instancetype)kLineLongPressProfileView;
@end
@class HYKLineModel;
@interface HYKLineLongPressView : UIView
@property(nonatomic,strong) HYKLineModel *kLineModel;
+(instancetype)kLineLongPressProfileView;
@end
@interface HYKLineLongPressProfileView ()
@property (strong, nonatomic) UILabel *chineseNameLabel;
@property (strong, nonatomic) UILabel *symbolLabel;
@property (strong, nonatomic) UILabel *closePriceLabel;
@property (strong, nonatomic) UILabel *appliesLabel;
@property (strong, nonatomic) UILabel *openPriceLabel;
@property (strong, nonatomic) UILabel *openPriceNameLabel;
@property (strong, nonatomic) UILabel *maxPriceLabel;
@property (strong, nonatomic) UILabel *maxPriceNameLabel;
@property (strong, nonatomic) UILabel *minPriceLabel;
@property (strong, nonatomic) UILabel *minPriceNameLabel;
@end
@implementation HYKLineLongPressProfileView
+(instancetype)kLineLongPressProfileView{
    HYKLineLongPressProfileView *bllppView = [[HYKLineLongPressProfileView alloc]initWithFrame:CGRectMake(0, 0, APPH, 80)];
    bllppView.backgroundColor = [UIColor whiteColor];
    CGFloat width = APPH/5;
    CGFloat height = 40;
    bllppView.chineseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bllppView.symbolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height, width, height)];
    bllppView.closePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, height)];
    bllppView.appliesLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, height, width, height)];
    bllppView.openPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, 0, width, height)];
    bllppView.openPriceNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*2, height, width, height)];
    bllppView.maxPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, 0, width, height)];
    bllppView.maxPriceNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*3, height, width, height)];
    bllppView.minPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*4, 0, width, height)];
    bllppView.minPriceNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*4, height, width, height)];
    [bllppView addSubviews:bllppView.chineseNameLabel,bllppView.symbolLabel,bllppView.closePriceLabel,bllppView.appliesLabel,bllppView.openPriceLabel,bllppView.openPriceNameLabel,bllppView.minPriceLabel,bllppView.minPriceNameLabel,bllppView.maxPriceLabel,bllppView.maxPriceNameLabel,nil];
    for(UILabel *v in bllppView.subviews){
        if([v isKindOfClass:[UILabel class]]){
            v.text = @"temp";
            v.font = [UIFont systemFontOfSize:10];
            v.textColor = [UIColor grayColor];
            v.textAlignment = NSTextAlignmentCenter;
        }
    }
    bllppView.chineseNameLabel.text = [HYStockChartTool stockChineseName];
    //    bllppView.symbolLabel.text = [HYStockChartGloablVariable stockSymbol];
    bllppView.symbolLabel.text = @"APPL";
    return bllppView;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.symbolLabel.textColor = AssistTextColor;
    self.chineseNameLabel.textColor = MainTextColor;
    self.closePriceLabel.textColor = MainTextColor;
    self.appliesLabel.textColor = IncreaseColor;
    self.openPriceLabel.textColor = MainTextColor;
    self.openPriceNameLabel.textColor = AssistTextColor;
    self.maxPriceLabel.textColor = MainTextColor;
    self.maxPriceNameLabel.textColor = AssistTextColor;
    self.minPriceLabel.textColor = MainTextColor;
    self.minPriceNameLabel.textColor = AssistTextColor;
}
#pragma mark - set方法
-(void)setKLineModel:(HYKLineModel *)kLineModel{
    _kLineModel = kLineModel;
    
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.closePriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.close];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",kLineModel.percentChangeFromOpen];
    UIColor *appliesLabelColor = kLineModel.percentChangeFromOpen > 0 ? IncreaseColor : DecreaseColor;
    self.appliesLabel.textColor = appliesLabelColor;
    self.openPriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.open];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.high];
    self.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.low];
}
@end
@interface HYKLineLongPressView ()
@property (strong, nonatomic) UILabel *appliesLabel;
@property (strong, nonatomic) UILabel *closePriceLabel;
@property (strong, nonatomic) UILabel *openPriceLabel;
@property (strong, nonatomic) UILabel *maxPriceLabel;
@property (strong, nonatomic) UILabel *minPriceLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *volumeLabel;
@end
@implementation HYKLineLongPressView
+(instancetype)kLineLongPressProfileView{
    HYKLineLongPressView *timeLineLPView = [[HYKLineLongPressView alloc]initWithFrame:CGRectMake(0, 0, APPH, 45)];
    timeLineLPView.backgroundColor = [UIColor whiteColor];
    timeLineLPView.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, APPH/5, 45)];
    timeLineLPView.volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/4, 0, APPH/5, 45)];
    timeLineLPView.appliesLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/2, 0, APPH/5, 45)];
    timeLineLPView.closePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/4*3, 0, APPH/5, 45)];
    timeLineLPView.maxPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/2, 0, APPH/5, 45)];
    timeLineLPView.minPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(APPH/4*3, 0, APPH/5, 45)];
    
    [timeLineLPView addSubviews:timeLineLPView.timeLabel,timeLineLPView.appliesLabel,timeLineLPView.volumeLabel,timeLineLPView.closePriceLabel,timeLineLPView.minPriceLabel,timeLineLPView.maxPriceLabel,nil];
    for(UILabel *a in timeLineLPView.subviews){
        if([a isKindOfClass:[UILabel class]]){
            a.textColor = [UIColor grayColor];
            a.text = @"temp";
            a.textAlignment = NSTextAlignmentCenter;
            a.font = [UIFont systemFontOfSize:10];
        }
    }
    return timeLineLPView;
}

#pragma mark - set方法
-(void)setKLineModel:(HYKLineModel *)kLineModel{
    _kLineModel = kLineModel;
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.closePriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.close];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",kLineModel.percentChangeFromOpen];
    UIColor *appliesLabelColor = kLineModel.percentChangeFromOpen > 0 ? IncreaseColor :DecreaseColor;
    self.appliesLabel.textColor = appliesLabelColor;
    self.openPriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.open];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.high];
    self.minPriceLabel.text = [NSString stringWithFormat:@"%.2f",kLineModel.low];
    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
    formatter.dateFormat = @"MM-dd-yyyy";
    NSDate *date = [formatter dateFromString:kLineModel.date];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",dateStr];
    
    NSString *volumeString = [NSString stringWithFormat:@"%f",kLineModel.volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",kLineModel.volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",kLineModel.volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
}
@end
/************************MAView的模型************************/
@interface HYKLineMAModel : NSObject
@property(nonatomic,assign) CGFloat ma5Value;
@property(nonatomic,assign) CGFloat ma10Value;
@property(nonatomic,assign) CGFloat ma20Value;
@property(nonatomic,assign) CGFloat ma30Value;
+(instancetype)maModelWithMA5:(CGFloat)MA5 MA10:(CGFloat)MA10 MA20:(CGFloat)MA20 MA30:(CGFloat)MA30;
@end
/************************展示各种MA的View************************/
@interface HYKLineMAView : UIView
@property(nonatomic,strong) HYKLineMAModel *maModel;
///创建HYKLineMAView的工厂方法
+(instancetype)kLineMAView;
@end
/************************展示各种MA的View************************/
@interface HYKLineMAView()
@property (strong, nonatomic) UILabel *ma5Label;
@property (strong, nonatomic) UILabel *ma10Label;
@property (strong, nonatomic) UILabel *ma20Label;
@property (strong, nonatomic) UILabel *ma30Label;
@end
@implementation HYKLineMAView
#pragma mark 创建HYKLineMAView的工厂方法
+(instancetype)kLineMAView{
    CGFloat height = 20;
    HYKLineMAView *maView = [[HYKLineMAView alloc]initWithFrame:CGRectMake(0, 0, APPW, height)];
    maView.ma5Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, APPW/4, height)];
    maView.ma10Label = [[UILabel alloc]initWithFrame:CGRectMake(APPW/4, 0, APPW/4, height)];
    maView.ma20Label = [[UILabel alloc]initWithFrame:CGRectMake(APPW/2, 0, APPW/4, height)];
    maView.ma30Label = [[UILabel alloc]initWithFrame:CGRectMake(APPW/4*3, 0, APPW/4, height)];
    maView.ma5Label.font = maView.ma10Label.font = maView.ma20Label.font = maView.ma30Label.font = [UIFont systemFontOfSize:10];
    maView.ma5Label.textColor = maView.ma10Label.textColor = maView.ma20Label.textColor = maView.ma30Label.textColor = [UIColor grayColor];
    maView.ma5Label.text = maView.ma10Label.text = maView.ma20Label.text = maView.ma30Label.text = @"temp";
    [maView addSubviews:maView.ma5Label,maView.ma10Label,maView.ma20Label,maView.ma30Label,nil];
    return maView;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.ma5Label.textColor = [FreedomTools colorWithRGBHex:0xff783c];
    self.ma10Label.textColor = [FreedomTools colorWithRGBHex:0x49a5ff];
    self.ma20Label.textColor = [FreedomTools colorWithRGBHex:0xffbf43];
    self.ma30Label.textColor = [FreedomTools colorWithRGBHex:0x49a5ff];
    self.ma5Label.font = [UIFont hlFontWithSize:10];
    self.ma10Label.font = [UIFont hlFontWithSize:10];
    self.ma20Label.font = [UIFont hlFontWithSize:10];
    self.ma30Label.font = [UIFont hlFontWithSize:10];
}
#pragma mark - set方法
#pragma mark setMaModel的方法
-(void)setMaModel:(HYKLineMAModel *)maModel{
    _maModel = maModel;
    if (maModel) {
        self.ma5Label.text = [NSString stringWithFormat:@"MA5：%.2f",maModel.ma5Value];
        self.ma10Label.text = [NSString stringWithFormat:@"MA10：%.2f",maModel.ma10Value];
        self.ma20Label.text = [NSString stringWithFormat:@"MA20：%.2f",maModel.ma20Value];
        self.ma30Label.text = [NSString stringWithFormat:@"MA30：%.2f",maModel.ma30Value];
    }
}
@end
/*************MAView的模型**************/
@implementation HYKLineMAModel
+(instancetype)maModelWithMA5:(CGFloat)MA5 MA10:(CGFloat)MA10 MA20:(CGFloat)MA20 MA30:(CGFloat)MA30{
    HYKLineMAModel *model = [[HYKLineMAModel alloc] init];
    model.ma5Value = MA5;
    model.ma10Value = MA10;
    model.ma20Value = MA20;
    model.ma30Value = MA30;
    return model;
}
@end
/**************Y轴的View**************/
@interface HYStockChartYView : UIView
@property(nonatomic,assign) CGFloat maxValue;
@property(nonatomic,assign) CGFloat middleValue;
@property(nonatomic,assign) CGFloat minValue;
@property(nonatomic,copy) NSString *minLabelText;
@end
@interface HYStockChartYView ()
@property(nonatomic,strong) UILabel *maxValueLabel;
@property(nonatomic,strong) UILabel *middleValueLabel;
@property(nonatomic,strong) UILabel *minValueLabel;
@end
@implementation HYStockChartYView
-(void)setMaxValue:(CGFloat)maxValue{
    _maxValue = maxValue;
    self.maxValueLabel.text = [NSString stringWithFormat:@"%.2f",maxValue];
}
-(void)setMiddleValue:(CGFloat)middleValue{
    _middleValue = middleValue;
    self.middleValueLabel.text = [NSString stringWithFormat:@"%.2f",middleValue];
}
-(void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
    self.minValueLabel.text = [NSString stringWithFormat:@"%.2f",minValue];
}
-(void)setMinLabelText:(NSString *)minLabelText{
    _minLabelText = minLabelText;
    self.minValueLabel.text = minLabelText;
}
#pragma mark - get方法
#pragma mark maxPriceLabel的get方法
-(UILabel *)maxValueLabel{
    if (!_maxValueLabel) {
        _maxValueLabel = [self private_createLabel];
        [self addSubview:_maxValueLabel];
        [_maxValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            if (self.minLabelText){
                make.top.equalTo(self);
            }else{
                make.top.equalTo(self).offset(10);
            }
            make.height.equalTo(@20);
            make.width.equalTo(self);
        }];
    }
    return _maxValueLabel;
}
#pragma mark middlePriceLabel的get方法
-(UILabel *)middleValueLabel{
    if (!_middleValueLabel) {
        _middleValueLabel = [self private_createLabel];
        [self addSubview:_middleValueLabel];
        [_middleValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(self.maxValueLabel);
            make.width.equalTo(self.maxValueLabel);
        }];
    }
    return _middleValueLabel;
}
#pragma mark minPriceLabel的get方法
-(UILabel *)minValueLabel{
    if (!_minValueLabel) {
        _minValueLabel = [self private_createLabel];
        [self addSubview:_minValueLabel];
        [_minValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.minLabelText){
                make.bottom.equalTo(self);
            }else{
                make.bottom.equalTo(self).offset(-20);
            }
            //make.bottom.equalTo(self).offset(-20);
            make.right.equalTo(self);
            make.height.equalTo(self.maxValueLabel);
            make.width.equalTo(self.maxValueLabel);
        }];
    }
    return _minValueLabel;
}
#pragma mark - 私有方法
#pragma mark 创建Label
-(UILabel *)private_createLabel{
    UILabel *label = [UILabel new];
    label.font = [UIFont hlFontWithSize:11];
    label.textColor = AssistTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end

@interface HYKLineView ()<UIScrollViewDelegate,HYKLineAboveViewDelegate,HYKLineBelowViewDelegate>{
    CGFloat _scrollViewOffsetRightDistance;
}
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) HYKLineAboveView *kLineAboveView;
@property(nonatomic,strong) HYKLineBelowView *kLineBelowView;
@property(nonatomic,strong) HYKLineMAView *maView;
@property(nonatomic,strong) HYStockChartYView *priceView;
@property(nonatomic,strong) HYStockChartYView *volumeView;
@property(nonatomic,strong) HYKLineLongPressProfileView *longPressProfileView;
@property(nonatomic,strong) HYKLineLongPressView *longPressView;
@property(nonatomic,assign) CGFloat oldRightOffset;
//上面的竖线
@property(nonatomic,strong) UIView *verticalView;
//下面面的竖线
@property(nonatomic,strong) UIView *volumeVerticalView;
@property(nonatomic,strong) UILabel *volumeLabel;   //在左下角展示成交量的label
//上面横线
@property(nonatomic,strong) UIView *horizontalView;
//成交量横
@property(nonatomic,strong) UIView *volumeHorizontalView;
@end
@implementation HYKLineView
#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 0.7;
        self.oldRightOffset = -1.0f;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(event_deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [self drawGridBackground:context rect:frame];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * backgroundColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
   
    CGContextSetLineWidth(context, HYStockChartTimeLineGridWidth);
    CGContextSetStrokeColorWithColor(context, GridLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(10, 0, self.frame.size.width - 60, self.frame.size.height * 0.7 -20));
    
    CGContextSetLineWidth(context, HYStockChartTimeLineGridWidth);
    CGContextSetStrokeColorWithColor(context, GridLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(10, self.frame.size.height * 0.7, self.frame.size.width - 60, self.frame.size.height * 0.3));
}
- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect;{
//    UIColor * backgroundColor = [UIColor whiteColor];
//    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
//    CGContextFillRect(context, rect);
    //画边框
    CGContextSetLineWidth(context, HYStockChartTimeLineGridWidth);
    CGContextSetStrokeColorWithColor(context, GridLineColor.CGColor);
    CGContextStrokeRect(context, rect);
}
#pragma mark - get&set方法
#pragma mark YView的get方法
-(HYStockChartYView *)priceView{
    if (!_priceView) {
        _priceView = [HYStockChartYView new];
        _priceView.backgroundColor = [UIColor colorWithRed:82/255.0 green:149/255.0 blue:227/255.0 alpha:1.0];
        [self insertSubview:_priceView aboveSubview:self.scrollView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.scrollView);
            make.height.equalTo(self).multipliedBy(self.aboveViewRatio);
            make.width.equalTo(@(HYStockChartKLinePriceViewWidth));
        }];
    }
    return _priceView;
}
-(HYStockChartYView *)volumeView{
    if (!_volumeView) {
        _volumeView = [HYStockChartYView new];
        _volumeView.minLabelText = @"万手";
        [self insertSubview:_volumeView aboveSubview:self.scrollView];
        [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.right.equalTo(self.priceView);
            make.width.equalTo(self.priceView);
            make.height.equalTo(self).multipliedBy(1-self.aboveViewRatio);
        }];
    }
    return _volumeView;
}
#pragma mark UIScrollView的get方法
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        //_scrollView.layer.borderWidth = 0.5;
        //_scrollView.layer.borderColor = [[UIColor gridLineColor] CGColor];
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        [self addSubview:_scrollView];
        if ([UIScreen mainScreen].bounds.size.width < 450){
            _scrollViewOffsetRightDistance = 0;
        }else{
            _scrollViewOffsetRightDistance = -50;
        }
        WS(weakSelf);
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(0.5);
            make.right.equalTo(weakSelf).offset(_scrollViewOffsetRightDistance);
            if ([UIScreen mainScreen].bounds.size.width < 450){
               make.left.equalTo(weakSelf.mas_left);
            }else{
                make.left.equalTo(weakSelf.mas_left).offset(10);
            }
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-0.5);
        }];
        //现在直接更新约束，省的后面要需要scrollView的宽度
        [self layoutIfNeeded];
    }
    return _scrollView;
}
#pragma mark kLineAboveView的get方法
-(HYKLineAboveView *)kLineAboveView{
    if (!_kLineAboveView && self) {
        _kLineAboveView = [HYKLineAboveView new];
        _kLineAboveView.delegate = self;
        [self.scrollView addSubview:_kLineAboveView];
        [_kLineAboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.aboveViewRatio);
            make.width.equalTo(@0);
        }];
    }
    self.priceView.backgroundColor = [UIColor clearColor];
    self.volumeView.backgroundColor = [UIColor clearColor];
    return _kLineAboveView;
}
#pragma mark kLineBelowView的get方法
-(HYKLineBelowView *)kLineBelowView{
    if (!_kLineBelowView) {
        _kLineBelowView = [HYKLineBelowView new];
        _kLineBelowView.delegate = self;
        [self.scrollView addSubview:_kLineBelowView];
        [_kLineBelowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineAboveView);
            make.top.equalTo(self.kLineAboveView.mas_bottom);
            make.width.equalTo(self.kLineAboveView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy((1-self.aboveViewRatio));
        }];
        [self layoutIfNeeded];
    }
    return _kLineBelowView;
}
#pragma mark MAView的get方法
-(HYKLineMAView *)maView{
    if (!_maView) {
        _maView = [HYKLineMAView kLineMAView];
        _maView.backgroundColor = [UIColor clearColor];
        [self addSubview:_maView];
        [_maView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(0.5);
            make.height.equalTo(@20);
        }];
    }
    return _maView;
}
#pragma mark longPressProfileView的get方法
-(HYKLineLongPressProfileView *)longPressProfileView{
    if (!_longPressProfileView) {
        _longPressProfileView = [HYKLineLongPressProfileView kLineLongPressProfileView];
        [self addSubview:_longPressProfileView];
        [_longPressProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top);
            make.left.right.equalTo(self);
            make.height.equalTo(@(HYStockChartProfileViewHeight));
        }];
    }
    return _longPressProfileView;
}
-(HYKLineLongPressView *)longPressView{
    if (!_longPressView) {
        _longPressView = [HYKLineLongPressView kLineLongPressProfileView];
        [self addSubview:_longPressView];
        [_longPressView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_top);
//            make.left.right.equalTo(self);
//         make.height.equalTo(@(HYStockChartProfileViewHeight));
            make.bottom.equalTo(self.mas_top).offset(-10);;
            make.left.right.equalTo(self);
            make.height.equalTo(@(30));
        }];
    }
    return _longPressView;
}
#pragma mark volumeLabel的get方法
-(UILabel *)volumeLabel{
    if (!_volumeLabel) {
        _volumeLabel = [UILabel new];
        _volumeLabel.textColor = AssistTextColor;
        _volumeLabel.font = [UIFont hlFontWithSize:11];
        [self addSubview:_volumeLabel];
        [_volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.kLineBelowView).offset(5);
        }];
    }
    return _volumeLabel;
}
#pragma mark - set方法
#pragma mark kLineModels的设置方法
-(void)setKLineModels:(NSArray *)kLineModels{
    if (!kLineModels) {
        return;
    }
    //根据时间进行排序，倒序
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd-yyyy";
    NSArray *sortedKLineModels = [kLineModels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HYKLineModel *preKLineModel = (HYKLineModel *)obj1;
        HYKLineModel *subKLineModel = (HYKLineModel *)obj2;
        NSDate *preDate = [formatter dateFromString:preKLineModel.date];
        NSDate *subDate = [formatter dateFromString:subKLineModel.date];
        return [preDate compare:subDate];
    }];
    _kLineModels = sortedKLineModels;
    //找出所有自然月的第一个交易日
    [self private_findFirstTradeDateWithModels:sortedKLineModels];
    //画图
    [self private_drawKLineAboveView];
    //设置contentOffset
    CGFloat contentOffsetX = self.oldRightOffset < 0 ? self.kLineAboveView.frame.size.width-self.scrollView.frame.size.width : self.kLineAboveView.frame.size.width - self.oldRightOffset;
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0)];
    HYKLineModel *lastModel = [sortedKLineModels lastObject];
    
    //最后一条数据的MA5，MA0，MA30
    self.maView.maModel = [HYKLineMAModel maModelWithMA5:lastModel.MA5 MA10:lastModel.MA10 MA20:lastModel.MA20 MA30:lastModel.MA30];
}
#pragma mark - 事件处理方法
#pragma mark 缩放执行的方法
-(void)event_pinchMethod:(UIPinchGestureRecognizer *)pinch
{
//    static CGFloat oldScale = 1.0f;
//    CGFloat difValue = pinch.scale - oldScale;
//    if (ABS(difValue) > HYStockChartScaleBound) {
//        CGFloat oldKLineWidth = [HYStockChartGloablVariable kLineWidth];
//        [HYStockChartGloablVariable setkLineWith:oldKLineWidth*(difValue>0?(1+HYStockChartScaleFactor):(1-HYStockChartScaleFactor))];
//        oldScale = pinch.scale;
//        //更新AboveView的宽度
//        [self.kLineAboveView updateAboveViewWidth];
//        [self.kLineAboveView drawAboveView];
//    }
    
    /*******/
    //1.获取缩放倍数
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if(ABS(difValue) > HYStockChartScaleBound) {
        if( pinch.numberOfTouches == 2 ) {
            //2.获取捏合中心点 -> 捏合中心点距离scrollviewcontent左侧的距离
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGFloat centerX = (p1.x+p2.x)/2;
            //3.拿到中心点数据源的index
            CGFloat oldLeftArrCount = ABS(centerX + [HYStockChartTool kLineGap]) / ([HYStockChartTool kLineWidth]+[HYStockChartTool kLineGap]);
            //4.缩放重绘
            CGFloat newLineWidth = [HYStockChartTool kLineWidth] * (difValue > 0 ? (1 + HYStockChartScaleBound) : (1 - HYStockChartScaleBound));
            if (newLineWidth >= 15){
                newLineWidth = 15;
            }
            [HYStockChartTool setkLineWith:newLineWidth];
            [self.kLineAboveView updateAboveViewWidth];
            //5.计算更新宽度后捏合中心点距离klineView左侧的距离
            CGFloat newLeftDistance = oldLeftArrCount * [HYStockChartTool kLineWidth] + (oldLeftArrCount - 1) * [HYStockChartTool kLineGap];
            
            //6.设置scrollview的contentoffset = (5) - (2);
            if ( self.kLineModels.count * newLineWidth + (self.kLineModels.count + 1) * [HYStockChartTool kLineGap] > self.scrollView.bounds.size.width ) {
                CGFloat newOffsetX = newLeftDistance - (centerX - self.scrollView.contentOffset.x);
                self.scrollView.contentOffset = CGPointMake(newOffsetX > 0 ? newOffsetX : 0 , self.scrollView.contentOffset.y);
            } else {
                self.scrollView.contentOffset = CGPointMake(0 , self.scrollView.contentOffset.y);
            }
            //更新contentsize
             [self.kLineAboveView updateAboveViewWidth];
            [self setNeedsDisplay];
        }
    }
}

#pragma mark 长按手势执行方法
-(void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress{
    static CGFloat oldPositionX = 0;
    if (UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CanAcceptTouchNotificationName object:@"1"];
        CGPoint location = [longPress locationInView:self.scrollView];
        if (ABS(oldPositionX - location.x) < ([HYStockChartTool kLineWidth]+[HYStockChartTool kLineGap])/2) {
            return;
        }
        //让scrollView的scrollEnabled不可用
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        //初始化竖线
        if (!self.verticalView) {
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self.scrollView addSubview:self.verticalView];
            self.verticalView.backgroundColor = LongPressLineColor;
            [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.height.equalTo(self.kLineAboveView.mas_height).offset(-19);
                make.left.equalTo(@(-10));
            }];
        }
        
        if (!self.volumeVerticalView) {
            self.volumeVerticalView = [UIView new];
            self.volumeVerticalView.clipsToBounds = YES;
            [self.scrollView addSubview:self.volumeVerticalView];
            self.volumeVerticalView.backgroundColor = LongPressLineColor;
            [self.volumeVerticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.kLineAboveView.mas_bottom);
                make.width.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.height.equalTo(self.kLineBelowView.mas_height);
                make.left.equalTo(@(-10));
            }];
        }
        if (!self.horizontalView) {
            //显示竖线
            self.horizontalView = [UIView new];
            self.horizontalView.clipsToBounds = YES;
            [self.scrollView addSubview:self.horizontalView];
            self.horizontalView.backgroundColor =  LongPressLineColor;
            [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.height.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.width.equalTo(self.mas_width);
                make.top.equalTo(@-10);
            }];
        }
        if (!self.volumeHorizontalView) {
            //显示竖线
            self.volumeHorizontalView = [UIView new];
            self.volumeHorizontalView.clipsToBounds = YES;
            [self.scrollView addSubview:self.volumeHorizontalView];
            self.volumeHorizontalView.backgroundColor = LongPressLineColor;
            [self.volumeHorizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.height.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.width.equalTo(self.mas_width);
                make.top.equalTo(@-10);
            }];
        }
        //更改竖线的位置
       // CGFloat rightXPosition = [self.kLineAboveView getRightXPositionWithOriginXPosition:location.x];
        HYKLinePositionModel *kLinePositionModel = [self.kLineAboveView getRightXPositionWithOriginXPosition:location.x];
        
        HYKLineModel *kLineModel = [self.kLineAboveView getRightXLocationWithOriginXPosition:location.x];
        
        CGFloat rightXPosition = kLinePositionModel.highPoint.x;
        CGFloat topYPosition = kLinePositionModel.closePoint.y;
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(rightXPosition));
        }];
        CGPoint currentPoint = [self.kLineBelowView kLineBelowViewLongPressKLinePositionModel:kLinePositionModel kLineModel:kLineModel];
        CGFloat belowYPosition = CGRectGetMaxY(self.kLineAboveView.frame) + currentPoint.y;
        //self.volumeHorizontalView.y = belowYPosition;
        [self.verticalView layoutIfNeeded];
        self.verticalView.hidden = NO;
        [self.volumeVerticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(rightXPosition));
        }];
        [self.volumeVerticalView layoutIfNeeded];
        self.volumeVerticalView.hidden = NO;
        [self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(topYPosition));
        }];
        [self.volumeHorizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(belowYPosition));
        }];
        [self.horizontalView layoutIfNeeded];
        self.horizontalView.hidden = NO;
        [self.volumeHorizontalView layoutIfNeeded];
        self.volumeHorizontalView.hidden = NO;
    }
    if (UIGestureRecognizerStateEnded == longPress.state) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CanAcceptTouchNotificationName object:@"0"];
        //取消竖线
        if (self.verticalView) {
            self.verticalView.hidden = YES;
        }
        if (self.volumeVerticalView) {
            self.volumeVerticalView.hidden = YES;
        }
        //取消横线
        if (self.horizontalView) {
            self.horizontalView.hidden = YES;
        }
        if (self.volumeHorizontalView) {
            self.volumeHorizontalView.hidden = YES;
        }
        oldPositionX = 0;
        //让scrollView的scrollEnabled可用
        self.scrollView.scrollEnabled = YES;
        self.longPressProfileView.hidden = YES;
        self.longPressView.hidden = YES;
        self.volumeLabel.hidden = YES;
        HYKLineModel *lastModel = [self.kLineModels lastObject];
        self.maView.maModel = [HYKLineMAModel maModelWithMA5:lastModel.MA5 MA10:lastModel.MA10 MA20:lastModel.MA20 MA30:lastModel.MA30];
    }
}
#pragma mark 屏幕旋转执行的方法
-(void)event_deviceOrientationDidChanged:(NSNotification *)noti{
    if (_kLineBelowView && _kLineAboveView && self.kLineModels) {
        [self private_drawKLineAboveView];
    }
}
#pragma mark - 公有方法
#pragma mark 指定颜色清除KLineView
-(void)clearRectWithColor:(UIColor *)bgColor{
}
#pragma mark 重绘
-(void)reDraw{
    [self.kLineAboveView drawAboveView];
    self.scrollView.contentOffset = CGPointZero;
}
#pragma mark - 私有方法
#pragma mark 画KLineAboveView
-(void)private_drawKLineAboveView{
    NSAssert(self.kLineAboveView != nil, @"画kLineAboveView之前，kLineAboveView不能为空");
    self.kLineAboveView.kLineModels = self.kLineModels;
    [self.kLineAboveView drawAboveView];
}
#pragma mark 画KLineBelowView
-(void)private_drawKLineBelowView{
    NSAssert(self.kLineBelowView != nil, @"画kLineBelowView之前，kLineBelowView不能为空");
    //因为belowView的宽度和aboveView的宽度是一致的，所以只需要更新约束就可以了
    [self.kLineBelowView layoutIfNeeded];
    [self.kLineBelowView drawBelowView];
}
#pragma mark 找出某个月的第一个交易日
-(void)private_findFirstTradeDateWithModels:(NSArray *)sortedKLineModels;{
    __block HYKLineModel *comparingModel = [sortedKLineModels firstObject];
    comparingModel.isFirstTradeDate = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [sortedKLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYKLineModel *kLineModel = (HYKLineModel *)obj;
        NSDate *compaingDate = [formatter dateFromString:comparingModel.date];
        NSDate *objDate = [formatter dateFromString:kLineModel.date];
        NSDateComponents *compingComponent = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:compaingDate];
        NSDateComponents *objComponent = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:objDate];
        if (compingComponent.month != objComponent.month || compingComponent.year != objComponent.year) {
            kLineModel.isFirstTradeDate = YES;
            comparingModel = kLineModel;
        }
    }];
}
#pragma mark - HYKLAboveView的代理方法
#pragma mark 长按时选中的HYKLinePositionModel模型
-(void)kLineAboveViewLongPressKLinePositionModel:(HYKLinePositionModel *)kLinePositionModel kLineModel:(HYKLineModel *)kLineModel{
    if (self.frame.size.width < 450){
        self.maView.maModel = [HYKLineMAModel maModelWithMA5:kLineModel.MA5 MA10:kLineModel.MA10 MA20:kLineModel.MA20 MA30:kLineModel.MA30];
        return;
    }
    //更新选择的kLineModel信息
    self.longPressProfileView.kLineModel = kLineModel;
    self.longPressView.kLineModel = kLineModel;
    self.longPressProfileView.hidden = YES;
    self.longPressView.hidden = NO;
    self.volumeLabel.text = [NSString stringWithFormat:@"成交量：%.2f万手",kLineModel.volume/10000.0f];
    self.volumeLabel.hidden = NO;
    self.maView.maModel = [HYKLineMAModel maModelWithMA5:kLineModel.MA5 MA10:kLineModel.MA10 MA20:kLineModel.MA20 MA30:kLineModel.MA30];
    
}
#pragma mark HYKLAboveView的当前最大股价和最小股价
-(void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice{
    //更新价格坐标轴
    self.priceView.maxValue = maxPrice;
    self.priceView.minValue = minPrice;
    self.priceView.middleValue = (maxPrice-minPrice)/2+minPrice;
}
-(void)kLineAboveViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels{
//    static NSInteger minCount = CGFLOAT_MAX;
//    static NSInteger maxCount = 0;
    self.kLineBelowView.needDrawKLineModels = needDrawKLineModels;
//    if (needDrawKLineModels.count < minCount) {
//        minCount = needDrawKLineModels.count;
//        NSLog(@"min:%ld,",minCount);
//    }
//    if (needDrawKLineModels.count > maxCount) {
//        maxCount = needDrawKLineModels.count;
//        NSLog(@"max:%ld\n",maxCount);
//    }
}
-(void)kLineAboveViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels{
    self.kLineBelowView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}
-(void)kLineAboveViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors{
    self.kLineBelowView.kLineColors = kLineColors;
    [self private_drawKLineBelowView];
}
#pragma mark - HYKLineBelowView的代理方法
-(void)kLineBelowViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume{
    self.volumeView.maxValue = maxVolume/10000.0f;
}
#pragma mark - UIScrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static BOOL isNeedPostNotification = YES;
    if (scrollView.contentOffset.x < scrollView.frame.size.width*2) {
        if (isNeedPostNotification) {
            self.oldRightOffset = scrollView.contentSize.width - scrollView.contentOffset.x;
            isNeedPostNotification = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:HYStockChartKLineNeedLoadMoreDataNotification object:nil];
        }
    }else{
        isNeedPostNotification = YES;
    }
}
#pragma mark - 释放资源方法
#pragma mark dealloc方法
-(void)dealloc{
    [_kLineAboveView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
