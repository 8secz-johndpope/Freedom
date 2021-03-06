//   Freedom
//  Created by Super on 14-8-8.
#import "E_ReaderViewController.h"
#import "BookSubViews.h"
#import "BookReadMode.h"
@interface E_ReaderViewController ()<E_ReaderViewDelegate>{
    E_ReaderView *_readerView;
}
@end
@implementation E_ReaderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
   // DLog(@"go -------");
    _readerView = [[E_ReaderView alloc] initWithFrame:CGRectMake(offSet_x, offSet_y, self.view.frame.size.width - 2 * offSet_x, self.view.frame.size.height - offSet_y - 20)];
    _readerView.keyWord = _keyWord;
    _readerView.magnifiterImage = _themeBgImage;
    _readerView.delegate = self;
    [self.view addSubview:_readerView];
}
#pragma mark - ReaderViewDelegate
- (void)shutOffGesture:(BOOL)yesOrNo{
    [_delegate shutOffPageViewControllerGesture:yesOrNo];
}
- (void)ciBa:(NSString *)ciBaString{
    [_delegate ciBaWithString:ciBaString];
}
- (void)hideSettingToolBar{
    [_delegate hideTheSettingBar];
}
- (void)setFont:(NSUInteger )font_{
    _readerView.font = font_;
}
- (void)setText:(NSString *)text{
    _text = text;
    _readerView.text = text;
    [_readerView render];
}
- (NSUInteger )font{
    return _readerView.font;
}
- (CGSize)readerTextSize{
    return _readerView.bounds.size;
}
@end
