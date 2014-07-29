//
//  BRCameraViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/29/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//
// http://www.ios-developer.net/iphone-ipad-programmer/development/camera/record-video-with-avcapturesession-2

#import "BRCameraViewController.h"

@interface BRCameraViewController ()

@end

@implementation BRCameraViewController

@synthesize previewLayer;
@synthesize overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // default settings
        self.shouldCaptureVideo = YES;
        self.shouldCaptureAudio = NO;
        self.shouldShowPreview = YES;
        self.shouldSaveToFile = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // create the captureSession
	captureSession = [[AVCaptureSession alloc] init];

    // create and connect inputs
    if (self.shouldCaptureVideo) {
        [self setupVideoInput];
    }

    if (self.shouldCaptureAudio) {
        [self setupAudioInput];
    }

    // create and connect outputs
    if (self.shouldShowPreview) {
        [self setupPreviewOutput];
    }

    if (self.shouldSaveToFile) {
        [self setupMovieOutput];
    }

    // start video stream
	[captureSession startRunning];
}

#pragma mark inputs
-(void)setupVideoInput {
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (!error) {
        if ([captureSession canAddInput:videoInputDevice])
            [captureSession addInput:videoInputDevice];
        else
            NSLog(@"Couldn't add video input");
    }
    else {
        NSLog(@"Couldn't create video input");
    }
}

-(void)setupAudioInput {
    // audio
	AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	NSError *error = nil;
	AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
	if (audioInput)
	{
		[captureSession addInput:audioInput];
	}
}

#pragma mark outputs
-(void)setupPreviewOutput {
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];

	[self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	[self.previewLayer setFrame:self.view.frame];

	[self.view.layer insertSublayer:previewLayer atIndex:0];
}

-(void)setupMovieOutput {
    NSLog(@"Adding movie file output");
	movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];

	Float64 TotalSeconds = 60;			//Total seconds
	int32_t preferredTimeScale = 30;	//Frames per second
	CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
	movieFileOutput.maxRecordedDuration = maxDuration;
	movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;						//<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME

	if ([captureSession canAddOutput:movieFileOutput])
		[captureSession addOutput:movieFileOutput];

	//SET THE CONNECTION PROPERTIES (output properties)
	[self cameraSetOutputProperties];

	//----- SET THE IMAGE QUALITY / RESOLUTION -----
	//Options:
	//	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
	//	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
	//	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
	//	AVCaptureSessionPreset640x480 - 640x480 VGA (check its supported before setting it)
	//	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
	//	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
	NSLog(@"Setting image quality");
	[captureSession setSessionPreset:AVCaptureSessionPresetMedium];
	if ([captureSession canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
		[captureSession setSessionPreset:AVCaptureSessionPreset640x480];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIDeviceOrientationLandscapeLeft);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	isRecording = NO;
}

#pragma mark Camera output properties
- (void) cameraSetOutputProperties {
	AVCaptureConnection *captureConnection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
	//Set landscape (if required)
	if ([captureConnection isVideoOrientationSupported]) {
		AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;		//<<<<<SET VIDEO ORIENTATION IF LANDSCAPE
		[captureConnection setVideoOrientation:orientation];
	}

	//Set frame rate (if requried)
    NSError *error;
    [videoInputDevice.device lockForConfiguration:&error];
    [videoInputDevice.device setActiveVideoMinFrameDuration:CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND)];
    [videoInputDevice.device setActiveVideoMaxFrameDuration:CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND)];
    [videoInputDevice.device unlockForConfiguration];
}

#pragma mark overlay
-(void)addOverlayToFrame:(CGRect)frame {
    // Initialization code
    // warning: if there is a navigation controller and it is invisible, certain overlay controls may be clipped and not touchable
    overlay = [[UIView alloc] initWithFrame:frame];
    overlay.backgroundColor = [UIColor clearColor];

    UIButton *buttonRotate = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRotate setFrame:CGRectMake(0, 0, 40, 40)];
    [buttonRotate setBackgroundColor:[UIColor clearColor]];
    [buttonRotate setCenter:CGPointMake(280, 40)];
    [buttonRotate setImage:[UIImage imageNamed:@"rotateCamera"] forState:UIControlStateNormal];
    [buttonRotate addTarget:self action:@selector(toggleCamera:) forControlEvents:UIControlEventTouchUpInside];

    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [overlay addSubview:buttonRotate];
    }

    [self.view addSubview:overlay];
}

#pragma mark camera controls
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position {
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices)
	{
		if ([device position] == position)
		{
			return device;
		}
	}
	return nil;
}

- (BOOL)toggleCamera:(id)sender {
	if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
	{
		NSLog(@"Toggle camera");
		NSError *error;
		AVCaptureDeviceInput *newVideoInput = nil;
		AVCaptureDevicePosition position = [[videoInputDevice device] position];
		if (position == AVCaptureDevicePositionBack)
		{
			newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&error];
		}
		else if (position == AVCaptureDevicePositionFront)
		{
			newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack] error:&error];
		}

		if (newVideoInput)
		{
			[captureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
			[captureSession removeInput:videoInputDevice];
			if ([captureSession canAddInput:newVideoInput])
			{
				[captureSession addInput:newVideoInput];
				videoInputDevice = newVideoInput;
			}
			else
			{
				[captureSession addInput:videoInputDevice];
			}

			//Set the connection properties again
			[self cameraSetOutputProperties];

			[captureSession commitConfiguration];
            return YES;
		}
        return NO;
	}
    return NO;
}

#pragma mark Recording
- (void)startRecording {
    if (!movieFileOutput)
        return;

	if (!isRecording)
	{
		isRecording = YES;

		//Create temporary URL to record to
		NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), [NSString stringWithFormat:@"%@.mov", [NSDate date]]];
		NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:outputPath])
		{
			NSError *error;
			if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
			{
				//Error - handle if requried
			}
		}
		//Start recording
		[movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
	}
}

-(void)stopRecording {
    if (!movieFileOutput)
        return;

    if (progressTimer) {
        [progressTimer invalidate];
        progressTimer = nil;
    }

    if (isRecording) {
		isRecording = NO;
		[movieFileOutput stopRecording];

        [self.delegate didStopRecordingVideo];
	}
}

-(void)tick {
    float duration = CMTimeGetSeconds(movieFileOutput.recordedDuration);
    NSLog(@"Recorded duration %f", duration);
}

#pragma mark Camera Delegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:.005 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self.delegate didStartRecordingVideo];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if ([error code] != noErr) {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value) {
            NSLog(@"Error");
        }
    }
    else {
        // save to library
        [self.delegate didRecordMediaWithURL:outputFileURL];
        /*
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
		{
			[library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
										completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {

                 }
             }];
		}
         */
	}
}

- (void)dealloc {
	captureSession = nil;
	movieFileOutput = nil;
	videoInputDevice = nil;
}

@end
