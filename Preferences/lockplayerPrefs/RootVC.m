#import <UIKit/UIKit.h>

@interface LockPlayerMiniRootVC : UITableViewController
@property (nonatomic, strong) UISlider *fontSlider;
@property (nonatomic, strong) UISwitch *rainbowSwitch;
@property (nonatomic, strong) UISwitch *masterSwitch;
@end

@implementation LockPlayerMiniRootVC

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LockPlayerMini";

    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud registerDefaults:@{
        @"fontSize": @18.0,
        @"rainbowEnabled": @(NO),
        @"tweakEnabled": @(YES)
    }];

    self.masterSwitch = [[UISwitch alloc] init];
    self.masterSwitch.on = [ud boolForKey:@"tweakEnabled"];
    [self.masterSwitch addTarget:self action:@selector(masterToggled:) forControlEvents:UIControlEventValueChanged];

    self.fontSlider = [[UISlider alloc] init];
    self.fontSlider.minimumValue = 12.0f;
    self.fontSlider.maximumValue = 30.0f;
    self.fontSlider.value = [ud floatForKey:@"fontSize"];
    [self.fontSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

    self.rainbowSwitch = [[UISwitch alloc] init];
    self.rainbowSwitch.on = [ud boolForKey:@"rainbowEnabled"];
    [self.rainbowSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) return @"总开关";
    if(section == 1) return @"彩虹标题";
    return @"字体大小";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = nil;
    cell.accessoryView = nil;

    if(indexPath.section == 0){
        cell.textLabel.text = @"启用插件（和控制中心同步）";
        cell.accessoryView = self.masterSwitch;
    }else if(indexPath.section == 1){
        cell.textLabel.text = @"开启彩虹渐变";
        cell.accessoryView = self.rainbowSwitch;
    }else{
        cell.textLabel.text = @"拖动调节字号";
        cell.accessoryView = self.fontSlider;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 2) return @"⚠️开启彩虹如果播放器空白，请关闭彩虹；总开关关闭全部修改不生效";
    return nil;
}

- (void)masterToggled:(UISwitch *)sender {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud setBool:sender.isOn forKey:@"tweakEnabled"];
    [ud synchronize];
}

- (void)switchToggled:(UISwitch *)sender {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud setBool:sender.isOn forKey:@"rainbowEnabled"];
    [ud synchronize];
}

- (void)sliderChanged:(UISlider *)sender {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud setFloat:sender.value forKey:@"fontSize"];
    [ud synchronize];
}

@end
