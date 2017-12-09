//
//  AppDelegate.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-27.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import <UserNotifications/UserNotifications.h>
#import "NotificationView.h"
#import "DashboardView.h"
#import "ActivityView.h"
#import "TicketListView.h"
#import "NavigationBar.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NotificationView *notificationView;
@property DashboardView *dashboardView;
@property ActivityView *activityView;
@property TicketListView *ticketListView;
@property NavigationBar *navigationBar;
@end
