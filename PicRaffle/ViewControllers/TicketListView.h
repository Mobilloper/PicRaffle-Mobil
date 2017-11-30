//
//  TicketListView.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-02.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"

@interface TicketListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property BasicWithSideBarViewController *superViewController;

@property UIViewController *viewController;
@property NSDictionary *todaycontest;

-(void)reloadView;


@end
