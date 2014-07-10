//
//  SignupLocationViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SignupLocationViewController.h"

@interface SignupLocationViewController ()

@end

@implementation SignupLocationViewController

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
    self.mapView.showsUserLocation = YES;
    isFirstUpdate = YES;

    [self.pin setHidden:YES];

    // allow detection of whether user dragged map
    UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
    [panRec setDelegate:self];
    [self.mapView addGestureRecognizer:panRec];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickButton:(id)sender {
    if ((UIButton *)sender == self.buttonNo) {

    }
    else if ((UIButton *)sender == self.buttonYes) {
        // todo: set location object. can this be saved to parse as is?
        [self performSegueWithIdentifier:@"SignupGoToPhone" sender:self];
    }
}

#pragma mark Drag gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"drag started");
        [self.pin setHidden:NO];
        [self.mapView setShowsUserLocation:NO];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self updateLocation];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // do a reverse geolocator to find city, state
    }
}

#pragma mark MapKitDelegate
-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (isFirstUpdate && self.mapView.userLocation && self.mapView.userLocation.coordinate .latitude > -90.0 && self.mapView.userLocation.coordinate.latitude < 90.0 &&self.mapView.userLocation.coordinate.longitude >-180.0 && self.mapView.userLocation.coordinate.longitude < 180.0 && (self.mapView.userLocation.coordinate.latitude != 0 && self.mapView.userLocation.coordinate.longitude != 0)) {

        // center on user
        [self.mapView setCenterCoordinate:mapView.userLocation.coordinate animated:YES];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1*METERS_PER_MILE, 1*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];

        isFirstUpdate = NO;

        [self updateLocation];
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateLocation];
}

-(void)updateLocation {
    centerLocation = [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width/2, self.mapView.frame.size.height/2) toCoordinateFromView:self.mapView];

    self.labelCurrentLocation.text = [NSString stringWithFormat:@"%f, %f", centerLocation.latitude, centerLocation.longitude];
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
