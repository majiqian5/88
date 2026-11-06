#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat titleFontSize = 18.0;

static void loadPrefs() {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud registerDefaults:@{@"fontSize": @18.0}];
    titleFontSize = [ud floatForKey:@"fontSize"];
}

static void applyFont(UIView *view, int depth) {
    if (depth > 8) return;
    if (!view) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)sub;
            if(lab.text.length > 5 && lab.text.length < 60){
                lab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
            }
        }
        applyFont(sub, depth + 1);
    }
}

static void scanAllWindows() {
    loadPrefs();
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        applyFont(win, 0);
    }
}

__attribute__((constructor)) static void tweak_main(){
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
            scanAllWindows();
        }];
    }
}
