//
//  LeftSidBarViewController.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"
#import "BasicViewController.h"

@interface LeftSidBarViewController : UIViewController

@property BasicWithSideBarViewController * superViewController;
@property BasicViewController *baseViewController;



@property (weak, nonatomic) IBOutlet UIImageView *iv_profile;
@property (weak, nonatomic) IBOutlet UILabel *user_name_tv;

@end
