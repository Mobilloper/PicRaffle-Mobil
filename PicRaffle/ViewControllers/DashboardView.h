//
//  DashboardView.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-30.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "BasicWithSideBarViewController.h"


@interface DashboardView : UIView <iCarouselDataSource, iCarouselDelegate>

@property BasicWithSideBarViewController *superViewController;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UILabel *ticket_user_tv;
@property (weak, nonatomic) IBOutlet UILabel *today_prize_tv;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *items;
@property NSMutableDictionary *user_info;
@property NSMutableDictionary *today_contest;


-(void)customInit;
-(void)loadAllDataComponets;

-(void)reloadView;

@end
