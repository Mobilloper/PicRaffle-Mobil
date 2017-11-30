//
//  BasicWithSideBarViewController.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "NotificationView.h"


@interface BasicWithSideBarViewController : UIViewController

//@property DashboardView *dashboardView;
//@property NotificationView *notificationView;



@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSMutableDictionary *superViews;

-(void)hideAllViews;
-(void)showNotificationView;
-(void)showDashboardView;
-(void)removeAllViews;
-(void)showProfileView;
-(void)showAddPhotoView;
-(void)showActivityView;
-(void)showBuyTicketListView;

-(void)showUploadIcon;
-(void)enableIsSelected;



@end
