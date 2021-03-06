//
//  LookingForViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "LookingForViewController.h"
#import "MBProgressHUD.h"

@implementation LookingForViewController

-(void)viewDidLoad {
    [super viewDidLoad];

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
    [self updateSelection:nil];
}

-(void)setupFonts {
    NSString *message;
    NSArray *highlights;

    // message
    message = @"What are you looking for?";
    highlights = @[@"looking"];

    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:message];
    [titleString addAttribute:NSFontAttributeName value:FontRegular(15) range:[message rangeOfString:message]];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[message rangeOfString:message]];

    for (NSString *highlightedString in highlights) {
        [titleString addAttribute:NSForegroundColorAttributeName value:COL_LIGHTBLUE range:[message rangeOfString:highlightedString]];
        [titleString addAttribute:NSFontAttributeName value:FontMedium(16) range:[message rangeOfString:highlightedString]];
    }
    [labelMessage setAttributedText:titleString];

    NSArray *label = @[labelGuys, labelGirls, labelBoth];
    NSArray *lookingFor = @[@"Guys", @"Girls", @"Both"];
    for (int i=0; i<[label count]; i++) {
        message = [NSString stringWithFormat:@"Looking for %@", lookingFor[i]];
        highlights = @[@"Looking", lookingFor[i]];

        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:message];
        [titleString addAttribute:NSFontAttributeName value:FontRegular(15) range:[message rangeOfString:message]];
        [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[message rangeOfString:message]];

        for (NSString *highlightedString in highlights) {
            [titleString addAttribute:NSFontAttributeName value:FontMedium(16) range:[message rangeOfString:highlightedString]];
        }
        [label[i] setAttributedText:titleString];
    }
}

-(void)didClickLeft:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didClickRight:(id)sender {
    NSLog(@"Saving traits");
    [self saveLookingFor];
}

-(IBAction)didClickButton:(id)sender {
    [self updateSelection:sender];
}

-(void)updateSelection:(id)sender {
    for (UIImageView *icon in @[iconGirls, iconGuys, iconBoth]) {
        [icon setAlpha:.25];
    }
    for (UILabel *label in @[labelGuys, labelGirls, labelBoth]) {
        [label setAlpha:.5];
    }

    if (sender == buttonGuys) {
        NSLog(@"Guys");
        [iconGuys setAlpha:1];
        [labelGuys setAlpha:1];
        lookingForGender = MALE;
    }
    else if (sender == buttonGirls) {
        NSLog(@"Girls");
        [iconGirls setAlpha:1];
        [labelGirls setAlpha:1];
        lookingForGender = FEMALE;
    }
    else if (sender == buttonBoth) {
        NSLog(@"Both");
        [iconBoth setAlpha:1];
        [labelBoth setAlpha:1];
        lookingForGender = BOTH;
    }
    else {
        NSLog(@"none selected");
        lookingForGender = OTHER;
    }
}

-(void)saveLookingFor {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [progress setMode:MBProgressHUDModeIndeterminate];
    [progress setLabelText:@"Updating your selection"];

    [[PFUser currentUser] setObject:@(lookingForGender) forKey:@"lookingFor"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [progress setLabelText:@"Error updating selection"];
            progress.detailsLabelText = error.description;
            progress.mode = MBProgressHUDModeText;
            [progress hide:YES afterDelay:3];
            return;
        }
        /*
        progress.mode = MBProgressHUDModeText;
        progress.labelText = @"You are now ready to rock!";
        [progress hide:YES afterDelay:3];
         */
        [_appDelegate goToProfile];
    }];

}
@end
