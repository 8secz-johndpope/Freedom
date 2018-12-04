
#import "HYKLineAboveView.h"
#import "HYStockChartConstant.h"
#import "KLineModel.h"
#import "HYStockChartTool.h"
#import "StockCategory.h"
typedef NS_ENUM(NSInteger, HYMAType){
    HYMA5Type = 0,
    HYMA10Type,
    HYMA20Type,
    HYMA30Type
};
/************************画均线的画笔************************/
@interface HYMALine : NSObject
@property(nonatomic,strong) NSArray *MAPositions;
@property(nonatomic,assign) HYMAType MAType;
/**
 *  根据context初始化均线画笔
 */
-(instancetype)initWitContext:(CGContextRef)context;
-(void)draw;
@end
@interface HYMALine ()
@property(nonatomic,assign) CGContextRef context;
@end
@implementation HYMALine
/**
 *  根据context初始化均线画笔
 */
-(instancetype)initWitContext:(CGContextRef)context{
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}
-(void)draw{
    if (!self.context || !self.MAPositions) {
        return;
    }
    UIColor *lineColor = nil;
    switch (self.MAType) {
        case HYMA5Type:
            lineColor = [FreedomTools colorWithRGBHex:0xff783c];
            break;
        case HYMA10Type:
            lineColor = [FreedomTools colorWithRGBHex:0x49a5ff];
            break;
        case HYMA20Type:
            lineColor = [FreedomTools colorWithRGBHex:0xffbf43];
            break;
        case HYMA30Type:
            lineColor = [FreedomTools colorWithRGBHex:0x49a5ff];
            break;
        default:
            break;
    } CGContextSetStrokeColorWithColor(self.context,lineColor.CGColor);
    CGContextSetLineWidth(self.context, HYStockChartMALineWidth);
    
    NSInteger count = self.MAPositions.count;
    CGPoint point = [self.MAPositions[0] CGPointValue];
    NSAssert(!isnan(point.x) && !isnan(point.y), @"画MA线的时候出现NAN");
    CGContextMoveToPoint(self.context, point.x, point.y);
    for (NSInteger idx = 1; idx < count; idx++) {
        CGPoint point = [self.MAPositions[idx] CGPointValue];
        CGContextAddLineToPoint(self.context, point.x, point.y);
    }
    CGContextStrokePath(self.context);
}
@end

@interface HYKLineAboveView ()
/** 当前需要展示的k线模型*/
@property(nonatomic,strong,readwrite) NSMutableArray *needDrawKLineModels;
 /** 当前需要展示的相对于视图的点的位置*/
@property(nonatomic,strong,readwrite) NSMutableArray *needDrawKLinePositionModels;
 /** 从第几条数据开始*/
@property(nonatomic,assign,readwrite) NSUInteger needDrawStartIndex;
 /** 开始的位置*/
@property(nonatomic,assign,readonly) CGFloat startXPosition;
@property(nonatomic,assign) CGFloat oldContentOffsetX;
@property(nonatomic,assign) CGFloat oldScale;
@property(nonatomic,strong) NSMutableArray *MA5Positions;
@property(nonatomic,strong) NSMutableArray *MA10Positions;
@property(nonatomic,strong) NSMutableArray *MA20Positions;
@property(nonatomic,strong) NSMutableArray *MA30Positions;
@end
@implementation HYKLineAboveView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.needDrawKLinePositionModels = [NSMutableArray array];
        self.needDrawKLineModels = [NSMutableArray array];
        self.MA5Positions = [NSMutableArray array];
        self.MA10Positions = [NSMutableArray array];
        self.MA20Positions = [NSMutableArray array];
        self.MA30Positions = [NSMutableArray array];
        self.needDrawStartIndex = 0;
        self.oldContentOffsetX = 0;
        self.oldScale = 0;
    }
    return self;
}

#pragma mark - 绘图相关方法
#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //如果数组是空的，直接将本view设置为背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.kLineModels) {
        CGContextClearRect(context, rect);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextFillRect(context, rect);
        return;
    }
    
    NSMutableArray *kLineColors = [NSMutableArray array];
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    [self drawline:context startPoint:CGPointMake(0, HYStockChartKLineAboveViewMaxY) stopPoint:CGPointMake(self.frame.size.width, HYStockChartKLineAboveViewMaxY) color:GridLineColor lineWidth:HYStockChartTimeLineGridWidth];
    
    //上边线
    CGPoint startPoint = CGPointMake(0.0, HYStockChartKLineAboveViewMinY);
    CGPoint endPoint = CGPointMake(rect.size.width, HYStockChartKLineAboveViewMinY);
    [self drawline:context startPoint:startPoint stopPoint:endPoint color:[UIColor colorWithWhite:226/255.0 alpha:1] lineWidth:0.25];
    
    //下边线
    CGPoint downStartPoint = CGPointMake(0.0, HYStockChartKLineAboveViewMaxY - 10);
    CGPoint downEndPoint = CGPointMake(rect.size.width, HYStockChartKLineAboveViewMaxY - 10);
    [self drawline:context startPoint:downStartPoint stopPoint:downEndPoint color:[UIColor colorWithWhite:266/255.0 alpha:1] lineWidth:0.25];
    
    CGFloat middleLineY = (HYStockChartKLineAboveViewMaxY  -HYStockChartKLineAboveViewMinY)/2.0 + HYStockChartKLineAboveViewMinY;
    //中线
    CGPoint middleStartPoint = CGPointMake(0.0, middleLineY);
    CGPoint middleEndPoint = CGPointMake(rect.size.width, middleLineY);
    [self drawline:context startPoint:middleStartPoint stopPoint:middleEndPoint color:[UIColor colorWithWhite:226/255.0 alpha:1] lineWidth:0.25];
    
    //设置显示日期那个区域的背景颜色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, HYStockChartKLineAboveViewMaxY, self.frame.size.width, self.frame.size.height-HYStockChartKLineAboveViewMaxY));
    HYKLine *kLine = [[HYKLine alloc] initWithContext:context];
    kLine.maxY = HYStockChartKLineAboveViewMaxY;
    NSInteger idx = 0;
    NSArray *kLinePositioinModels = self.needDrawKLinePositionModels;
    for (HYKLinePositionModel *kLinePositionModel in kLinePositioinModels) {
        kLine.kLinePositionModel = kLinePositionModel;
        kLine.kLineModel = self.needDrawKLineModels[idx];
        UIColor *kLineColor = [kLine draw];
        [kLineColors addObject:kLineColor];
        idx++;
    }
    
    HYMALine *MALine = [[HYMALine alloc] initWitContext:context];
    //1.画MA5线
    MALine.MAType = HYMA5Type;
    MALine.MAPositions = self.MA5Positions;
    [MALine draw];
    
    //2.画MA10线
    MALine.MAType = HYMA10Type;
    MALine.MAPositions = self.MA10Positions;
    [MALine draw];
    
    //3.画MA20线
    MALine.MAType = HYMA20Type;
    MALine.MAPositions = self.MA20Positions;
    [MALine draw];
    
    //4.画MA30线
    MALine.MAType = HYMA30Type;
    MALine.MAPositions = self.MA30Positions;
    [MALine draw];
    
    if (self.delegate && kLineColors.count > 0) {
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentNeedDrawKLineColors:)]) {
            [self.delegate kLineAboveViewCurrentNeedDrawKLineColors:kLineColors];
        }
    }
}
#pragma mark - **************** 绘制线
- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth{
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}
#pragma mark 重新设置相关变量，然后绘图
-(void)drawAboveView{
    NSAssert(self.kLineModels, @"kLineModels不能为空!");
    //先提取需要展示的kLineModel
    [self private_extractNeedDrawModels];
    //将stockModel转换成坐标模型
    [self private_convertToKLinePositionModelWithKLineModels];
    //间接调用drawRect方法
    [self setNeedsDisplay];
}
#pragma mark - set&get方法
#pragma mark startXPosition的get方法当前绘制x位置
-(CGFloat)startXPosition{
    CGFloat lineGap = [HYStockChartTool kLineGap];
    CGFloat lineWidth = [HYStockChartTool kLineWidth];
    NSInteger leftArrCount = self.needDrawStartIndex;
    CGFloat startXPosition = (leftArrCount+1)*lineGap + leftArrCount*lineWidth+lineWidth/2;
    return startXPosition;
}

#pragma mark needDrawStartIndex的get方法当前位置
-(NSUInteger)needDrawStartIndex{
    CGFloat lineGap = [HYStockChartTool kLineGap];
    CGFloat lineWidth = [HYStockChartTool kLineWidth];
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - lineGap)/(lineWidth+lineGap);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

#pragma mark stockModels的set方法
-(void)setKLineModels:(NSArray *)kLineModels{
    _kLineModels = kLineModels;
    [self updateAboveViewWidth];
}
#pragma mark - 公有方法
#pragma mark 更新自身view的宽度
-(void)updateAboveViewWidth{
    //根据stockModels个数和间隙以及K线的宽度算出self的宽度,设置contentSize
    CGFloat kLineViewWidth = self.kLineModels.count * [HYStockChartTool kLineWidth] + (self.kLineModels.count + 1) * [HYStockChartTool kLineGap];
    if (kLineViewWidth < [UIScreen mainScreen].bounds.size.width) {
        kLineViewWidth = [UIScreen mainScreen].bounds.size.width;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kLineViewWidth));
    }];
    [self layoutIfNeeded];
    //更新scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
}
#pragma mark 根据原始的x的位置获得精确的X的位置
-(HYKLinePositionModel *)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition{
    CGFloat xPositionInAboveView = originXPosition;
    NSInteger startIndex = (NSInteger)((xPositionInAboveView-self.startXPosition) / ([HYStockChartTool kLineGap]+[HYStockChartTool kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex-1 : 0; index < arrCount; ++index) {
        HYKLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        CGFloat minX = kLinePositionModel.highPoint.x - ([HYStockChartTool kLineGap]+[HYStockChartTool kLineWidth])/2;
        CGFloat maxX = kLinePositionModel.highPoint.x + ([HYStockChartTool kLineGap]+[HYStockChartTool kLineWidth])/2;
        if (xPositionInAboveView > minX && xPositionInAboveView < maxX) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(kLineAboveViewLongPressKLinePositionModel:kLineModel:)]) {
                [self.delegate kLineAboveViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
           // return kLinePositionModel.highPoint.x;
            return kLinePositionModel;
        }
    }
    return 0;
}

-(HYKLineModel *)getRightXLocationWithOriginXPosition:(CGFloat)originXPosition{
    CGFloat xPositionInAboveView = originXPosition;
    NSInteger startIndex = (NSInteger)((xPositionInAboveView-self.startXPosition) / ([HYStockChartTool kLineGap]+[HYStockChartTool kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex-1 : 0; index < arrCount; ++index) {
        HYKLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        CGFloat minX = kLinePositionModel.highPoint.x - ([HYStockChartTool kLineGap]+[HYStockChartTool kLineWidth])/2;
        CGFloat maxX = kLinePositionModel.highPoint.x + ([HYStockChartTool kLineGap]+[HYStockChartTool kLineWidth])/2;
        if (xPositionInAboveView > minX && xPositionInAboveView < maxX) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(kLineAboveViewLongPressKLinePositionModel:kLineModel:)]) {
                [self.delegate kLineAboveViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
            // return kLinePositionModel.highPoint.x;
            HYKLineModel *kLineModel = self.needDrawKLineModels[index];
            return kLineModel;
        }
    }
    return 0;
}

#pragma mark - 私有方法
#pragma mark 提取需要绘制的数组
-(NSArray *)private_extractNeedDrawModels{
    CGFloat lineGap = [HYStockChartTool kLineGap];
    CGFloat lineWidth = [HYStockChartTool kLineWidth];
    //数组个数
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
    //起始位置
    NSInteger needDrawKLineStartIndex = self.needDrawStartIndex;
    [self.needDrawKLineModels removeAllObjects];
    if ((needDrawKLineStartIndex + needDrawKLineCount) < self.kLineModels.count) {
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
    }else if(needDrawKLineStartIndex<self.kLineModels.count){
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count-needDrawKLineStartIndex)]];
    }else{
        [self.needDrawKLineModels addObjectsFromArray:self.kLineModels];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentNeedDrawKLineModels:)]) {
            [self.delegate kLineAboveViewCurrentNeedDrawKLineModels:self.needDrawKLineModels];
        }
    }
    return self.needDrawKLineModels;
}
#pragma mark 将stockModel模型转换成KLine模型
-(NSArray *)private_convertToKLinePositionModelWithKLineModels{
    if (!self.needDrawKLineModels) {
        return nil;
    }
    NSArray *kLineModels = self.needDrawKLineModels;
    //算得最小单位
    HYKLineModel *firstModel = (HYKLineModel *)[kLineModels firstObject];
    CGFloat minAssert = firstModel.low;
    CGFloat maxAssert = firstModel.high;
    CGFloat minMA5 = CGFLOAT_MAX;
    CGFloat maxMA5 = CGFLOAT_MIN;
    CGFloat minMA10 = CGFLOAT_MAX;
    CGFloat maxMA10 = CGFLOAT_MIN;
    CGFloat minMA20 = CGFLOAT_MAX;
    CGFloat maxMA20 = CGFLOAT_MIN;
    CGFloat minMA30 = CGFLOAT_MAX;
    CGFloat maxMA30 = CGFLOAT_MIN;
    for (HYKLineModel *kLineModel in kLineModels) {
        if (kLineModel.high > maxAssert) {
            maxAssert = kLineModel.high;
        }
        if (kLineModel.low < minAssert) {
            minAssert = kLineModel.low;
        }
        if (minMA5 > kLineModel.MA5) {
            minMA5 = kLineModel.MA5;
        }
        if (maxMA5 < kLineModel.MA5) {
            maxMA5 = kLineModel.MA5;
        }
        if (minMA10 > kLineModel.MA10) {
            minMA10 = kLineModel.MA10;
        }
        if (maxMA10 < kLineModel.MA10) {
            maxMA10 = kLineModel.MA10;
        }
        if (minMA20 > kLineModel.MA20) {
            minMA20 = kLineModel.MA20;
        }
        if (maxMA20 < kLineModel.MA20) {
            maxMA20 = kLineModel.MA20;
        }
        if (minMA30 > kLineModel.MA30) {
            minMA30 = kLineModel.MA30;
        }
        if (maxMA30 < kLineModel.MA30) {
            maxMA30 = kLineModel.MA30;
        }
    }
    CGFloat minY = HYStockChartKLineAboveViewMinY;
    CGFloat maxY = HYStockChartKLineAboveViewMaxY - 10;
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);
    CGFloat ma5UnitValue = (maxMA5 - minMA5)/(maxY-minY);
    CGFloat ma10UnitValue = (maxMA10 - minMA10)/(maxY-minY);
    CGFloat ma20UnitValue = (maxMA20 - minMA20)/(maxY-minY);
    CGFloat ma30UnitValue = (maxMA30 - minMA30)/(maxY-minY);
    
    [self.needDrawKLinePositionModels removeAllObjects];
    [self.MA5Positions removeAllObjects];
    [self.MA10Positions removeAllObjects];
    [self.MA20Positions removeAllObjects];
    [self.MA30Positions removeAllObjects];
    
    NSInteger kLineModelsCount = kLineModels.count;
    for (NSInteger idx = 0; idx < kLineModelsCount; ++idx) {
        //1.转换K线位置代码
        HYKLineModel *kLineModel = kLineModels[idx];
        CGFloat xPosition = self.startXPosition + idx*([HYStockChartTool kLineWidth]+[HYStockChartTool kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.open-minAssert)/unitValue));
        
        CGFloat closePointY = ABS(maxY - (kLineModel.close-minAssert)/unitValue);
        if (ABS(closePointY - openPoint.y) < HYStockChartKLineMinWidth) {
            if (openPoint.y > closePointY) {
                openPoint.y = closePointY+HYStockChartKLineMinWidth;
            }else if (openPoint.y < closePointY){
                closePointY = openPoint.y + HYStockChartKLineMinWidth;
            }else{
                if (idx > 0) {
                    HYKLineModel *preKLineModel = kLineModels[idx-1];
                    if (kLineModel.open > preKLineModel.close) {
                        openPoint.y = closePointY + HYStockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + HYStockChartKLineMinWidth;
                    }
                }else if(idx+1 < kLineModelsCount){
                    HYKLineModel *subKLineModel = kLineModels[idx+1];
                    if (kLineModel.close < subKLineModel.open) {
                        openPoint.y = closePointY + HYStockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + HYStockChartKLineMinWidth;
                    }
                }
            }
        }
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.high-minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.low-minAssert)/unitValue));
        HYKLinePositionModel *kLinePositionModel = [HYKLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
        
        //2.转换成MA的代码
        CGFloat ma5Y = maxY;
        CGFloat ma10Y = maxY;
        CGFloat ma20Y = maxY;
        CGFloat ma30Y = maxY;
        if (ma5UnitValue  > 0.000001) {
            ma5Y = maxY - (kLineModel.MA5 - minMA5)/ma5UnitValue;
        }
        if (ma10UnitValue  > 0.000001) {
            ma10Y = maxY - (kLineModel.MA10 - minMA10)/ma10UnitValue;
        }
        if (ma20UnitValue  > 0.000001) {
            ma20Y = maxY - (kLineModel.MA20 - minMA20)/ma20UnitValue;
        }
        if (ma30UnitValue  > 0.000001) {
            ma30Y = maxY - (kLineModel.MA30 - minMA30)/ma30UnitValue;
        }
        
        NSAssert(!isnan(ma5Y) && !isnan(ma10Y) && !isnan(ma20Y) && !isnan(ma30Y), @"出现了NAN值!");
        CGPoint ma5Point = CGPointMake(xPosition, ma5Y);
        CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
        CGPoint ma20Point = CGPointMake(xPosition, ma20Y);
        CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
        [self.MA5Positions addObject:[NSValue valueWithCGPoint:ma5Point]];
        [self.MA10Positions addObject:[NSValue valueWithCGPoint:ma10Point]];
        [self.MA20Positions addObject:[NSValue valueWithCGPoint:ma20Point]];
        [self.MA30Positions addObject:[NSValue valueWithCGPoint:ma30Point]];
    }
    //执行代理方法
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentMaxPrice:minPrice:)]) {
            [self.delegate kLineAboveViewCurrentMaxPrice:maxAssert minPrice:minAssert];
        }
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentNeedDrawKLinePositionModels:)]) {
            [self.delegate kLineAboveViewCurrentNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    return self.needDrawKLinePositionModels;
}

static char *observerContext = NULL;
#pragma mark 添加所有事件监听的方法
-(void)private_addAllEventListenr{
    //用KVO监听scrollView的状态改变
    [_scrollView addObserver:self forKeyPath:HYStockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:observerContext];
}
#pragma mark - 系统方法
#pragma mark 已经添加到父view的方法
-(void)didMoveToSuperview{
    _scrollView = (UIScrollView *)self.superview;
    [self private_addAllEventListenr];
    [super didMoveToSuperview];
}
#pragma mark KVO监听实现的方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:HYStockChartContentOffsetKey]) {
        CGFloat difValue = ABS(self.scrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue >= ([HYStockChartTool kLineGap]+[HYStockChartTool kLineWidth])) {
            self.oldContentOffsetX = self.scrollView.contentOffset.x;
            [self drawAboveView];
        }
    }
}
#pragma mark - 垃圾回收方法
#pragma mark 移除所有监听
-(void)removeAllObserver{
    [_scrollView removeObserver:self forKeyPath:HYStockChartContentOffsetKey context:observerContext];
}
#pragma mark dealloc方法
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end