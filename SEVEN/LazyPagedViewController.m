//
//  LazyPagedViewController.m
//  GymPact
//
//  Created by Bobby Ren on 7/23/14.
//  Copyright (c) 2014 Harvard University. All rights reserved.
//

#import "LazyPagedViewController.h"

@implementation LazyPagedViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    [scrollView setPagingEnabled:YES];
    [scrollView setDirectionalLockEnabled:YES];
    [scrollView setBounces:NO];
    [scrollView setScrollEnabled:YES];
}

-(void)pageLeft {
    // shift views to the left, then reset content offset to center
    [nextPage.view removeFromSuperview];
    nextPage = currentPage;
    currentPage = prevPage;
    prevPage = nil;

    [self performSelector:@selector(setupPages) withObject:nil afterDelay:LAZY_LOAD_CURRENT_DELAY];
}

-(void)pageRight {
    // shift views to the right, then reset content offset
    [prevPage.view removeFromSuperview];
    prevPage = currentPage;
    currentPage = nextPage;
    nextPage = nil;

    [self performSelector:@selector(setupPages) withObject:nil afterDelay:LAZY_LOAD_CURRENT_DELAY];
}

-(void)setupPages {
    // current week
    [self loadCurrentPage];

    // next week
    [self loadRightPage];

    // previous week
    [self loadLeftPage];
}

-(void)loadCurrentPage {
    // content for currentPage should first be setup by subclass

    // update content size and content offset if we reached end
    current_offset_x = scrollView.frame.size.width;
    int content_size_width = scrollView.frame.size.width * 3;
    if (!self.canGoLeft && !self.canGoRight) {
        current_offset_x = 0;
        content_size_width = scrollView.frame.size.width;
    }
    else if (![self canGoLeft]) {
        current_offset_x = 0;
        content_size_width = scrollView.frame.size.width * 2;
    }
    else if (![self canGoRight]) {
        content_size_width = scrollView.frame.size.width * 2;
    }

    // set frames for current week
    currentPage.view.frame = [self frameInScrollviewForPosition:ScrollPositionCurrPage];

    // force layout for subviews
    // makes sure the subviews are correctly resized, because autolayout doesn't happen until viewDidAppear triggers, and there are several layers of subviews (scrollview->workoutDetailView->bargraph)
    // this must be done after the currentPage frame is changed. but if done later, it doesn't work.
    [self forceLayoutForController:currentPage];

    [currentPage.view removeFromSuperview];
    [scrollView addSubview:currentPage.view];

    [scrollView setContentOffset:CGPointMake(current_offset_x, 0) animated:NO];
    [scrollView setContentSize:CGSizeMake(content_size_width, scrollView.frame.size.height)];
}

-(void)loadRightPage {
    nextPage.view.frame = [self frameInScrollviewForPosition:ScrollPositionNextPage];
    [self forceLayoutForController:nextPage];
    if (!nextPage.view.superview)
        [scrollView addSubview:nextPage.view];
}

-(void)loadLeftPage {
    prevPage.view.frame = [self frameInScrollviewForPosition:ScrollPositionPrevPage];
    [self forceLayoutForController:prevPage];
    if (!prevPage.view.superview)
        [scrollView addSubview:prevPage.view];
}

-(void)forceLayoutForController:(UIViewController *)page {
    for (UIView *subview in page.view.subviews) {
        [subview setNeedsLayout];
        [subview layoutIfNeeded];
    }
}

-(CGRect)frameInScrollviewForPosition:(LazyPagedScrollPosition)pos {
    int offset_x = 0;
    if (pos == ScrollPositionPrevPage)
        offset_x = 0;
    else if (pos == ScrollPositionCurrPage)
        offset_x = current_offset_x;
    else if (pos == ScrollPositionNextPage)
        offset_x = current_offset_x + scrollView.frame.size.width;

    CGRect rect = CGRectMake(offset_x, content_offset_y, scrollView.frame.size.width, scrollView.frame.size.height - content_offset_y);
    return rect;
}

#pragma mark ScrollView Delegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // only triggered by didClickButton/scrollRectToVisible
    if (goingLeft) {
        [self performSelector:@selector(pageLeft) withObject:nil afterDelay:.01]; // give a slight delay to let animation complete, otherwise there is a hiccup
    }
    else if (goingRight) {
        [self performSelector:@selector(pageRight) withObject:nil afterDelay:.01];
    }
    goingLeft = NO;
    goingRight = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // if scrollview stops. can happen if scrollview pops back, or if fling motion happens
    if (scrollView.contentOffset.x < current_offset_x + SCROLL_OFFSET_PAST_PAGE)
        [self pageLeft];
    else if (scrollView.contentOffset.x > current_offset_x + SCROLL_OFFSET_NEXT_PAGE)
        [self pageRight];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // nothing special to do
}

@end
