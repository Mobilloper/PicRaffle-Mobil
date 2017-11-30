//
//  SignupViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "SignupViewController.h"
#import "BasicViewController.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet CustomTextField *user_name_tf;
@property (weak, nonatomic) IBOutlet CustomTextField *user_email_tf;
@property (weak, nonatomic) IBOutlet CustomTextField *password_tf;
@property (weak, nonatomic) IBOutlet CustomTextField *re_password_tf;


@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"signup_stb"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }

}

- (IBAction)actionSignUpBT:(id)sender {
    NSString *username = self.user_name_tf.text;
    NSString *useremail = self.user_email_tf.text;
    NSString *userpassword = self.password_tf.text;
    NSString *userrepassword = self.re_password_tf.text;
    
    if([username isEqualToString:@""] || [useremail isEqualToString:@""] || [userpassword isEqualToString:@""] || [userrepassword isEqualToString:@""])
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
                                     message:@"Please Input All Information"
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
    
    if(![userrepassword isEqualToString:userpassword])
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
                                     message:@"Don't Matched Password. Please input password and confirm password same"
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
            finalURL = [finalURL stringByAppendingString: SIGNUP_URL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:username forKey:@"user_name"];
            [request setPostValue:userrepassword forKey:@"user_password"];
            [request setPostValue:useremail forKey:@"user_email"];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startAsynchronous];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText=@"Siging up";
            
        });
        
    });
}

- (IBAction)actionBackBT:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    //    NSDictionary *weatherDictionary=[values objectForKey:@"success"];
    //    [self parseLocalWeather:weatherDictionary];
    //[self performSegueWithIdentifier:@"login_stb" sender:nil];
    
    NSString *successcode = [values objectForKey:@"success"];
    if([successcode isEqualToString:@"0"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
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
    else if([successcode isEqualToString:@"1"]){
//        user_info = [values objectForKey:@"msg"];
        [[Global globalManager] setUserInfo:[values objectForKey:@"msg"]];
        
        BasicViewController *mainViewController = [BasicViewController new];
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
    
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
