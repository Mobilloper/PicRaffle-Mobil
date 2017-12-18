//
//  DescriptionViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-12-17.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "DescriptionViewController.h"
#import "Global.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MBProgressHUD.h"
@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.description_tv.text = [[[Global globalManager]getUserInfo] objectForKey:@"description"];
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

- (IBAction)actionCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)actionChangeButton:(id)sender {
    NSString *desctription = self.description_tv.text;
    if ([desctription isEqualToString:@""]) {
        return;
    }
    NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
    finalURL = [finalURL stringByAppendingString: CHANGEUSERDESCRIPTiONURL];
    NSURL *url = [NSURL URLWithString:finalURL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[[Global globalManager].getUserInfo objectForKey:@"userId"] forKey:@"user_id"];
    [request setPostValue:desctription forKey:@"description"];
    [request setDidFinishSelector:@selector(returnedResponse:)];
    [request setDidFailSelector:@selector(failedResponse:)];
    [request setDelegate:self];
    [request startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"Changging...";
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    [[Global globalManager] reloadAllData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) failedResponse:(ASIHTTPRequest *)request
{   [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Network Error!" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
