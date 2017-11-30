//
//  MyAccountViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-08.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "MyAccountViewController.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface MyAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user_info = [[Global globalManager] getUserInfo];
    NSString *finalURL = [NSString stringWithFormat:ACCOUNT_IMAGE_FOLDER];
    
    if([self.user_info objectForKey:@"account_image_name"])
    {
        NSString *temp =[self.user_info objectForKey:@"account_image_name"];
        if(temp == (NSString*)[NSNull null])
        {
            finalURL = [finalURL stringByAppendingString: @"no_image.png"];
        }
        else{
            finalURL = [finalURL stringByAppendingString: [self.user_info objectForKey:@"account_image_name"]];
        }
        
    }else{
        
        finalURL = [finalURL stringByAppendingString: @"no_image.png"];
    }
    NSURL *url = [NSURL URLWithString:finalURL];
    
    NSData *image_data = [NSData dataWithContentsOfURL:url];
    //    self.iv_profile.image
    
    self.my_profile_imageview.image = [UIImage imageWithData:image_data];
    
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
   // [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myaccount cell"];

    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"Change user name";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row == 1)
    {
        cell.textLabel.text = @"Change email";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row == 2)
    {
        cell.textLabel.text = @"Change password";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row == 3)
    {
        cell.textLabel.text = @"Withdraw money";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.row == 4)
    {
        cell.textLabel.text = @"Delete Account";
        cell.textLabel.textColor = UIColor.redColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"changeusername" sender:nil];
    }
    if(indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"changeemail" sender:nil];
    }
    if(indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"changepassword" sender:nil];
    }
    if(indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"withdraw" sender:nil];
    }
    if(indexPath.row == 4)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
                                     message:@"Do you want to delete user really?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
                                               finalURL = [finalURL stringByAppendingString: DELETEUSER_URL];
                                               NSURL *url = [NSURL URLWithString:finalURL];

                                               // comment
                                               ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                                               NSString * user_id = [self.user_info objectForKey:@"userId"];
                                               [request setPostValue:user_id forKey:@"user_id"];
                                               [request setDidFinishSelector:@selector(returnedResponse:)];
                                               [request setDidFailSelector:@selector(failedResponse:)];
                                               [request setDelegate:self];
                                               [request startAsynchronous];
                                               [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText=@"Deleting User";
                                               
                                           });
                                           
                                       });
                                   }];
        UIAlertAction *noButton = [UIAlertAction
                                   actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        //Add your buttons to alert controller
        [alert addAction:okButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
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
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   [self.superViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                                   
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
