//
//  TicketListCustomeTableViewCell.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-08.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "TicketListCustomeTableViewCell.h"

#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import <Braintree/Braintree.h>

#include "Global.h"

@interface TicketListCustomeTableViewCell() <BTDropInViewControllerDelegate>

@property (nonatomic, strong) Braintree *braintree;

@end


@implementation TicketListCustomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)activeCell
{
    self.backgroundImage.image = (UIImage*) [UIImage imageNamed:@"ticket list active background"];
    [self.buyBTN setTitleColor:[UIColor colorWithRed:164/255 green:190/255 blue:255/255 alpha:0.7] forState:UIControlStateNormal];
    [self.buyBTN setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
    [self.tf_countOfTickets setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
    
}

-(void)deactiveCell
{
    self.backgroundImage.image = (UIImage*) [UIImage imageNamed:@"ticket list background"];
    [self.buyBTN setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1] forState:UIControlStateNormal];
    [self.buyBTN setBackgroundColor:[UIColor colorWithRed:88/255 green:135/255 blue:255/255 alpha:0.7]];
    [self.tf_countOfTickets setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
}

-(void)setPriceOneTicket:(NSString*)price{
    self.price_one_ticket.text = price;
    self.price =[price integerValue];
}


-(void) returnedTransactionResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    NSMutableDictionary *values=(NSMutableDictionary *) [responseString JSONValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];
    });
    
    [[Global globalManager] reloadAllData];
    
}

-(void) failedTransactionResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];
    });
    
    
}

- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    // Update URL with your server
    NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
    finalURL = [finalURL stringByAppendingString: BRAINTREE_MAKE_TRANSACTION];
    NSURL *url = [NSURL URLWithString:finalURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = @"POST";
    [request addPostValue:paymentMethodNonce forKey:@"payment_method_nonce"];
    NSInteger count_st = [self.tf_countOfTickets.text integerValue];
    [request addPostValue:[NSDecimalNumber numberWithInteger:self.price * count_st] forKey:@"amount"];
    NSMutableDictionary *_user_info = [[Global globalManager] getUserInfo];
    [request setPostValue:[_user_info objectForKey:@"userId"] forKey:@"user_id"];
    [MBProgressHUD showHUDAddedTo:self.superViewController.view animated:YES].labelText=@"Making transaction";
    [request setDidFinishSelector:@selector(returnedTransactionResponse:)];
    [request setDidFailSelector:@selector(failedTransactionResponse:)];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    [self postNonceToServer:paymentMethod.nonce]; // Send payment method nonce to your server
    [viewController dismissViewControllerAnimated:YES completion:nil];
    //    [self.superViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self.superViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"cancel paying...");
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    [[Global globalManager]loadUserInfo];
    [[Global globalManager]loadTodayContestInfo];
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    NSMutableDictionary *values=(NSMutableDictionary *) [responseString JSONValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];
    });
    
    
    NSString *clientToken = [values objectForKey:@"token"];
    
    self.braintree = [Braintree braintreeWithClientToken:clientToken];
    
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    // This is where you might want to customize your Drop in. (See below.)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally presented navigation controller:
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                          target:self
                                                                                                          action:@selector(userDidCancelPayment)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self.superViewController presentViewController:navigationController animated:YES completion:nil];
    
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];
    });
    
    
}






- (IBAction)actionBuyBT:(id)sender {
    //self.superView.superViewController
    
    NSInteger count_st = [self.tf_countOfTickets.text integerValue];
    if(count_st <= 0)
    {
        return;
    }
    
    
    // call server url for braintree client token
    
    NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
    finalURL = [finalURL stringByAppendingString: BRAINTREE_CLIENT_TOKEN];
    NSURL *url = [NSURL URLWithString:finalURL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = @"GET";
    
    [MBProgressHUD showHUDAddedTo:self.superViewController.view animated:YES].labelText=@"Fetching client token";
    
    [request setDidFinishSelector:@selector(returnedResponse:)];
    [request setDidFailSelector:@selector(failedResponse:)];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    
    
}

@end
