//
//  ProfilePagedBrowserViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfilePagedBrowserViewController.h"
#import "ProfileViewController.h"

@interface ProfilePagedBrowserViewController ()

@end

@implementation ProfilePagedBrowserViewController

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

    // load all users
    [[PFUser query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        allUsers = [objects mutableCopy];

        for (PFUser *user in allUsers) {
            if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
//                [allUsers removeObject:user];
                break;
            }
        }

        [self setupPages];
    }];

    // double tap to close
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCurrentPage {
    if (![allUsers count])
        return;

    PFUser *user = allUsers[page];
    if (!currentPage) {
        ProfileViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        currentPage = controller;
    }

    [super loadCurrentPage];
}

-(void)loadLeftPage {
    if (![self canGoLeft]) {
        return;
    }

    PFUser *user = allUsers[page-1];
    if (!prevPage) {
        ProfileViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        prevPage = controller;
    }

    [super loadLeftPage];
}

-(void)loadRightPage {
    if (![self canGoRight]) {
        return;
    }

    PFUser *user = allUsers[page+1];
    if (!nextPage) {
        ProfileViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        nextPage = controller;
    }

    [super loadRightPage];
}

-(BOOL)canGoLeft {
    return page > 0;
}

-(BOOL)canGoRight {
    return page < allUsers.count - 1;
}

-(void)pageLeft {
    page -= 1;
    [super pageLeft];
}

-(void)pageRight {
    page += 1;
    [super pageRight];
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
