#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static void applyFontToLabels(UIView *view, int depth) {
    if (depth > 8) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)sub;
            if (label.text.length > 5) {
                label.font = [UIFont boldSystemFontOfSize:22];
            }
        }
        applyFontToLabels(sub, depth + 1);
    }
}

static void (*origLayout)(id, SEL);
static void hookLayout(id self, SEL _cmd) {
    origLayout(self, _cmd);
    applyFontToLabels((UIView *)self, 0);
}

static void hookClass(NSString *className) {
    Class cls = NSClassFromString(className);
    if (!cls) return;
    Method m = class_getInstanceMethod(cls, @selector(layoutSubviews));
    if (!m) return;
    origLayout = (void (*)(id, SEL))method_getImplementation(m);
    method_setImplementation(m, (IMP)hookLayout);
}

__attribute__((constructor)) static void init() {
    @autoreleasepool {
        hookClass(@"MRUActivityNowPlayingView");
        hookClass(@"MRUArtworkView");
        hookClass(@"MRUNowPlayingView");
    }
}
