//
//  BRCameraViewController.h
//  SEVEN
//
//  Created by Bobby Ren on 7/29/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define CAPTURE_FRAMES_PER_SECOND		20

@protocol BRCameraDelegate <NSObject>

-(void)didStartRecordingVideo;
-(void)didStopRecordingVideo;
-(void)didRecordMediaWithURL:(NSURL *)url;


@end
@interface BRCameraViewController : UIViewController <AVCaptureFileOutputRecordingDelegate>
{
	BOOL isRecording;

	AVCaptureSession *captureSession;
	AVCaptureMovieFileOutput *movieFileOutput;
	AVCaptureDeviceInput *videoInputDevice;
}

@property (nonatomic, strong) UIView *overlay;
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, weak) id delegate;

@property (nonatomic) BOOL shouldCaptureVideo;
@property (nonatomic) BOOL shouldCaptureAudio;
@property (nonatomic) BOOL shouldSaveToFile;
@property (nonatomic) BOOL shouldShowPreview;

-(void)addOverlayToFrame:(CGRect)frame;
-(BOOL)toggleCamera:(id)sender;
-(void)startRecording;
-(void)stopRecording;
@end
