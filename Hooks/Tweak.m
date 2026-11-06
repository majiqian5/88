#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static CGFloat titleFontSize = 18.0f;
static NSString *const PrefSuiteName = @"com.majiqian.lockplayermini";
static IMP orig_MPLockScreenNowPlayingView_layoutSubviews = NULL;
static IMP orig_MPControlCenterNowPlayingView_layoutSubviews = NULL;

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
            if(lab.text.length >3 && lab.text.length <70) {
                lab.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
            }
        }
        recursiveApplyFont(sub);
    }
}

static void hooked_LockScreen_layoutSubviews(id self, SEL _cmd) {
    ((void (*)(id, SEL))orig_MPLockScreenNowPlayingView_layoutSubviews)(self, _cmd);
    loadPrefs();
    recursiveApplyFont(self);
}

static void hooked_CC_layoutSubviews(id self, SEL _cmd) {
    ((void (*)(id, SEL))orig_MPControlCenterNowPlayingView_layoutSubviews)(self, _cmd);
    loadPrefs();
    recursiveApplyFont(self);
}

static void swizzleClassSaveIMP(Class cls, IMP *outOrigIMP, IMP hookImp) {
    if(!cls) return;
    SEL selLayout = @selector(layoutSubviews);
    Method origMethod = class_getInstanceMethod(cls, selLayout);
    if(!origMethod) return;
    *outOrigIMP = method_setImplementation(origMethod, hookImp);
}

__attribute__((constructor))
static void tweak_entry() {
    @autoreleasepool {
        Class lockCls = objc_getClass("MPLockScreenNowPlayingView");
        swizzleClassSaveIMP(lockCls, &orig_MPLockScreenNowPlayingView_layoutSubviews, (IMP)hooked_LockScreen_layoutSubviews);

        Class ctrlCls = objc_getClass("MPControlCenterNowPlayingView");
        swizzleClassSaveIMP(ctrlCls, &orig_MPControlCenterNowPlayingView_layoutSubviews, (IMP)hooked_CC_layoutSubviews);
    }
}
