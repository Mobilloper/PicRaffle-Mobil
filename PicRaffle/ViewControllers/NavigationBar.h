//
//  NavigationBar.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-29.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13BadgeView.h"
#import "UIViewController+LGSideMenuController.h"
#import "BasicWithSideBarViewController.h"

@interface NavigationBar : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *notificationItem;
@property (weak, nonatomic) IBOutlet UIImageView *sidebarItem;
@property (weak, nonatomic) IBOutlet UILabel *navigation_title;

@property BasicWithSideBarViewController *superviewcontroller;

-(void)setNotificationNumber:(int)badgeNum;
-(void)setNavigationTitle:(NSString *) title;
@end
