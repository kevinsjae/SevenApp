//
//  TraitSelectorViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/29/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "TraitSelectorViewController.h"
#import "TraitSelectorCell.h"

@interface TraitSelectorViewController ()

@end

@implementation TraitSelectorViewController

#define ALL_TRAITS @[@"WITTY", @"SPONTANEOUS", @"OUTDOORSY", @"ARTSY", @"COMPASSIONATE", @"ANIMAL LOVER", @"PLAYFUL", @"ADVENTUROUS", @"WILD", @"CHEERFUL", @"LOQUACIOUS", @"NEFARIOUS", @"LUSTFUL", @"FLATULENT", @"SWASHBUCKLING"]

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seven_icon_confirm_white"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickRight:)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seven_icon_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft:)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    [self setupFonts];
    [self randomizeTraits];
    [self randomizeColors];
}

-(void)setupFonts {
    NSString *message = @"Pick seven traits to get endorsed";
    NSArray *highlights = @[@"get endorsed"];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:message];
    [titleString addAttribute:NSFontAttributeName value:FontRegular(15) range:[message rangeOfString:message]];

    for (NSString *highlightedString in highlights) {
        [titleString addAttribute:NSForegroundColorAttributeName value:COL_LIGHTBLUE range:[message rangeOfString:highlightedString]];
        [titleString addAttribute:NSFontAttributeName value:FontMedium(16) range:[message rangeOfString:highlightedString]];
    }
    [labelMessage setAttributedText:titleString];
}

-(void)didClickRight:(id)sender {

}

-(void)didClickLeft:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)randomizeTraits {
    allTraits = [NSMutableArray array];
    NSMutableArray *traitsLeft = [ALL_TRAITS mutableCopy];
    while ([traitsLeft count] > 0) {
        int index = arc4random() % [traitsLeft count];
        [allTraits addObject:traitsLeft[index]];
        [traitsLeft removeObjectAtIndex:index];
    }
}

-(void)randomizeColors {
    allColors = [NSMutableArray array];
    [allColors addObject:[self randomColorFromLastColor:nil]];
    for (int i=1; i<[allTraits count]; i++) {
        UIColor *lastColor = allColors[i-1];
        [allColors addObject:[self randomColorFromLastColor:lastColor]];
    }
}

-(UIColor *)randomColorFromLastColor:(UIColor *)lastColor {
    static const int numColors = 10;
    int ALL_COLORS[numColors] = {0xbdd200, 0xff0e0e, 0x670063, 0x9e005d, 0x2ed0ff, 0xff6015, 0x00809c, 0x07a5cb, 0xdf0000, 0x009c8e};

    const CGFloat* lastColorComponents = CGColorGetComponents( lastColor.CGColor);

    UIColor *color = nil;
    while (!color) {
        int index = arc4random() % numColors;
        UIColor *newColor = UIColorFromHex(ALL_COLORS[index]);
        const CGFloat* newColorComponents = CGColorGetComponents(newColor.CGColor);
        if (!lastColor || newColorComponents[0] != lastColorComponents[0] || newColorComponents[1] != lastColorComponents[1] || newColorComponents[2] != lastColorComponents[2])
            color = newColor;
    }
    return color;
}

#pragma mark TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allTraits count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TraitSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TraitSelectorCell"];

    NSInteger row = indexPath.row;
    [cell setupWithInfo:@{@"trait":allTraits[row], @"color":allColors[row]}];

    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
