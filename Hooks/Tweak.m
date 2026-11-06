#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat titleFontSize = 18.0;
static NSString *const PrefSuiteName = @"com.majiqian.lockplayermini";

static void loadPrefs() {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:PrefSuiteName];
    [ud registerDefaults:@{@"fontSize": @18.0}];
    titleFontSize = [ud floatForKey:@"fontSize"];
}

static void applyFont(UIView *view) {
    if (!view) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)sub;
            if(lab.text.length > 5 && lab.text.length < 60){
                lab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
            }
        }
        applyFont(sub);
    }
}

static void scanPlayerView() {
    loadPrefs();
    // 遍历全部窗口，适配iOS16锁屏播放器独立窗口
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        applyFont(win);
    }
}

__attribute__((constructor)) static void tweak_main(){
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:1.2 repeats:YES block:^(NSTimer *timer) {
            scanPlayerView();
        }];
    }
}
