#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <substrate.h>

static CGFloat titleFontSize = 18.0f;
static NSString *const PrefSuiteName = @"com.majiqian.lockplayermini";
static void (*orig_didMoveToWindow)(id self, SEL _cmd);

static void loadPrefs() {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:PrefSuiteName];
    [ud registerDefaults:@{@"fontSize": @18.0f}];
    titleFontSize = [ud floatForKey:@"fontSize"];
}

static void recursiveApplyFont(UIView *view) {
    if (!view) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)sub;
            if(lab.text.length > 5 && lab.text.length < 70) {
                lab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
            }
        }
        recursiveApplyFont(sub);
    }
}

void hooked_didMoveToWindow(id self, SEL _cmd) {
    orig_didMoveToWindow(self, _cmd);
    loadPrefs();
    recursiveApplyFont(self);
}

__attribute__((constructor))
static void tweak_entry() {
    Class targetCls = objc_getClass("MPNowPlayingInfoView");
    if (!targetCls) return;

    MSHookMessageEx(
        targetCls,
        @selector(didMoveToWindow),
        (IMP)hooked_didMoveToWindow,
        (IMP *)&orig_didMoveToWindow
    );
}
