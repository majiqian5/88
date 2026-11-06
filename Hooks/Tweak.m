#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static CGFloat titleFontSize = 18.0f;
static NSString *const PrefSuiteName = @"com.majiqian.lockplayermini";

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

static void hooked_layoutSubviews(id self, SEL _cmd) {
    //调用原方法
    struct objc_super sup;
    sup.receiver = self;
    sup.super_class = class_getSuperclass(object_getClass(self));
    objc_msgSendSuper(&sup, _cmd);

    loadPrefs();
    recursiveApplyFont(self);
}

static void swizzleClass(Class cls) {
    if(!cls) return;
    SEL selLayout = @selector(layoutSubviews);
    IMP hookImp = (IMP)hooked_layoutSubviews;
    Method origMethod = class_getInstanceMethod(cls, selLayout);
    if(!origMethod) return;
    //安全交换
    class_addMethod(cls, selLayout, hookImp, method_getTypeEncoding(origMethod));
    method_exchangeImplementations(class_getInstanceMethod(cls, selLayout), origMethod);
}

__attribute__((constructor))
static void tweak_entry() {
    @autoreleasepool {
        //优先锁屏播放器、其次控制中心父视图
        Class lockCls = objc_getClass("MPLockScreenNowPlayingView");
        swizzleClass(lockCls);

        Class ctrlCls = objc_getClass("MPControlCenterNowPlayingView");
        swizzleClass(ctrlCls);

        //兜底定时器，每1.3秒扫描所有窗口，防止hook失效
        [NSTimer scheduledTimerWithTimeInterval:1.3 repeats:YES block:^(NSTimer *timer) {
            loadPrefs();
            for(UIWindow *win in [UIApplication sharedApplication].windows) {
                recursiveApplyFont(win);
            }
        }];
    }
}
