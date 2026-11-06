static void applyFontToLabels(UIView *view, CGFloat titleSize, CGFloat artistSize, int depth) {
    if (depth > 5) return;
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)sub;
            NSString *text = label.text;
            if (text.length > 8) {
                label.font = [UIFont boldSystemFontOfSize:titleSize];
            } else if (text.length > 0) {
                label.font = [UIFont systemFontOfSize:artistSize];
            }
        }
        applyFontToLabels(sub, titleSize, artistSize, depth + 1);
    }
}

%hook MRUActivityNowPlayingView

- (void)layoutSubviews {
    %orig;

    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [defaults synchronize];

    BOOL enabled = [defaults boolForKey:@"enabled"];
    if (!enabled) return;

    CGFloat scale = [defaults floatForKey:@"scale"];
    if (scale < 0.5 || scale > 2.0) scale = 1.0;
    CGFloat titleSize = [defaults floatForKey:@"titleSize"];
    if (titleSize < 10 || titleSize > 40) titleSize = 17;
    CGFloat artistSize = [defaults floatForKey:@"artistSize"];
    if (artistSize < 8 || artistSize > 30) artistSize = 14;

    self.transform = CGAffineTransformMakeScale(scale, scale);
    applyFontToLabels(self, titleSize, artistSize, 0);
}

%end

%hook MRUArtworkView

- (void)layoutSubviews {
    %orig;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    if ([defaults boolForKey:@"enabled"]) {
        CGFloat scale = [defaults floatForKey:@"scale"];
        if (scale >= 0.5 && scale <= 2.0) {
            self.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

%end
