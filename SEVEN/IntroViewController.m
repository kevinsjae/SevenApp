//
//  IntroViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/24/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//
// http://stackoverflow.com/questions/4368112/multiple-mpmovieplayercontroller-instances

#import "IntroViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FacebookHelper.h"
#import "EffectsUtils.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

static NSArray *movieList;

@interface IntroViewController ()

@end

@implementation IntroViewController

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

    movieList = @[@"SEVEN_IntroVideo_V01", @"SEVEN_IntroVideo_V02", @"SEVEN_IntroVideo_V03", @"SEVEN_IntroVideo_V01"];

    [self.scrollview setPagingEnabled:YES];
    [self.scrollview setBounces:NO];
    [self addPlayers];

    [self.pageControl setNumberOfPages:[movieList count]];
    [self.pageControl setCurrentPage:0];

    [self setupFonts];

    // if using loginView
    //self.loginView.readPermissions = @[@"public_profile"];
    self.loginView = nil;
}

-(void)setupFonts {
    [self.labelSubtitle setFont:FontRegular(16)];
}

-(void)addPlayers {
    players = [NSMutableArray array];

    for (NSString *movieTitle in movieList) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:movieTitle withExtension:@"mp4"];
        AVURLAsset *asset = [AVURLAsset assetWithURL:url];
        float duration = CMTimeGetSeconds(asset.duration);
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        layer.frame = CGRectMake(self.scrollview.frame.size.width * players.count, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height);
        [self.scrollview.layer addSublayer:layer];
        [players addObject:player];
    }

    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width * [movieList count], self.scrollview.frame.size.height)];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

-(int)currentPage {
    return (int)(self.scrollview.contentOffset.x / self.scrollview.frame.size.width);
}
-(AVPlayer *)currentPlayer {
    return players[self.currentPage];
}

-(void)playerDidReachEnd:(NSNotification *)n {
    [self.currentPlayer seekToTime:kCMTimeZero];
    [self.currentPlayer play];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.currentPlayer play];

    [super viewDidAppear:animated];
#if TESTING
    [self animateBarsWithDuration:.1]; // 3
    [EffectsUtils gradientFadeInForView:self.viewTitle duration:.1];
    [EffectsUtils gradientFadeInForView:self.labelSubtitle duration:.1];
    [self animateButtonWithDuration:.1]; //2
#else
    [self animateBarsWithDuration:3];
    [EffectsUtils gradientFadeInForView:self.viewTitle duration:4];
    [EffectsUtils gradientFadeInForView:self.labelSubtitle duration:4];
    [self animateButtonWithDuration:2];
#endif
}

#pragma mark scrollviewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.currentPlayer play];
    [self.pageControl setCurrentPage:self.currentPage];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.currentPlayer pause];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int content_x = scrollView.contentOffset.x;
    float alpha = 1;
    if (content_x > self.view.frame.size.width)
        alpha = 0;
    else {
        alpha = (self.view.frame.size.width - content_x) / self.view.frame.size.width;
    }
    self.viewTitle.alpha = alpha;
    self.labelSubtitle.alpha = alpha;
    self.viewLogo.alpha = alpha;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark animations
-(void)animateBarsWithDuration:(float)duration {
    NSLog(@"Started");

    self.constraintWidthRed.constant = 70;
    [self.viewLogo setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration/3.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.viewLogo layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.constraintWidthBlue.constant = 45;
        [self.viewLogo setNeedsUpdateConstraints];
        [UIView animateWithDuration:duration/3.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.viewLogo layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.constraintWidthGreen.constant = 60;
            [self.viewLogo setNeedsUpdateConstraints];
            [UIView animateWithDuration:duration/3.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.viewLogo layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }];
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

-(void)animateButtonWithDuration:(float)duration {
#if 1
    // animate motion
    self.constraintVerticalButton.constant = -70;
    self.constraintVerticalButton2.constant = -70;
    [self.buttonFacebook setNeedsUpdateConstraints];
    [self.buttonFacebook layoutIfNeeded];
    [self.buttonFacebook2 setNeedsUpdateConstraints];
    [self.buttonFacebook2 layoutIfNeeded];

    self.constraintVerticalButton.constant = 6;
    self.constraintVerticalButton2.constant = 6;
    [self.buttonFacebook setNeedsUpdateConstraints];
    [self.buttonFacebook2 setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration animations:^{
        [self.buttonFacebook layoutIfNeeded];
        [self.buttonFacebook2 layoutIfNeeded];
    }];

    self.buttonFacebook.alpha = 0;
    self.buttonFacebook2.alpha = 0;
    self.loginView.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        self.buttonFacebook.alpha = 1;
        self.buttonFacebook2.alpha = 1;
        self.loginView.alpha = 1;
    }];
#endif
}

#pragma mark Facebook
- (IBAction)didClickButton:(id)sender {
    [self.buttonFacebook setUserInteractionEnabled:NO];
    [self.buttonFacebook2 setUserInteractionEnabled:NO];
#if AIRPLANE_MODE
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self performSegueWithIdentifier:@"IntroToCreateProfile" sender:self];
    return;
#endif

    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.labelText = @"Connecting to Facebook...";
    progress.mode = MBProgressHUDModeIndeterminate;
    NSLog(@"Trying to log in");

    NSArray *permissions = @[@"public_profile", @"email", @"user_friends", @"user_about_me", @"user_birthday", @"user_location"];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [self.buttonFacebook setUserInteractionEnabled:YES];
            [self.buttonFacebook2 setUserInteractionEnabled:YES];
            progress.labelText = @"Facebook error";
            progress.mode = MBProgressHUDModeText;
            if (error.code == 2) {
                // this is a stupid facebook error that comes up because facebook is integrated in the phone
                progress.detailsLabelText = @"Please clear your Facebook session by going to Settings > Facebook and select Delete account.";
                [progress hide:YES afterDelay:5];
            }
            else {
                progress.detailsLabelText = [NSString stringWithFormat:@"Could not connect your Facebook profile. Error: %@", error.userInfo[@"NSLocalizedFailureReason"]];
                [progress hide:YES afterDelay:3];
            }
        }
        else {
            [progress hide:YES];
            NSLog(@"User: %@", user);
            NSLog(@"Current user: %@", [PFUser currentUser]);

            [FacebookHelper getFacebookFriends];
            [FacebookHelper getFacebookInfo];

            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            [self performSegueWithIdentifier:@"IntroToCreateProfile" sender:self];
        }
    }];
}

#pragma mark FBLoginViewDelegate { 
// these are used if FBLoginButton is used.
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    // link current user
    NSLog(@"User: %@", user);

    NSString *username = user[@"email"];
    NSString *password = user[@"id"];

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        NSLog(@"User: %@", user);
        if (error.code == 101) {
            // sign up
            PFUser *user = [PFUser user];
            user.username = username;
            user.password = password;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
    }];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;

    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];

        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";

        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");

        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }

    [UIAlertView alertViewWithTitle:alertTitle message:alertMessage];
}
@end
