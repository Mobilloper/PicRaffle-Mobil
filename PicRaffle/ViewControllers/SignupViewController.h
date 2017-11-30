//
//  SignupViewController.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *bt_back;

-(void) returnedResponse:(ASIHTTPRequest *)request;
-(void) failedResponse:(ASIHTTPRequest *)request;
@end
