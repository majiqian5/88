#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static CGFloat titleFontSize = 18.0;

static void applyFontIfNeed(UILabel *label) {
    // 只修改一次，打上标记避免重复修改
    if(objc_getAssociatedObject(label, @"fontModified")) return;
    
    if(label.text.length > 5 && label.text.length < 60) {
        label.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
        objc_setAssociatedObject(label, @"fontModified", @(YES), OBJC_ASSOCIATION_RETAIN);
    }
}

static void recurseCheck(UIView *view) {
    for(UIView *sub in view.subviews) {
        if([sub isKindOfClass:[UILabel class]]){
            applyFontIfNeed((UILabel *)sub);
        }
        recurseCheck(sub);
    }
}

static void (*origDidAddSubview)(id self, SEL _cmd, UIView *subview);
static void hookDidAddSubview(id self, SEL _cmd, UIView *subview) {
    origDidAddSubview(self, _cmd, subview);
    recurseCheck(subview);
}

static void hookClass(NSString *clsName) {
    Class cls = NSClassFromString(clsName);
    if(!cls) return;
    Method m = class_getInstanceMethod(cls, @selector(didAddSubview:));
    if(!m) return;
    origDidAddSubview = (void(*)(id,SEL,UIView*))method_getImplementation(m);
    method_setImplementation(m, (IMP)hookDidAddSubview);
}

__attribute__((constructor)) static void tweak_main(){
    @autoreleasepool {
        hookClass(@"MRUActivityNowPlayingView");
        hookClass(@"MRUNowPlayingView");
    }
}
