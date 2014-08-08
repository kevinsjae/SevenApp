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

    [self switchToPagedProfile];

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
        [self.view addSubview:pagedProfile.view];
    }
    [UIView animateWithDuration:.5 animations:^{
        [fastProfile.view setAlpha:0];
        [pagedProfile.view setAlpha:1];
    }];
}

-(void)switchToFastProfile {
    NSLog(@"Switching to fast");
    if (!fastProfile) {
        fastProfile = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileFastScrollViewController"];
        [self.view addSubview:fastProfile.view];
    }
    [UIView animateWithDuration:.5 animations:^{
        [pagedProfile.view setAlpha:0];
        [fastProfile.view setAlpha:1];
    }];
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
