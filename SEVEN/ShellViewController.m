//
//  ShellViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ShellViewController.h"
#import "ProfilePagedBrowserViewController.h"
#import "ProfileFastScrollViewController.h"
#import "MBProgressHUD.h"

@interface ShellViewController ()

@end

@implementation ShellViewController

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

    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"Loading users";

    [[PFUser query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        allUsers = [objects mutableCopy];

        for (PFUser *user in allUsers) {
            if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                //                [allUsers removeObject:user];
                break;
            }
            [progress hide:YES];
            [self switchToPagedProfile];
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToFastProfile) name:@"profile:full:tapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToPagedProfile) name:@"profile:fastscroll:tapped" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchToPagedProfile {
    NSLog(@"Switching to paged");
    if (!pagedProfile) {
        pagedProfile = [_storyboard instantiateViewControllerWithIdentifier:@"ProfilePagedBrowserViewController"];
        pagedProfile.delegate = self;
        pagedProfile.allUsers = allUsers;
        [self.view addSubview:pagedProfile.view];
    }
    [pagedProfile jumpToPage:currentPage animated:NO];
    [UIView animateWithDuration:.5 animations:^{
        [fastProfile.view setAlpha:0];
        [pagedProfile.view setAlpha:1];
    }];
}

-(void)switchToFastProfile {
    NSLog(@"Switching to fast");
    if (!fastProfile) {
        fastProfile = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileFastScrollViewController"];
        fastProfile.delegate = self;
        fastProfile.allUsers = allUsers;
        [self.view addSubview:fastProfile.view];
    }
    [fastProfile jumpToPage:currentPage animated:NO];
    [UIView animateWithDuration:.5 animations:^{
        [pagedProfile.view setAlpha:0];
        [fastProfile.view setAlpha:1];
    } completion:^(BOOL finished) {
    }];

}

-(void)didScrollToPage:(int)page {
    currentPage = page;
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
