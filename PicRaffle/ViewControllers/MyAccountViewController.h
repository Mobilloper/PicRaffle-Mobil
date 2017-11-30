//
//  MyAccountViewController.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-08.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"

@interface MyAccountViewController : UIViewController

@property BasicWithSideBarViewController *superViewController;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *my_profile_imageview;

@property NSMutableDictionary *user_info;

@end
