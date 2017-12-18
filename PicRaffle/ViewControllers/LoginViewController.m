//
//  LoginViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-27.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "LoginViewController.h"
#import "BasicViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController ()<MFMailComposeViewControllerDelegate, CLLocationManagerDelegate>

@property CLLocationManager *locationManager;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    [self getLocation];
    
    [self checkSavedLoginInfo];
}

-(void)viewDidAppear:(BOOL)animated{
    [self getLocation];
}

-(void)getLocation{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.locationManager.location.coordinate.latitude;
    coordinate.longitude = self.locationManager.location.coordinate.longitude;
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        [Global globalManager].locationCity = placemark.locality;
        [Global globalManager].locationCountry = placemark.country;
        [self.locationManager stopUpdatingLocation];
    }];
}

-(void) checkSavedLoginInfo {
    [[Global globalManager]loadUserLoginInfo];
    if(![[Global globalManager].userName isEqualToString:@""] && ![[Global globalManager].userPassword isEqualToString:@""])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
        finalURL = [finalURL stringByAppendingString: LOGIN_URL];
        NSURL *url = [NSURL URLWithString:finalURL];
        
        self.tf_user.text = [Global globalManager].userName;
        self.tf_password.text = [Global globalManager].userPassword;
        
        // comment
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[Global globalManager].userName forKey:@"user_name_email"];
        [request setPostValue:[Global globalManager].userPassword forKey:@"password"];
        [request setDidFinishSelector:@selector(returnedResponselogin:)];
        [request setDidFailSelector:@selector(failedResponse:)];
        [request setDelegate:self];
        [request startAsynchronous];
        
        
    }
}

-(void) returnedResponselogin:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    NSString *successcode = [values objectForKey:@"success"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if([successcode isEqualToString:@"0"])
    {
    }
    else if([successcode isEqualToString:@"1"]){
        
        [[Global globalManager] setUserInfo:[values objectForKey:@"msg"]];
        [[Global globalManager] loadTodayTicktets];
        [[Global globalManager] loadMyTickets];
        [[Global globalManager] loadPastWinners];
        [[Global globalManager] loadTodayContestInfo];
        [[Global globalManager] loadUserLoginInfo];
        [[Global globalManager] loadBalance];
        
        BasicViewController *mainViewController = [BasicViewController new];
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom func
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
   // [self performSegueWithIdentifier:@"login_stb" sender:nil];
}

#pragma mark - demo
- (void)demo{
    self.tf_user.text = @"Test";
    self.tf_password.text = @"test";
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"login_stb"])
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
    }

}


- (IBAction)actionForgotPassowrd:(id)sender {
   // MailCom
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Forget Password"];
        [mail setMessageBody:@"" isHTML:NO];
        [mail setToRecipients:@[@"info@cciapps.com"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
    }

    
}
- (IBAction)actionLoginBTN:(id)sender {
    NSString *st_user = self.tf_user.text;
    NSString *st_password = self.tf_password.text;
    
    if ([st_user isEqualToString:@""] || [st_password isEqualToString:@""]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
                                     message:@"Please Input All Data!"
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: LOGIN_URL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:st_user forKey:@"user_name_email"];
            [request setPostValue:st_password forKey:@"password"];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startAsynchronous];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
        });
        
    });
      
}

#pragma mark Message

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    NSString *successcode = [values objectForKey:@"success"];
    if([successcode isEqualToString:@"0"])
    {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[Global globalManager] setUserInfo:[values objectForKey:@"msg"]];
        [[Global globalManager] loadTodayTicktets];
        [[Global globalManager] loadMyTickets];
        [[Global globalManager] loadPastWinners];
        [[Global globalManager] loadTodayContestInfo];
        [[Global globalManager] loadBalance];
        
        [Global globalManager].userName = self.tf_user.text;
        [Global globalManager].userPassword = self.tf_password.text;
        [[Global globalManager] saveUserLoginInfo];
        [[Global globalManager] loadUserLoginInfo];
        
        BasicViewController *mainViewController = [BasicViewController new];
        [self presentViewController:mainViewController animated:YES completion:nil];
        
    }
    
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
