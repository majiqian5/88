#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static CGFloat titleFontSize = 17.0;
static BOOL rainbowEnabled = YES;

static void loadPrefs() {
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.majiqian.lockplayermini"];
    if (prefs) {
        titleFontSize = [prefs[@"fontSize"] doubleValue];
        rainbowEnabled = [prefs[@"rainbowEnabled"] boolValue];
    }
}

static void applyRainbowToLabel(UILabel *label) {
    CGFloat w = label.bounds.size.width;
    CGFloat h = label.bounds.size.height;
    if (w <= 0 || h <= 0) return;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSArray *colors = @[
        (id)[UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.7 blue:0.2 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.9 blue:0.4 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.3 green:0.6 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.7 green:0.3 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.3 blue:0.6 alpha:1.0].CGColor
    ];
    CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(w, h), 0);
    CGGradientRelease(gradient);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    label.textColor = [UIColor colorWithPatternImage:img];
}

static void applyFontToLabels(UIView *view, int depth) {
    if (depth > 5) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)sub;
            if (label.text.length > 5 && label.text.length < 50) {
                label.font = [UIFont systemFontOfSize:titleFontSize weight:UIFontWeightSemibold];
                if (rainbowEnabled) {
                    applyRainbowToLabel(label);
                }
            }
        }
        applyFontToLabels(sub, depth + 1);
    }
}

static void (*origLayout)(id, SEL);
static void hookLayout(id self, SEL _cmd) {
    origLayout(self, _cmd);
    loadPrefs();
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
        loadPrefs();
        hookClass(@"MRUActivityNowPlayingView");
        hookClass(@"MRUArtworkView");
    }
}
