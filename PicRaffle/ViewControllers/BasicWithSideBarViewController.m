//
//  BasicWithSideBarViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "BasicWithSideBarViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "NavigationBar.h"
#import "DashboardView.h"
#import "ProfileView.h"
#import "TabBar.h"
#import "AddPhotoView.h"
#import "ActivityView.h"
#import "BuyTicketViewController.h"
#import "TicketListView.h"

#import "MyAccountViewController.h"
#import "MyTicketsViewController.h"
#import "AppDelegate.h"

@interface BasicWithSideBarViewController ()
@property (weak, nonatomic) IBOutlet NavigationBar *navigationbar;
@property (weak, nonatomic) IBOutlet DashboardView *dashboardView;
@property (weak, nonatomic) IBOutlet ProfileView *profileView;
@property (weak, nonatomic) IBOutlet AddPhotoView *addPhotoView;
@property (weak, nonatomic) IBOutlet ActivityView *activityView;
@property (weak, nonatomic) IBOutlet TabBar *tabBar;
@property (weak, nonatomic) IBOutlet TicketListView *buyTicketListView;
@property (weak, nonatomic) IBOutlet NotificationView *notificationView;


@end

@implementation BasicWithSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationbar.superviewcontroller = self;
    self.profileView.superViewController = self;
    self.tabBar.superViewController = self;
    self.dashboardView.superViewController = self;
    self.activityView.superViewController = self;
    self.addPhotoView.superViewController = self;
    self.buyTicketListView.superViewController = self;
    self.buyTicketListView.viewController = self;
   
    [self showDashboardView];
    [self.tabBar setHomeActive];
    
    self.superViews = [NSMutableDictionary dictionary];
    [self.superViews setObject:self.tabBar forKey:@"tabbar"];
    [self.superViews setObject:self.addPhotoView forKey:@"addphotoview"];
   
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdelegate.notificationView = self.notificationView;
    appdelegate.dashboardView = self.dashboardView;
    appdelegate.activityView = self.activityView;
    appdelegate.ticketListView = self.buyTicketListView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.dashboardView loadAllDataComponets];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"buyticket"])
    {
        BuyTicketViewController *vc = [segue destinationViewController];
        vc.superViewController = self;
    }
   
}



-(void)showNotificationView
{
    [self hideAllViews];
    [self.notificationView setHidden:NO];
}

-(void)showDashboardView
{
    [self hideAllViews];
    [self.dashboardView reloadView];
    [self.dashboardView setHidden:NO];
}

-(void)showProfileView
{
    [self hideAllViews];
    [self.profileView reloadView];
    [self.profileView setHidden:NO];
}

-(void)showAddPhotoView
{
    [self hideAllViews];
    [self.addPhotoView setHidden:NO];
}

-(void)showActivityView
{
    [self hideAllViews];
    [self.activityView reloadView];
    [self.activityView setHidden:NO];
}

-(void)showBuyTicketListView
{
    [self hideAllViews];
    [self.buyTicketListView setHidden:NO];
}

-(void)hideAllViews
{
    if(self.dashboardView)
    {
        [self.dashboardView setHidden:YES];
    }
    
    if(self.notificationView)
    {
        [self.notificationView setHidden:YES];
    }
    
    if(self.profileView)
    {
        [self.profileView setHidden:YES];
    }
    if(self.addPhotoView)
    {
        [self.addPhotoView setHidden:YES];
    }
    if(self.activityView)
    {
        [self.activityView setHidden:YES];
    }
    if (self.buyTicketListView) {
        [self.buyTicketListView setHidden:YES];
    }
}

-(void)removeAllViews
{
    
    if(self.dashboardView)
    {
        [self.dashboardView removeFromSuperview];
    }
    
    if(self.notificationView)
    {
        [self.notificationView removeFromSuperview];
    }
}


-(void)showUploadIcon
{
    [self.tabBar showUploadIcon];
}

-(void)enableIsSelected
{
    [self.addPhotoView enableIsSelected];
}

-(NSMutableDictionary*)getTabBar
{
    NSMutableDictionary *temp =[NSMutableDictionary dictionary];
    [temp setObject:self.tabBar forKey:@"tabbar"];
    return temp;
}

@end
