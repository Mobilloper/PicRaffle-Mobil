//
//  ChangeVC.m
//  PicRaffle
//
//  Created by ACoding on 11/15/17.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "ChangeVC.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Global.h"

@interface ChangeVC ()

@property NSDictionary *user_info;

@end

@implementation ChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user_info = [[Global globalManager] getUserInfo];
    self.usernametextfield.text = [self.user_info objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionChangeBTN:(id)sender {
    NSString * user_id = [self.user_info objectForKey:@"userId"];
    NSString *user_name = self.usernametextfield.text;
    
    if ([user_name isEqualToString:@""]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
                                     message:@"Please Input User Name"
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
            finalURL = [finalURL stringByAppendingString: CHANGEUSERNAME_URL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:user_name forKey:@"user_name"];
            [request setPostValue:user_id forKey:@"user_id"];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startAsynchronous];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText=@"Changing User Name";
            
        });
        
    });
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
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
    NSLog(@"%@",responseString);
    
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
