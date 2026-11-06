#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat titleFontSize = 18.0;

static void loadPrefs() {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud registerDefaults:@{@"fontSize": @18.0}];
    titleFontSize = [ud floatForKey:@"fontSize"];
}

static void applyFontOnce(UIView *view) {
    if (!view) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)sub;
            if (!objc_getAssociatedObject(lab, @"fontFixed")) {
                if(lab.text.length>5 && lab.text.length<60){
                    lab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
                }
                objc_setAssociatedObject(lab, @"fontFixed", @YES, OBJC_ASSOCIATION_RETAIN);
            }
        }
        applyFontOnce(sub);
    }
}

static void scanNowPlaying(void) {
    loadPrefs();
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
