//
//  MyTicketsViewController.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-08.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"

@interface MyTicketsViewController : UIViewController

@property BasicWithSideBarViewController *superViewController;
@property (weak, nonatomic) IBOutlet UILabel *ticket_count_tv;
@property NSDictionary *user_info;


@end
