#import <ControlCenterUI/CCUIControlCenterModule.h>
#import <ControlCenterUI/CCUIControlCenterButton.h>
#import <UIKit/UIKit.h>

@interface CCLockPlayerSwitch : NSObject <CCUIControlCenterModule>
@property (nonatomic, strong) CCUIControlCenterButton *button;
@property (nonatomic, assign) BOOL tweakEnabled;
@end

@implementation CCLockPlayerSwitch

- (instancetype)init {
    self = [super init];
    if(self){
        NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
        [ud registerDefaults:@{@"tweakEnabled":@(YES)}];
        _tweakEnabled = [ud boolForKey:@"tweakEnabled"];
    }
    return self;
}

- (CCUIControlCenterButton *)buttonView {
    if(!_button){
        _button = [[CCUIControlCenterButton alloc] init];
        [_button setImage:[UIImage systemImageNamed:@"music.note"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self updateButtonState];
    }
    return _button;
}

- (void)updateButtonState {
    if(_tweakEnabled){
        _button.selected = YES;
        _button.backgroundColor = [UIColor colorWithRed:0.22 green:0.55 blue:1 alpha:1];
    }else{
        _button.selected = NO;
        _button.backgroundColor = [UIColor darkGrayColor];
    }
}

- (void)tapAction:(id)sender {
    _tweakEnabled = !_tweakEnabled;
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud setBool:_tweakEnabled forKey:@"tweakEnabled"];
    [ud synchronize];
    [self updateButtonState];
}

- (NSString *)moduleIdentifier {
    return @"com.majiqian.lockplayermini.ccswitch";
}

- (NSString *)moduleDisplayName {
    return @"LockPlayer";
}

@end
