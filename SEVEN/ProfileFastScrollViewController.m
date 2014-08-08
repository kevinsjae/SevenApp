//
//  FastScrollViewController.m
//  SEVEN
//
//  Created by Bobby Ren on 8/8/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileFastScrollViewController.h"
#import "ProfileViewController.h"

@interface ProfileFastScrollViewController ()

@end

@implementation ProfileFastScrollViewController

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

    // load all users
    [[PFUser query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        allUsers = [objects mutableCopy];

        for (PFUser *user in allUsers) {
            if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                //                [allUsers removeObject:user];
                break;
            }
        }

        [_collectionView reloadData];
    }];
    if (!profileViewControllers)
        profileViewControllers = [NSMutableDictionary dictionary];
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(ProfileViewController *)profileForIndex:(NSIndexPath *)index {
    int ind = index.row;

    PFUser *user = allUsers[ind];
    if (!profileViewControllers[user.objectId]) {
        ProfileViewController *controller = [_storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [controller setUser:user];
        profileViewControllers[user.objectId] = controller;
        //controller.view.transform = CGAffineTransformMakeScale(.5, .5);
        [controller setHideTable:YES];
    }
    return profileViewControllers[user.objectId];
}

#pragma mark CollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [allUsers count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

//    cell.contentView.backgroundColor = [self randomColor];

    for (UIView *subview in cell.contentView.subviews)
        [subview removeFromSuperview];

    ProfileViewController *controller = [self profileForIndex:indexPath];
    controller.view.frame = CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
//    controller.view.backgroundColor = [self randomColor];
    [cell.contentView addSubview:controller.view];

    [controller.view setNeedsLayout];
    [controller.view layoutIfNeeded];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
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


@end
