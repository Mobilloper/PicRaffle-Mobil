//
//  WithdrawVC.m
//  PicRaffle
//
//  Created by ACoding on 11/15/17.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "WithdrawVC.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface WithdrawVC ()

@end

@implementation WithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.balanceLabel.text = [NSString stringWithFormat:@"$%ld",(long)[Global globalManager].balance ];
    self.cur_email = [[Global globalManager].user_info objectForKey:@"paypal_email"];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userinfochanged:) name:@"userinfochanged" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userinfochanged:) name:@"balancechanged" object:nil];
}

- (void) userinfochanged:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"userinfochanged"])
    {
        self.cur_email = [[Global globalManager].user_info objectForKey:@"paypal_email"];
    }
    if ([[notification name] isEqualToString:@"balancechanged"])
    {
        self.balanceLabel.text = [NSString stringWithFormat:@"$%ld",(long)[Global globalManager].balance ];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.cur_email isEqualToString:@""])
    {
        [self addEmailAlert];
    }
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
- (IBAction)changePaypalEmail:(id)sender {
    
    [self changEmailAlert];
}

-(void)changEmailAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change your paypal e-mail" message:self.cur_email preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"paypal@example.com";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSArray * textfields = alertController.textFields;
        UITextField *emailTextField = textfields[0];
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if([emailTest evaluateWithObject:emailTextField.text])
        {
            [self changEmailRequest:emailTextField.text];
        }
        else{
            [self changEmailAlert];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)addEmailAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add your paypal e-mail" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"paypal@example.com";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSArray * textfields = alertController.textFields;
        UITextField *emailTextField = textfields[0];
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if([emailTest evaluateWithObject:emailTextField.text])
        {
            [self changEmailRequest:emailTextField.text];
        }
        else{
            [self addEmailAlert];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)changEmailRequest: (NSString*)email
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: CHANGEPAYPALEMAIL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
           
            [request setPostValue:[[Global globalManager].user_info objectForKey:@"userId"] forKey:@"user_id"];
            [request setPostValue:email forKey:@"email"];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startAsynchronous];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
        });
        
    });
}

-(void)returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    NSString *successcode = [values objectForKey:@"success"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([successcode isEqualToString:@"0"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Email Faild" message:@"Please retry to change paypal email later" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Retry Just Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if([successcode isEqualToString:@"1"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Changed Email Successfully" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [[Global globalManager]reloadAllData];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)actionWithdraw:(id)sender {
   if([Global globalManager].balance == 0)
   {
       return;
   }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: WITHDRAWURL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            [request setPostValue:[[Global globalManager].user_info objectForKey:@"userId"] forKey:@"user_id"];
            [request setDidFinishSelector:@selector(returnedWithdrawResponse:)];
            [request setDidFailSelector:@selector(failedWithdrawResponse:)];
            [request setDelegate:self];
            [request startAsynchronous];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
    });
}

-(void)returnedWithdrawResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    NSString *successcode = [values objectForKey:@"success"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([successcode isEqualToString:@"1"])
    {
        [[Global globalManager]loadBalance];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Info" message:[values objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) failedWithdrawResponse:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
