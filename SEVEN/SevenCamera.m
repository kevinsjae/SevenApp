//
//  SevenCamera.m
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "SevenCamera.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation SevenCamera

-(void)startCameraFrom:(UIViewController *)presenter {
    _picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.showsCameraControls = NO;
    }
    else
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    _picker.toolbarHidden = YES; // hide toolbar of app, if there is one.
    _picker.delegate = self;
    _picker.mediaTypes = @[(NSString *)kUTTypeMovie];

    [presenter presentViewController:_picker animated:NO completion:nil];
}
-(void)addOverlayWithFrame:(CGRect)frame {
    // Initialization code

    if (_picker.sourceType != UIImagePickerControllerSourceTypeCamera)
        return;

    /*
    CALayer *top = [[CALayer alloc] init];
    top.frame = CGRectMake(0, 0, CAMERA_SIZE, CAMERA_TOP_OFFSET);
    top.backgroundColor = [[UIColor blackColor] CGColor];
    top.opacity = .25;
     */

    overlay = [[UIView alloc] initWithFrame:frame];
    //[overlay.layer addSublayer:top];

    buttonRotate = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRotate setFrame:CGRectMake(0, 0, 40, 40)];
    [buttonRotate setBackgroundColor:[UIColor clearColor]];
    [buttonRotate setCenter:CGPointMake(280, 40)];
    [buttonRotate setImage:[UIImage imageNamed:@"rotateCamera"] forState:UIControlStateNormal];
    [buttonRotate addTarget:self action:@selector(rotateCamera) forControlEvents:UIControlEventTouchUpInside];

    [overlay addSubview:buttonCamera];
    [overlay addSubview:buttonCancel];
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [overlay addSubview:buttonRotate];
    }

    [_picker setCameraOverlayView:overlay];

    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    press.minimumPressDuration = 0.0;
    [_picker.cameraOverlayView addGestureRecognizer:press];
}

-(void)handleGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            // start recording
            NSLog(@"Start");
        }
        else if (gesture.state == UIGestureRecognizerStateEnded) {
            // stop recording
            NSLog(@"Stop");
        }
    }
}

@end
