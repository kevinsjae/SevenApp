//
//  SevenCamera.h
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "GPCamera.h"

@interface SevenCamera : GPCamera

-(UIView *)overlayView;
-(void)addProgressIndicator:(UIView *)progressIndicator;
-(void)startRecordingVideo;
-(void)stopRecordingVideo;

@end
