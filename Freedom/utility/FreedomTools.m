//  FreedomTools.m
//  Freedom
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "FreedomTools.h"
@implementation FreedomTools
+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
+(FreedomTools *)sharedManager{
    static FreedomTools *shareUrl = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareUrl = [[self alloc]init];
    });
    return shareUrl;
}
//重定向log到本地问题 在info.plist中打开Application supports iTunes file sharing
+(void)expireLogFiles{
    NSString *deviceModel = [[UIDevice currentDevice] model];
    if ([deviceModel isEqualToString:@"iPhone Simulator"]) {
        return;
    }else if([deviceModel isEqualToString:@"iPhone"]){
        return;
    }
    NSLog(@"Log重定向到本地，如果您需要控制台Log，注释掉重定向逻辑即可。");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *logPath = [paths objectAtIndex:0];
    //删除超过时间的log文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:logPath error:nil]];
    NSDate *currentDate = [NSDate date];
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow: -7*24*60*60];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *fileComp = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    fileComp = [calendar components:unitFlags fromDate:currentDate];
    for (NSString *fileName in fileList) {
        if (fileName.length != 16 || ![[fileName substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"rc"]) {
            continue;
        }
        int month = [[fileName substringWithRange:NSMakeRange(2, 2)] intValue];
        int date = [[fileName substringWithRange:NSMakeRange(4, 2)] intValue];
        if (month <= 0 || date <=0) {
            continue;
        }else{
            [fileComp setMonth:month];
            [fileComp setDay:date];
        }
        NSDate *fileDate = [calendar dateFromComponents:fileComp];
        if ([fileDate compare:currentDate] == NSOrderedDescending || [fileDate compare:expireDate] == NSOrderedAscending) {
            [fileManager removeItemAtPath:[logPath stringByAppendingPathComponent:fileName] error:nil];
        }
    }
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MMddHHmmss"];
    NSString *formattedDate = [dateformatter stringFromDate:currentDate];
    NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
    NSString *logFilePath = [logPath stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",stderr);
}
//验证手机号码
+ (BOOL)validateMobile:(NSString *)mobile {
    if (mobile.length == 0) {
        NSString *message = @"手机号码不能为空！";
        [SVProgressHUD showErrorWithStatus:message];
        return NO;
    }
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if (![phoneTest evaluateWithObject:mobile]) {
        NSString *message = @"手机号码格式不正确！";
        [SVProgressHUD showErrorWithStatus:message];
        return NO;
    }
    return YES;
}
//验证电子邮箱
+ (BOOL)validateEmail:(NSString *)email {
    if (email.length == 0) {
        return NO;
    }
    NSString *expression = [NSString stringWithFormat:@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match =
    [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    if (!match) {
        return NO;
    }
    return YES;
}

+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath =
    [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    return image;
}
+ (NSString *)defaultGroupPortrait:(RCGroup *)groupInfo {
    NSString *filePath = [[self class] getIconCachePath:[NSString stringWithFormat:@"group%@.png", groupInfo.groupId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
        return [portraitPath absoluteString];
    } else {
        UIView *defaultPortrait =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        defaultPortrait.backgroundColor = [UIColor redColor];
        NSString *firstLetter = [groupInfo.groupName pinyinFirstLetter];
        UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
        firstCharacterLabel.text = firstLetter;
        firstCharacterLabel.textColor = [UIColor whiteColor];
        firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
        firstCharacterLabel.font = [UIFont systemFontOfSize:50];
        [defaultPortrait addSubview:firstCharacterLabel];
        UIImage *portrait = [defaultPortrait imageFromView];
        BOOL result = [UIImagePNGRepresentation(portrait) writeToFile:filePath atomically:YES];
        if (result) {
            NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
            return [portraitPath absoluteString];
        } else {
            return nil;
        }
    }
}
+ (NSString *)defaultUserPortrait:(RCUserInfo *)userInfo {
    NSString *filePath = [[self class]getIconCachePath:[NSString stringWithFormat:@"user%@.png", userInfo.userId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
        return [portraitPath absoluteString];
    } else {
        UIView *defaultPortrait =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        defaultPortrait.backgroundColor = [UIColor redColor];
        NSString *firstLetter = [userInfo.name pinyinFirstLetter];
        UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
        firstCharacterLabel.text = firstLetter;
        firstCharacterLabel.textColor = [UIColor whiteColor];
        firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
        firstCharacterLabel.font = [UIFont systemFontOfSize:50];
        [defaultPortrait addSubview:firstCharacterLabel];
        UIImage *portrait = [defaultPortrait imageFromView];
        BOOL result = [UIImagePNGRepresentation(portrait) writeToFile:filePath atomically:YES];
        if (result) {
            NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
            return [portraitPath absoluteString];
        } else {
            return nil;
        }
    }
}
+ (NSString *)getIconCachePath:(NSString *)fileName {
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath =
    [cachPath stringByAppendingPathComponent:
     [NSString stringWithFormat:@"CachedIcons/%@",fileName]]; // 保存文件的名称
    NSString *dirPath = [cachPath stringByAppendingPathComponent:[NSString stringWithFormat:@"CachedIcons"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirPath]) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}
+ (NSString *)hanZiToPinYinWithString:(NSString *)hanZi {
    if (!hanZi) {
        return nil;
    }
    NSString *pinYinResult = [NSString string];
    for (int j = 0; j < hanZi.length; j++) {
        NSString *singlePinyinLetter = nil;
        if ([self isChinese:[hanZi substringWithRange:NSMakeRange(j, 1)]]) {
            NSString *word = [NSString stringWithFormat:@"%c", [hanZi characterAtIndex:j]];
            singlePinyinLetter = [word pinyinFirstLetter];
        }else{
            singlePinyinLetter = [hanZi substringWithRange:NSMakeRange(j, 1)];
        }
        pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
    }
    return pinYinResult;
}
+ (BOOL)isChinese:(NSString *)text{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:text];
}
+ (NSString *)getFirstUpperLetter:(NSString *)hanzi {
    NSString *pinyin = [self hanZiToPinYinWithString:hanzi];
    NSString *firstUpperLetter = [[pinyin substringToIndex:1] uppercaseString];
    if ([firstUpperLetter compare:@"A"] != NSOrderedAscending &&
        [firstUpperLetter compare:@"Z"] != NSOrderedDescending) {
        return firstUpperLetter;
    } else {
        return @"#";
    }
}
+ (NSMutableDictionary *)sortedArrayWithPinYinDic:(NSArray *)userList {
    if (!userList) return nil;
    NSArray *_keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    NSMutableDictionary *infoDic = [NSMutableDictionary new];
    NSMutableArray *_tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    for (NSString *key in _keys) {
        if ([_tempOtherArr count]) {
            isReturn = YES;
        }
        NSMutableArray *tempArr = [NSMutableArray new];
        for (id user in userList) {
            NSString *firstLetter;
            if ([user isMemberOfClass:[RCDUserInfo class]]) {
                RCDUserInfo *userInfo = (RCDUserInfo*)user;
                if (userInfo.displayName.length > 0 && ![userInfo.displayName isEqualToString:@""]) {
                    firstLetter = [self getFirstUpperLetter:userInfo.displayName];
                } else {
                    firstLetter = [self getFirstUpperLetter:userInfo.name];
                }
            }
            if ([user isMemberOfClass:[RCUserInfo class]]) {
                RCUserInfo *userInfo = (RCUserInfo*)user;
                firstLetter = [self getFirstUpperLetter:userInfo.name];
            }
            if ([firstLetter isEqualToString:key]) {
                [tempArr addObject:user];
            }
            if (isReturn) continue;
            char c = [firstLetter characterAtIndex:0];
            if (isalpha(c) == 0) {
                [_tempOtherArr addObject:user];
            }
        }
        if (![tempArr count]) continue;
        [infoDic setObject:tempArr forKey:key];
    }
    if ([_tempOtherArr count])
        [infoDic setObject:_tempOtherArr forKey:@"#"];
    NSArray *keys = [[infoDic allKeys]sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithArray:keys];
    NSMutableDictionary *resultDic = [NSMutableDictionary new];
    [resultDic setObject:infoDic forKey:@"infoDic"];
    [resultDic setObject:allKeys forKey:@"allKeys"];
    return resultDic;
}
+ (BOOL)isContains:(NSString *)firstString withString:(NSString *)secondString{
    if (firstString.length == 0 || secondString.length == 0) {
        return NO;
    }
    NSString *twoStr = [[secondString stringByReplacingOccurrencesOfString:@" "  withString:@""] lowercaseString];
    if ([[firstString lowercaseString] containsString:[secondString lowercaseString]] || [[firstString lowercaseString] containsString:twoStr]
        || [[[self hanZiToPinYinWithString:firstString] lowercaseString] containsString:twoStr]) {
        return YES;
    }
    return NO;
}
+ (UIImage*)imageWithColor:(UIColor*)color{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, 1);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+ (void)show:(nullable NSString *)msg {
    UILabel *_msgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -64, APPW, 64)];
    _msgLab.backgroundColor = UIColor(0, 0, 0, 0.6);
    _msgLab.text = msg;
    _msgLab.textColor = [UIColor whiteColor];
    _msgLab.font = [UIFont boldSystemFontOfSize:18];
    _msgLab.textAlignment = NSTextAlignmentCenter;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_msgLab];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _msgLab.frame;
        frame.origin.y = 0;
        _msgLab.frame = frame;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_msgLab removeFromSuperview];
    });
}
@end
