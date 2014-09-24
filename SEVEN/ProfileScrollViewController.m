//
//  FastScrollViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileScrollViewController.h"
#import "ProfileViewController.h"
#import "PagedFlowLayout.h"

@interface ProfileScrollViewController ()

@end

@implementation ProfileScrollViewController

@synthesize allUsers;

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
    self.profileViewControllers = [NSMutableDictionary dictionary];

    // load all users
    ((PagedFlowLayout *)(_collectionView.collectionViewLayout)).delegate = self;
    [_collectionView reloadData];
    [self setupGestures];
}

-(void)setupGestures {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [_collectionView addGestureRecognizer:doubleTap];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    [_collectionView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(ProfileViewController *)profileForIndex:(NSIndexPath *)index {
    PFUser *user = allUsers[index.row];
    ProfileViewController *controller = self.profileViewControllers[user.objectId];
    if (!controller) {
        controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        self.profileViewControllers[user.objectId] = controller;
    }
    NSLog(@"controller index %d user %@", index.row, user.objectId);
    return controller;
}

-(void)refresh {
    [_collectionView reloadData];
    [self jumpToPage:page animated:NO];
}

-(ProfileViewController *)currentProfile {
    return [self profileForIndex:[NSIndexPath indexPathForRow:page inSection:0]];
}

#pragma mark PagedFlowLayout delegate
-(int)spacing {
    if (self.isMini)
        return 3;
    return 0;
}
-(CGSize)pageSize {
    float width, height;
    if (self.isMini) {
        width = SMALL_PAGE_WIDTH;
        height = width*SMALL_PAGE_RATIO;
    }
    else {
        width = _appDelegate.window.bounds.size.width;
        height = _appDelegate.window.bounds.size.height;
    }
    return CGSizeMake(width, height);

}

-(CGSize)pageBounds {
    CGSize pageSize = [self pageSize];
    pageSize.width += [self spacing];
    pageSize.height = pageSize.width*SMALL_PAGE_RATIO;
    return pageSize;
}

-(int)heightOffset {
    return (_appDelegate.window.bounds.size.height - self.pageSize.height)/3;
}

#pragma mark CollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [allUsers count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

-(UICollectionViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath preload:(BOOL)preload {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    //    cell.contentView.backgroundColor = [self randomColor];
    ProfileViewController *controller = [self profileForIndex:indexPath];
    [controller.view setTag:1];

    UIView *view = [cell viewWithTag:1]; // the current profileViewController being shown on it
    UILabel *labelTag = (UILabel *)[view viewWithTag:TAG_USER_ID];
    PFUser *user = allUsers[indexPath.row];
    if (!preload) {
        controller.view.frame = CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
        if (![labelTag.text isEqualToString:user.objectId]) {
            NSLog(@"Cell had profile %@ at index %d, needs %@", labelTag.text, indexPath.row, user.objectId);
            [view removeFromSuperview];
            [cell.contentView addSubview:controller.view];
        }
        else {
            NSLog(@"Cell already has correct profile %@ at index %d", labelTag.text, indexPath.row);
        }
    }
    [controller showsContent:!self.isMini];

    [controller.view setNeedsLayout];
    [controller.view layoutIfNeeded];

    // preload other cells
    if (!preload) {
        if (indexPath.row > 0) {
            [self cellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0] preload:YES];
        }
        if (indexPath.row < [self.allUsers count]-1) {
            [self cellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0] preload:YES];
        }
    }
    return cell;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self cellAtIndexPath:indexPath preload:NO];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}

#pragma mark other scrollview
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    page = scrollView.contentOffset.x / [self pageBounds].width;
    [self.delegate didScrollToPage:page];
}

-(void)jumpToPage:(int)_page animated:(BOOL)animated {
    page = _page;
    float offsetX = page * [self pageBounds].width;
    _collectionView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark – UICollectionViewDelegateFlowLayout
// doesn't use these values if we have a custom flow layout

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize retval = CGSizeMake(280, _collectionView.frame.size.height);
    return retval;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    // specifies minimum spacing between items. could be bigger. but if our frame size is exact then the padding should be correct and the number of cells per row will be correct
    return 0;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    float top = 0;
    float bottom = 0;
    float left = 20;
    float right = 20;
    return UIEdgeInsetsMake(top, left, bottom, right);
}
*/

#pragma colors
-(UIColor *)randomColor {
    static const int numColors = 10;
    int ALL_COLORS[numColors] = {0xbdd200, 0xff0e0e, 0x670063, 0x9e005d, 0x2ed0ff, 0xff6015, 0x00809c, 0x07a5cb, 0xdf0000, 0x009c8e};

    int index = arc4random() % numColors;
    UIColor *newColor = UIColorFromHex(ALL_COLORS[index]);
    return newColor;
}

#pragma mark tap
-(void)handleGesture:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;

        if (tap.numberOfTapsRequired == 2) {
            if (!self.isMini)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"profile:full:tapped" object:nil];
        }
        else {
            if (self.isMini)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"profile:mini:tapped" object:nil];
        }
    }
}
@end
