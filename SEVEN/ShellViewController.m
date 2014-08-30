//
//  ShellViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ShellViewController.h"
#import "ProfileScrollViewController.h"
#import "MBProgressHUD.h"
#import "FacebookHelper.h"
#import "ProfileViewController.h"
#import "UIActionSheet+MKBlockAdditions.h"

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, 320, 59)];
    view.backgroundColor = UIColorFromHex(0x2b333f);
    [self.navigationController.navigationBar insertSubview:view atIndex:0];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; // this forces navigation controller to use light content bar

    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"Loading users";

    [labelName setFont:FontMedium(18)];
    [self didScrollToPage:currentPage];

#if AIRPLANE_MODE
    allUsers = [@[[PFUser currentUser]] mutableCopy];
    for (int i=0; i<5; i++) {
        PFUser *testUser =[PFUser user];
        testUser.objectId = [NSString stringWithFormat:@"%d", i];
        [allUsers addObject:testUser];
    }
    [self.miniProfile setIsMini:NO];
    [self.miniProfile refresh];
#else
    [[PFUser query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        allUsers = [objects mutableCopy];
        if (error) {
            progress.labelText = @"Failed to load users!";
            progress.detailsLabelText = @"Please restart the app and try again";
            [progress hide:YES afterDelay:3];
        }
        else {
            for (PFUser *user in allUsers) {
                if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                    //                [allUsers removeObject:user];
                }
            }
            [progress hide:YES];
            [self switchToFullProfile];
        }
    }];
#endif
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seven_icon_logo_white"]];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    [titleView setFrame:CGRectMake(0, 0, 90, 20)];
    self.navigationItem.titleView = titleView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToMiniProfile) name:@"profile:full:tapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToFullProfile) name:@"profile:mini:tapped" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(ProfileScrollViewController *)miniProfile {
    if (!miniProfile) {
        miniProfile = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileScrollViewController"];
        miniProfile.delegate = self;
        miniProfile.allUsers = allUsers;
        [self.view addSubview:miniProfile.view];
    }
    return miniProfile;
}
-(void)switchToFullProfile {
    NSLog(@"Switching to full");
    float scaleX = self.view.frame.size.width / self.miniProfile.pageSize.width;
    float scaleY = self.view.frame.size.height / self.miniProfile.pageSize.height;

    [UIView animateWithDuration:.5 animations:^{
        miniProfile.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.miniProfile.heightOffset), scaleX, scaleY);
    } completion:^(BOOL finished) {
        [miniProfile setIsMini:NO];
        [miniProfile refresh];
        miniProfile.view.transform = CGAffineTransformIdentity;
    }];
}

-(void)switchToMiniProfile {
    NSLog(@"Switching to fast");
    [miniProfile setIsMini:YES];
    float scaleX = self.miniProfile.pageSize.width / self.view.frame.size.width;
    float scaleY = self.miniProfile.pageSize.height / self.view.frame.size.height;

    [UIView animateWithDuration:.5 animations:^{
        miniProfile.view.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(scaleX, scaleY), 0, -self.miniProfile.heightOffset);
    } completion:^(BOOL finished) {
        [miniProfile refresh];
        miniProfile.view.transform = CGAffineTransformIdentity;
        [self didScrollToPage:currentPage];
    }];
}

-(void)didScrollToPage:(int)page {
    currentPage = page;
    PFUser *user = allUsers[page];
    [labelName setText:[user[@"firstName"] uppercaseString]];
}

-(void)logout {
    NSLog(@"Log out");
    [PFUser logOut];
    [FacebookHelper logout];

    [_appDelegate goToIntro];
}

#pragma mark Navigation items
-(IBAction)didClickMenu:(id)sender {
    [UIActionSheet actionSheetWithTitle:nil message:nil buttons:@[@"Logout"] showInView:self.view onDismiss:^(int buttonIndex) {
        if (buttonIndex == 0) {
            [self logout];
        }
    } onCancel:^{
        // do nothing, can't have a nil block
    }];
}

-(IBAction)didClickMessage:(id)sender {
    NSLog(@"Message");

    // temporary
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Send a message?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
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
