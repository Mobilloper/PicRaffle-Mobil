//
//  NavigationBar.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-29.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self customInit];
    }
    return self;
}

-(void)customInit
{
    [[NSBundle mainBundle] loadNibNamed:@"NavigationBar" owner:self options:nil];
    [self addSubview: self.view];
    [self setNotificationNumber:10];
    //self.v.frame = self.bounds;
}

-(void)setNotificationNumber:(int)badgeNum
{
    M13BadgeView *badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
    badgeView.text = [NSString stringWithFormat:@"%i", badgeNum];
    
    [self.notificationItem addSubview:badgeView];
    badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
    badgeView.verticalAlignment = M13BadgeViewVerticalAlignmentMiddle;
    
    
}

- (IBAction)actionSideBarBT:(id)sender {
    [self.superviewcontroller.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
    //[self.superviewcontroller showSideBar];
}
- (IBAction)actionNotificationBT:(id)sender {
    //[self.superviewcontroller showNotificationView];
    [self setNotificationNumber:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.superviewcontroller showNotificationView];
}

-(void)setNavigationTitle:(NSString *)title
{
    self.navigation_title.text = title;
}
@end
