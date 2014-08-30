//
//  ProfileVideoPreviewViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//
// merging: http://www.raywenderlich.com/13418/how-to-play-record-edit-videos-in-ios

#import "ProfileVideoPreviewViewController.h"
#import "MBProgressHUD.h"
#import "BackgroundHelper.h"

@interface ProfileVideoPreviewViewController ()

@end

@implementation ProfileVideoPreviewViewController

@synthesize firstAsset, secondAsset;

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

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seven_icon_confirm_white"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickRight:)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seven_icon_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft:)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)setupMedia:(NSArray *)mediaURLs {
    self.mediaURLs = mediaURLs;
    if ([self.mediaURLs count] > 1) {
        self.firstAsset = [AVAsset assetWithURL:self.mediaURLs[0]];
        self.secondAsset = [AVAsset assetWithURL:self.mediaURLs[1]];
        [self MergeAndSave:self];
    }
    else {
        // setup media player
        profileVideoURL = self.mediaURLs[0];
        [self playCurrentMedia];
    }
}

-(void)didClickRight:(id)sender {
    NSLog(@"Save profile video");
    [BackgroundHelper keepTaskInBackgroundForPhotoUpload];
    [self saveVideoWithCompletion:^(BOOL success) {
        [BackgroundHelper stopTaskInBackgroundForPhotoUpload];
        if (success) {
            NSLog(@"Upload complete. Can stop backgrounding now");
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];

        }
    }];
}

-(void)didClickLeft:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)playCurrentMedia {
    AVURLAsset *asset = [AVURLAsset assetWithURL:profileVideoURL];
    float duration = CMTimeGetSeconds(asset.duration);
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    player = [[AVPlayer alloc] initWithPlayerItem:item];

    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:layer];
    [player play];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
}

-(void)playerDidReachEnd:(NSNotification *)n {
    [player seekToTime:kCMTimeZero];
    [player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MergeAndSave:(id)sender{
    CMTime firstTime = firstAsset.duration;
    CMTime secondTime = secondAsset.duration;
    NSLog(@"Video lengths %f %f", CMTimeGetSeconds(firstTime), CMTimeGetSeconds(secondTime));

    if(firstAsset !=nil && secondAsset!=nil){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];

        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];

        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];

        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration));

        CGSize videoSize = firstTrack.naturalSize;
        CGSize renderSize = self.view.frame.size;

        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {FirstAssetOrientation_ =  UIImageOrientationUp;}
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
        CGFloat FirstAssetScaleToFitRatio = renderSize.width/videoSize.width;
        if(isFirstAssetPortrait_){
            if (renderSize.height > 480)
                FirstAssetScaleToFitRatio = renderSize.height/videoSize.width;
            else
                FirstAssetScaleToFitRatio = renderSize.width/videoSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }else{
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];

        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        AVAssetTrack *SecondAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation SecondAssetOrientation_  = UIImageOrientationUp;
        BOOL  isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {SecondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {SecondAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {SecondAssetOrientation_ =  UIImageOrientationUp;}
        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {SecondAssetOrientation_ = UIImageOrientationDown;}
        CGFloat SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.width;
        if(isSecondAssetPortrait_){
            if (renderSize.height > 480)
                SecondAssetScaleToFitRatio = renderSize.height/videoSize.width;
            else
                SecondAssetScaleToFitRatio = renderSize.width/videoSize.height;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:kCMTimeZero];
        }else{
            ;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:firstAsset.duration];
        }


        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];;

        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = self.view.frame.size;//CGSizeMake(320.0, 480.0);

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];

        NSURL *url = [NSURL fileURLWithPath:myPathDocs];

        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"progress: %f", exporter.progress);
                 [self exportDidFinish:exporter];
             });
         }];
    }
}
- (void)exportDidFinish:(AVAssetExportSession*)session
{
    if(session.status == AVAssetExportSessionStatusCompleted){
        profileVideoURL = session.outputURL;
        [self playCurrentMedia];
    }

    firstAsset = nil;
    secondAsset = nil;
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

- (UIImage*)firstFrame {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:profileVideoURL options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    NSLog(@"err==%@, imageRef==%@", err, imgRef);

    return [[UIImage alloc] initWithCGImage:imgRef];
}

-(void)saveVideoWithCompletion:(void(^)(BOOL success))competion {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    
#if 0
    // save to disk
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:profileVideoURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:profileVideoURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                        });
                                    }];
    }
#else

    // save first frame to parse
    UIImage *image = [self firstFrame];
    NSData *imageData = UIImageJPEGRepresentation(image, kCGInterpolationDefault);
    PFFile *frameFile = [PFFile fileWithData:imageData];

    // save video to parse
    NSData *data = [NSData dataWithContentsOfURL:profileVideoURL];
    int length = data.length;
    NSString *name = [NSString stringWithFormat:@"profileVideo%@.mp4", [PFUser currentUser].objectId];
    PFFile *file = [PFFile fileWithName:name data:data];
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.labelText = @"Saving video";

    __block BOOL needsTransition = YES;

    // create PFFile - a chunk of data
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *videoObject;
            PFUser *currentUser = [PFUser currentUser];
            if (currentUser[@"profileVideo"]) {
                videoObject = currentUser[@"profileVideo"];
            }
            else {
                videoObject = [PFObject objectWithClassName:@"ProfileVideo"];
            }
            videoObject[@"video"] = file;
            [frameFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                videoObject[@"thumb"] = frameFile;
                [videoObject saveInBackground];
            }];

            // attach PFFile to a ProfileVideo object
            [videoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    progress.labelText = @"Error saving video!";
                    [progress hide:YES afterDelay:3];
                    if (competion) {
                        competion(NO);
                    }
                }else{
                    [progress hide:YES];

                    // set relationship between PFUser and ProfileVideo. use a relationship instead of putting the PFFile directly on the user option
                    [PFUser currentUser][@"profileVideo"] = videoObject;
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Done");
                            if (competion) {
                                competion(YES);
                            }
                        }
                        else {
                            NSLog(@"Error: %@", error);
                        }
                    }];
                }
            }];
        }
    } progressBlock:^(int percentDone) {
        NSLog(@"Saving video %d%%", percentDone);
        if (percentDone > 10 && needsTransition) {
            needsTransition = NO;
            [self performSegueWithIdentifier:@"PreviewToTraits" sender:self];
        }
    }];
#endif

}

@end
