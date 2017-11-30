//
//  LoginViewController.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-27.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Global.h"


@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet CustomTextField *tf_user;
@property (weak, nonatomic) IBOutlet CustomTextField *tf_password;


-(void) returnedResponse:(ASIHTTPRequest *)request;
-(void) failedResponse:(ASIHTTPRequest *)request;
@end
