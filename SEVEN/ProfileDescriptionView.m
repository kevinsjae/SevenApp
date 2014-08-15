//
//  ProfileDescriptionView.m
//  SEVEN
//
//  Created by Bobby Ren on 8/15/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ProfileDescriptionView.h" 

@implementation ProfileDescriptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupFonts];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];

        //Just in case the size is different (you may or may not want this)
        mainView.frame = self.bounds;

        [self addSubview:mainView];
    }
    return self;
}

-(void)setupFonts {
    [self.labelName setFont:FontMedium(20)];
    [self.labelGender setFont:FontRegular(14)];
    [self.labelAge setFont:FontRegular(14)];

    [self.labelDescription setFont:FontMedium(14)];

    [self.labelLookingForTitle setFont:FontRegular(15)];
    [self.labelLookingForDetails setFont:FontMedium(14)];
}

-(void)setupWithUser:(PFUser *)_user {
    self.user = _user;
    [self.labelName setText:self.user[@"name"]];
    if (self.user[@"gender"]) {
        if ([self.user[@"gender"] isEqualToString:@"male"])
            [self.labelGender setText:@"M"];
        else if ([self.user[@"gender"] isEqualToString:@"female"])
            [self.labelGender setText:@"F"];
        // if gender is custom, facebook does not send it
    }
    if (self.user[@"age"])
        [self.labelAge setText:self.user[@"age"]];
    if (self.user[@"description"])
        [self.labelDescription setText:self.user[@"description"]];

    Gender gender = [self.user[@"lookingFor"] intValue];
    NSString *genderString;
    if (gender == MALE) {
        genderString = @"Guys";
    }
    else if (gender == FEMALE) {
        genderString = @"Girls";
    }
    else if (gender == BOTH) {
        genderString = @"Both";
    }
    [self.labelLookingForDetails setText:genderString];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)didClickExpand:(id)sender {
    [self.delegate didClickExpand];
}
@end
