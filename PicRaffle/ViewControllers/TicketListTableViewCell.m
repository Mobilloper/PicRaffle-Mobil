//
//  TicketListTableViewCell.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-02.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "TicketListTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import <Braintree/Braintree.h>
#import <Braintree-API.h>
#import <Braintree/Braintree-API.h>

#include "Global.h"

@interface TicketListTableViewCell() <BTDropInViewControllerDelegate>

@property (nonatomic, strong) Braintree *braintree;
@property (weak, nonatomic) IBOutlet UIView *vCell;

@end


@implementation TicketListTableViewCell

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
    
    [self.priceLabel setTextColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
    
    [self.ticketcountLabel setTextColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1]];
}

-(void)deactiveCell
{
    self.backgroundImage.image = (UIImage*) [UIImage imageNamed:@"ticket list background"];
    [self.buyBTN setTitleColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1] forState:UIControlStateNormal];
    [self.buyBTN setBackgroundColor:[UIColor colorWithRed:88/255 green:135/255 blue:255/255 alpha:0.7]];
    
    [self.priceLabel setTextColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1]];
    
    [self.ticketcountLabel setTextColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1]];
    
}

-(void)setValues: (NSInteger)price count:(NSInteger) count
{
    NSString *price_str = [NSString stringWithFormat:@"$%ld", (long)price];
    NSString *count_str = [NSString stringWithFormat:@"%ld Ticket", (long)count];
    
    self.priceLabel.text = price_str;
    self.ticketcountLabel.text = count_str;
    self.price  = price;
    self.count = count;
}

-(void) returnedTransactionResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    NSString *successcode = [values objectForKey:@"status"];
    if([successcode isEqualToString:@"ok"])
    {
        [[Global globalManager]reloadAllData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];
    });
    
}

-(void) failedTransactionResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    
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
    
    [request addPostValue:[NSDecimalNumber numberWithInteger:self.price] forKey:@"amount"];
    [request setPostValue:[NSDecimalNumber numberWithInteger:self.count] forKey:@"count"];
    
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


- (IBAction)actionBuyBtn:(id)sender {
    
    
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
    
    
    
    
    /*
    
    
    
    
    //self.superView.superViewController
    PayPalConfiguration *paypalconfig;
    paypalconfig = [[PayPalConfiguration alloc]init];
    paypalconfig.acceptCreditCards = YES;
    paypalconfig.merchantName = @"buy tickecks";
    paypalconfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    paypalconfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    paypalconfig.languageOrLocale = [NSLocale preferredLanguages][0];
    paypalconfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    NSLog(@"pay pal sdk: %@", [PayPalMobile libraryVersion]);
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"tickets" withQuantity:1 withPrice:[NSDecimalNumber numberWithInteger:self.price] withCurrency:@"USD" withSku:@"sku-tikckets"];
    NSArray * items = @[item1];
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    PayPalPaymentDetails *paymenDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
    NSDecimalNumber *total=[[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    PayPalPayment *payment = [[PayPalPayment alloc]init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Buy Tickets";
    payment.items = items;
    
    payment.paymentDetails = paymenDetails;
    if(!payment.processable)
    {
        
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc]initWithPayment:payment configuration:paypalconfig delegate:self];
    [self.superViewController presentViewController:paymentViewController animated:YES completion:nil];

    PayPalFuturePaymentViewController *fpViewcontroller = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:paypalconfig delegate:self];
    [self.superViewController presentViewController:fpViewcontroller animated:YES completion:nil];

     */
}



@end
