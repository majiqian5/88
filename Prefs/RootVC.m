#import <UIKit/UIKit.h>

@interface LockPlayerMiniRootVC : UITableViewController
@property (nonatomic, strong) UISlider *fontSlider;
@end

@implementation LockPlayerMiniRootVC

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LockPlayerMini";
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud registerDefaults:@{@"fontSize": @18.0}];

    self.fontSlider = [[UISlider alloc] init];
    self.fontSlider.minimumValue = 12.0f;
    self.fontSlider.maximumValue = 30.0f;
    self.fontSlider.value = [ud floatForKey:@"fontSize"];
    [self.fontSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 1; }
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return @"字体大小"; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"拖动调节";
    cell.accessoryView = self.fontSlider;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"修改后切歌重新调出播放器生效";
}

- (void)sliderChanged:(UISlider *)sender {
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:@"com.majiqian.lockplayermini"];
    [ud setFloat:sender.value forKey:@"fontSize"];
    [ud synchronize];
}

@end
