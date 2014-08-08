//
//  LazyPagedViewController.h
//  GymPact
//
//  Created by Bobby Ren on 7/23/14.
//  Copyright (c) 2014 Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCROLL_OFFSET_PAST_PAGE -50
#define SCROLL_OFFSET_NEXT_PAGE 50
#define LAZY_LOAD_CURRENT_DELAY .01 // allows scroll title to update before taking up all resources to load/render current view
#define LAZY_LOAD_DELAY 2

typedef enum {
    ScrollPositionPrevPage,
    ScrollPositionCurrPage,
    ScrollPositionNextPage
} LazyPagedScrollPosition;

@interface LazyPagedViewController : UIViewController <UIScrollViewDelegate>
{
    // scrollview
    IBOutlet UIScrollView *scrollView;
    int current_offset_x;
    int content_offset_y;
    BOOL goingLeft, goingRight;

    // content pages
    UIViewController *currentPage; // retains them
    UIViewController *prevPage;
    UIViewController *nextPage;
}

-(void)setupPages;

-(void)pageLeft;
-(void)pageRight;

-(void)loadCurrentPage;
-(void)loadLeftPage;
-(void)loadRightPage;

-(CGRect)frameInScrollviewForPosition:(LazyPagedScrollPosition)pos;

-(BOOL)canGoLeft;
-(BOOL)canGoRight;
@end
