//
//  Constants.h
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#ifndef SEVEN_Constants_h
#define SEVEN_Constants_h

#define _appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define _storyboard _appDelegate.window.rootViewController.storyboard

#define TESTING 0
#define AIRPLANE_MODE 0

#define COL_RED [UIColor colorWithRed:225.0/255.0 green:44.0/255.0 blue:49.0/255.0 alpha:1]
#define COL_BLUE [UIColor colorWithRed:79.0/255.0 green:194.0/255.0 blue:227.0/255.0 alpha:1]
#define COL_GREEN [UIColor colorWithRed:190.0/255.0 green:208.0/255.0 blue:43.0/255.0 alpha:1]
#define COL_GRAY [UIColor colorWithRed:54.0/255.0 green:60.0/255.0 blue:70.0/255.0 alpha:1]
#define COL_BG [UIColor colorWithRed:39.0/255.0 green:51.0/255.0 blue:66.0/255.0 alpha:1]
#define COL_LIGHTBLUE [UIColor colorWithRed:0 green:125.0/255.0 blue:176.0/255.0 alpha:1]   

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FontRegular(x) [UIFont fontWithName:@"GothamHTF-Book" size:x]
#define FontMedium(x) [UIFont fontWithName:@"GothamHTF-Medium" size:x]

typedef enum {
    OTHER = 0, // trans?
    MALE,
    FEMALE,
    BOTH, // for seeking only, but could be used for bi?
} Gender;

#define METERS_PER_MILE 1609.344
#define DebugLog NSLog

#define TRAIT_HEIGHT 40
#define SMALL_PAGE_WIDTH (398.0/2.0)
#define SMALL_PAGE_RATIO (606.0/397.0)
#define MINIMUM_SPACING 1

#endif
