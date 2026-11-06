#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static CGFloat titleFontSize = 18.0f;
static NSString *const PrefSuiteName = @"com.majiqian.lockplayermini";
static IMP orig_layoutSubviews = NULL;

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
            if(lab.text.length > 3 && lab.text.length < 70) {
                lab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
            }
        }
        recursiveApplyFont(sub);
    }
}

static void hooked_layoutSubviews(id self, SEL _cmd) {
    ((void (*)(id, SEL))orig_layoutSubviews)(self, _cmd);
    loadPrefs();
    recursiveApplyFont(self);
}

__attribute__((constructor))
static void tweak_entry() {
    // 先试MRUActivityNowPlayingView（Spectrums验证过的类）
    Class targetCls = objc_getClass("MRUActivityNowPlayingView");
    if (!targetCls) {
        // 备选：MPNowPlayingInfoView
        targetCls = objc_getClass("MPNowPlayingInfoView");
    }
    if (!targetCls) return;

    SEL sel = @selector(layoutSubviews);
    Method origMethod = class_getInstanceMethod(targetCls, sel);
    if (!origMethod) return;

    orig_layoutSubviews = method_setImplementation(origMethod, (IMP)hooked_layoutSubviews);
}
