#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat titleFontSize = 18.0;
static BOOL rainbowEnabled = NO;
static BOOL tweakEnabled = YES;

static void loadPrefs() {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud registerDefaults:@{
        @"fontSize": @18.0,
        @"rainbowEnabled": @(NO),
        @"tweakEnabled": @(YES)
    }];
    titleFontSize = [ud floatForKey:@"fontSize"];
    rainbowEnabled = [ud boolForKey:@"rainbowEnabled"];
    tweakEnabled = [ud boolForKey:@"tweakEnabled"];
}

static UIImage* gradientImage(CGSize size) {
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.colors = @[
        (__bridge id)[UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:1.0 green:0.7 blue:0.2 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0.2 green:0.9 blue:0.4 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0.2 green:0.55 blue:1.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0.7 green:0.3 blue:1.0 alpha:1].CGColor
    ];
    grad.startPoint = CGPointMake(0,0);
    grad.endPoint = CGPointMake(1,1);
    grad.frame = CGRectMake(0,0,size.width,size.height);

    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [grad renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

static void applyFontOnce(UIView *view) {
    if (!view) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)sub;
            if (!objc_getAssociatedObject(lab, @"fontFixed")) {
                if(lab.text.length>5 && lab.text.length<60){
                    lab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
                    if(rainbowEnabled){
                        CGSize sz = lab.bounds.size;
                        if(sz.width>10 && sz.height>10){
                            lab.textColor = [UIColor colorWithPatternImage:gradientImage(sz)];
                        }
                    }
                }
                objc_setAssociatedObject(lab, @"fontFixed", @YES, OBJC_ASSOCIATION_RETAIN);
            }
        }
        applyFontOnce(sub);
    }
}

static void scanNowPlaying(void) {
    loadPrefs();
    if(!tweakEnabled) return;

    UIWindow *win = nil;
    for(UIWindow *w in [UIApplication sharedApplication].windows){
        if([w isKeyWindow]){
            win = w;
            break;
        }
    }
    if(!win) return;
    applyFontOnce(win);
}

__attribute__((constructor)) static void tweak_main(){
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:1.2 repeats:YES block:^(NSTimer *timer) {
            scanNowPlaying();
        }];
    }
}
