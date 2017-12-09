//
//  ChangeEmailViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-11-18.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "ChangeEmailViewController.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface ChangeEmailViewController ()

@property NSDictionary *user_info;

@end

@implementation ChangeEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user_info = [[Global globalManager] getUserInfo];
    self.currentemail.text = [self.user_info objectForKey:@"email"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)actionBackBTN:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionChangeBTN:(id)sender {
    NSString * user_id = [self.user_info objectForKey:@"userId"];
    NSString *user_email = self.newemail.text;
    
    if ([user_email isEqualToString:@""]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
                                     message:@"Please Input User Email"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        //Add your buttons to alert controller
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: CHANGEEMAIL_URL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:user_email forKey:@"user_email"];
            [request setPostValue:user_id forKey:@"user_id"];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startAsynchronous];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText=@"Changing User Email";
            
        });
        
    });
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:[values objectForKey:@"msg"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Warning!"
                                 message:@"NetWork occurs error"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
