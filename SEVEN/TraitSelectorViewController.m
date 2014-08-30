//
//  TraitSelectorViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/29/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "TraitSelectorViewController.h"
#import "TraitSelectorCell.h"
#import "TraitAdjustorCell.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "MBProgressHUD.h"

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
    right.tintColor = COL_LIGHTBLUE;
    self.navigationItem.rightBarButtonItem = right;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seven_icon_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft:)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    [self setupFonts];

    allTraits = [NSMutableArray array];
    allColors = [NSMutableArray array];
    allLevels = [NSMutableDictionary dictionary];
    [self randomizeTraits];
    [self randomizeColors];
    isSelected = [NSMutableArray array];
    for (int i=0; i<[allTraits count]; i++) {
        [isSelected addObject:@NO];
    }

    allSelectedTraits = [NSMutableArray array];
    allSelectedColors = [NSMutableArray array];

    mode = TraitModeSelect;
    [self enableNavigation:NO];
}

-(void)setupFonts {
    NSString *message;
    NSArray *highlights;
    if (mode == TraitModeSelect) {
        message = @"Pick seven traits to get endorsed";
        highlights = @[@"get endorsed"];
    }
    else {
        message = @"Now swipe to adjust your traits";
        highlights = @[@"traits"];
    }

    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:message];
    [titleString addAttribute:NSFontAttributeName value:FontRegular(15) range:[message rangeOfString:message]];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[message rangeOfString:message]];

    for (NSString *highlightedString in highlights) {
        [titleString addAttribute:NSForegroundColorAttributeName value:COL_LIGHTBLUE range:[message rangeOfString:highlightedString]];
        [titleString addAttribute:NSFontAttributeName value:FontMedium(16) range:[message rangeOfString:highlightedString]];
    }
    [labelMessage setAttributedText:titleString];
}

-(void)didClickRight:(id)sender {
    if (mode == TraitModeSelect) {
        [self enableNavigation:NO];
        [self saveTraitsWithCompletion:^{
            [self startAdjustingTraits];
        }];
    }
    else {
        [self saveTraitLevels];
    }
}

-(void)didClickLeft:(id)sender {
    if (mode == TraitModeSelect) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self cancelAdjustingTraits];
    }
}

-(void)enableNavigation:(BOOL)enabled {
    [self.navigationItem.rightBarButtonItem setEnabled:enabled];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)randomizeTraits {
    NSMutableArray *traitsLeft = [ALL_TRAITS mutableCopy];
    while ([traitsLeft count] > 0) {
        int index = arc4random() % [traitsLeft count];
        [allTraits addObject:traitsLeft[index]];
        [traitsLeft removeObjectAtIndex:index];
    }
}

-(void)randomizeColors {
    [allColors addObject:[self randomColorFromLastColor:nil lastTwo:nil]];
    [allColors addObject:[self randomColorFromLastColor:allColors[0] lastTwo:nil]];
    for (int i=2; i<[allTraits count]; i++) {
        UIColor *lastColor = allColors[i-1];
        UIColor *lastTwo = allColors[i-2];
        [allColors addObject:[self randomColorFromLastColor:lastColor lastTwo:lastTwo]];
    }
}

-(UIColor *)randomColorFromLastColor:(UIColor *)lastColor lastTwo:(UIColor *)lastTwo {
    static const int numColors = 10;
    int ALL_COLORS[numColors] = {0xbdd200, 0xff0e0e, 0x670063, 0x9e005d, 0x2ed0ff, 0xff6015, 0x00809c, 0x07a5cb, 0xdf0000, 0x009c8e};

    const CGFloat* lastColorComponents = CGColorGetComponents( lastColor.CGColor);

    while (1) {
        int index = arc4random() % numColors;
        UIColor *newColor = UIColorFromHex(ALL_COLORS[index]);
        const CGFloat* newColorComponents = CGColorGetComponents(   newColor.CGColor);
        if (!lastColor) {
            return newColor;
        }
        float dist = fabs(newColorComponents[0] - lastColorComponents[0]) + fabs(newColorComponents[1] != lastColorComponents[1]) + fabs(newColorComponents[2] != lastColorComponents[2]);
        //NSLog(@"distance between %@ and %@: %f", lastColor, newColor, dist);
        if (dist <= 1)
            continue;
        if (!lastTwo)
            return newColor;

        const CGFloat* lastColorComponents2 = CGColorGetComponents( lastTwo.CGColor);
        float dist2 = fabs(newColorComponents[0] - lastColorComponents2[0]) + fabs(newColorComponents[1] != lastColorComponents2[1]) + fabs(newColorComponents[2] != lastColorComponents2[2]);
        if (dist2 <= 2.2)
            continue;

        return newColor;
    }
}

-(int)traitsSelected {
    int total = 0;
    for (int i=0; i<[isSelected count]; i++) {
        if ([isSelected[i] boolValue])
            total++;
    }
    return total;
}

#pragma mark TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (mode == TraitModeSelect)
        return [allTraits count];
    else
        return [allSelectedTraits count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRAIT_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (mode == TraitModeSelect) {
        TraitSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TraitSelectorCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSInteger row = indexPath.row;
        [cell setupWithInfo:@{@"trait":allTraits[row], @"color":allColors[row], @"selected":isSelected[row]}];
        
        return cell;
    }
    else {
        TraitAdjustorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TraitAdjustorCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.canAdjust = YES;
        
        NSInteger row = indexPath.row;
        NSNumber *level = allLevels[allSelectedTraits[row]]; // may not have been created yet if needs web request
        if (!level)
            level = @0;
        [cell setupWithInfo:@{@"trait":allSelectedTraits[row], @"color":allSelectedColors[row], @"level":level}];

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (mode == TraitModeSelect) {
        NSInteger row = indexPath.row;
        BOOL isCurrentlySelected = [isSelected[row] boolValue];
        if (!isCurrentlySelected) {
            if ([self traitsSelected] >= 7)
                return;
        }
        isSelected[row] = @(!isCurrentlySelected);
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        [self enableNavigation:([self traitsSelected] > 0)];
    }
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

-(void)saveTraitsWithCompletion:(void(^)())completion {
    NSMutableArray *selectedTraits = [NSMutableArray array];
    for (int i=0; i<[isSelected count]; i++) {
        if ([isSelected[i] boolValue]) {
            [selectedTraits addObject:allTraits[i]];
            [allSelectedTraits addObject:allTraits[i]];
            [allSelectedColors addObject:allColors[i]];

            // add random levels
            allLevels[allTraits[i]] = @(arc4random()%MAX_TRAIT_LEVEL);
        }
    }
    // using selectedTraits, updates existing or creates new traits, and removes unselected traits from user relation
    PFRelation *traitsRelation = [[PFUser currentUser] relationForKey:@"traits"];
    [[traitsRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            if (![selectedTraits containsObject:object[@"trait"]]) {
                // if a trait exists that is not one of the selected ones, remove it
                [traitsRelation removeObject:object];
                [object deleteInBackground];

                // delete the trait level
                [allLevels removeObjectForKey:object[@"trait"]];
            }
            else {
                // if a trait already exists, remove it from the new traits list
                [selectedTraits removeObject:object[@"trait"]];
            }
        }

        // make all new traits into traits for the user
        for (NSString *trait in selectedTraits) {
            PFObject *traitObject = [PFObject objectWithClassName:@"Trait"];

            traitObject[@"trait"] = trait;
            traitObject[@"user"] = [PFUser currentUser];
            [traitObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [traitsRelation addObject:traitObject];
                    [[PFUser currentUser] saveInBackground];
                }
            }];
        }

        completion(); // goes to startAdjustingTraits
    }];
}

-(void)startAdjustingTraits {

    NSMutableArray *rows = [NSMutableArray array];
    for (int i=0; i<[isSelected count]; i++) {
        if ([isSelected[i] boolValue] == NO) {
            [rows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }

    // when table deletes rows, the data source must already match the number of rows existing
    mode = TraitModeAdjust;
    [tableview deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];

    [UIView animateWithDuration:.25 animations:^{
        [labelMessage setAlpha:0];
    } completion:^(BOOL finished) {
        [self setupFonts];
        [UIView animateWithDuration:.25 animations:^{
            [labelMessage setAlpha:1];
            [tableview reloadData];
            [self enableNavigation:YES];
        }];
    }];
}

-(void)cancelAdjustingTraits {
    mode = TraitModeSelect;
    [allSelectedTraits removeAllObjects];
    [allSelectedColors removeAllObjects];
    [tableview reloadData];
}

-(void)saveTraitLevels {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progress setMode:MBProgressHUDModeIndeterminate];
    [progress setLabelText:@"Saving traits"];

    NSMutableArray *processedTraits = [NSMutableArray array];

    PFRelation *traitsRelation = [[PFUser currentUser] relationForKey:@"traits"];
    [[traitsRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [progress setLabelText:@"Error updating traits"];
            progress.detailsLabelText = error.description;
            progress.mode = MBProgressHUDModeText;
            [progress hide:YES afterDelay:3];
            return;
        }

        for (PFObject *object in objects) {
            if ([allSelectedTraits containsObject:object[@"trait"]]) {
                if (!allLevels[object[@"trait"]]) {
                    // shouldn't happen - prevent crash
                    allLevels[object[@"trait"]] = @0;
                }
                object[@"level"] = allLevels[object[@"trait"]];
                [processedTraits addObject:object[@"trait"]];
                [object saveInBackground];
            }
            else {
                NSLog(@"User has a trait stored that he deselected!");
                [object deleteInBackground];
            }
        }

        if ([allSelectedTraits count] != [processedTraits count]) {
            NSLog(@"Oops, we are missing some traits");
            // should add it
        }

        [progress hide:YES];
        [self performSegueWithIdentifier:@"TraitsToLookingFor" sender:self];
    }];
}

#pragma mark TraitAdjustorDelegate
-(void)didChangeTrait:(NSString *)trait level:(int)level {
    allLevels[trait] = @(level);
}
@end
