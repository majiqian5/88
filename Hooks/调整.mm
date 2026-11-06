#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static void applyFontToLabels(UIView *view, int depth) {
    if (depth > 5) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)sub;
            if (label.text.length > 8) {
                label.font = [UIFont boldSystemFontOfSize:19];
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

__attribute__((constructor)) static void init() {
    @autoreleasepool {
        Class cls = NSClassFromString(@"MRUActivityNowPlayingView");
        if (cls) {
            Method m = class_getInstanceMethod(cls, @selector(layoutSubviews));
            origLayout = (void *)method_getImplementation(m);
            method_setImplementation(m, (IMP)hookLayout);
        }
    }
}
