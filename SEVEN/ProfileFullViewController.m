//
//  ProfileFullViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/14/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileFullViewController.h"
#import "ProfileViewController.h"

@interface ProfileFullViewController ()

@end

@implementation ProfileFullViewController

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
    [_collectionView setPagingEnabled:YES]; // full page paging
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGestures {
    // double tap to close
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tap.numberOfTapsRequired = 2;
    [_collectionView addGestureRecognizer:tap];
}

-(ProfileViewController *)profileForIndex:(NSIndexPath *)index {
    ProfileViewController *controller = [super profileForIndex:index];
    [controller setHideTable:NO];

    return controller;
}

-(float)pageWidth {
    return 320;
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

-(void)handleGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"profile:full:tapped" object:nil];
    }
}

@end
