//
//  TabBar.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-29.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "TabBar.h"
#import "PaymentViewController.h"
#import "Global.h"
#import "AddPhotoView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "JSON.h"

@interface TabBar()

@property AddPhotoView *addPhotoView;

@end

@implementation TabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self customInit];
    }
    return self;
}

-(void)customInit
{
    [[NSBundle mainBundle] loadNibNamed:@"TabBar" owner:self options:nil];
    self.user_info = [[Global globalManager] getUserInfo];
    self.todaycontestinfo = [[Global globalManager] getTodayContestInfo];
    self.isUploadAble = NO;
    self.addPhotoView = [self.superViewController.superViews objectForKey:@"addphotoview"];
    [self addSubview: self.view];
}

- (IBAction)actionCameraButton:(id)sender {
    self.todaycontestinfo = [Global globalManager].todaycontestinfo;
    self.addPhotoView = [self.superViewController.superViews objectForKey:@"addphotoview"];
    self.user_info = [[Global globalManager] getUserInfo];
    NSString *count_tickets = [_user_info objectForKey:@"tickets"];
    if([count_tickets isEqualToString:@"0"])
    {
        [self.superViewController performSegueWithIdentifier:@"buyticket" sender:nil];
    }
    else{
        if(!self.isUploadAble)
        {
            [self.superViewController showAddPhotoView];
            self.addPhotoView.isSelected = YES;
            if(self.addPhotoView.selectedNo != -1)
            {
                [self showUploadIcon];
            }
            else{
                [self showCameraIcon];
            }
            [self.superViewController showAddPhotoView];
        }
        else{
            [self uploadImage];
        }
    }

    
}

-(void)setHomeActive
{
    [self.homeUnderLine setHidden:NO];
    [self.cupUnderLine setHidden:YES];
    [self.superViewController showDashboardView];
    [self showCameraIcon];
}

-(void)setCupActive
{
    [self.homeUnderLine setHidden:YES];
    [self.cupUnderLine setHidden:NO];
    [self.superViewController showActivityView];
    [self showCameraIcon];
}


- (IBAction)actionHomeBTN:(id)sender {
//    [[Global globalManager]reloadAllData];
    [self setHomeActive];
}
- (IBAction)actionCupBTN:(id)sender {
//  [[Global globalManager]reloadAllData];
  [self setCupActive];
}

-(void)showCameraIcon
{
    self.addPhotoView = [self.superViewController.superViews objectForKey:@"addphotoview"];
    [self.cameraicon setHidden:NO];
    [self.uploadicon setHidden:YES];
    self.addPhotoView.isSelected = NO;
    self.isUploadAble = NO;
}

-(void)showUploadIcon
{
    self.addPhotoView = [self.superViewController.superViews objectForKey:@"addphotoview"];
    self.isUploadAble = YES;
    [self.cameraicon setHidden:YES];
    [self.uploadicon setHidden:NO];
    self.addPhotoView.isSelected = YES;
}


-(void)uploadImage
{
    self.todaycontestinfo = [[Global globalManager] getTodayContestInfo];
    NSString *successcode = [self.todaycontestinfo objectForKey:@"success"];
    if([successcode isEqualToString:@"0"])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                                 message:[self.todaycontestinfo objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.superViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
    finalURL = [finalURL stringByAppendingString: CONTESTUPLOAD_URL];
    NSURL *url = [NSURL URLWithString:finalURL];
   
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = @"POST";
    NSString *fileName = @"iphone.jpg";
    [request addPostValue:fileName forKey:@"name"];
    
    // Upload an image
    [MBProgressHUD showHUDAddedTo:self.superViewController.view animated:YES].labelText=@"uploading";
    
    UIImage *img = self.addPhotoView.selectedImageview.image;
    NSData *imageData = UIImageJPEGRepresentation(img, 180);
//    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
//    NSString *imgStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
   
    [request setData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"image"];
//    [request setPostValue:imgStr forKey:@"image"];
    
    [request setPostValue:[_user_info objectForKey:@"userId"] forKey:@"user_id"];
    [request setTimeOutSeconds:45];
    NSString *location = [NSString stringWithFormat:@"%@, %@", [Global globalManager].locationCity, [Global globalManager].locationCountry];
    
    [request setPostValue:location forKey:@"location"];
    NSMutableDictionary *temprow = [self.todaycontestinfo objectForKey:@"msg"];
    [request setPostValue:[temprow objectForKey:@"contest_id"] forKey:@"contest_id"];
    [request setDidFinishSelector:@selector(returnedResponse:)];
    [request setDidFailSelector:@selector(failedResponse:)];
    [request setDelegate:self];
    [request startSynchronous];
    
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSMutableDictionary *values=(NSMutableDictionary *) [responseString JSONValue];
    
    NSString *successcode = [values objectForKey:@"success"];
    if([successcode isEqualToString:@"0"])
    {

            [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];

        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning!"
                                     message:[[values objectForKey:@"msg"] objectForKey:@"error"] 
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        //Add your buttons to alert controller
        [alert addAction:noButton];
        [self.superViewController presentViewController:alert animated:YES completion:nil];
    }
    else if([successcode isEqualToString:@"1"]){

            [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];
     
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Got it!"
//                                     message:[values objectForKey:@"msg"]
                                     message:@"Selected image uploaded"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        //Add your buttons to alert controller
        [alert addAction:noButton];
        [self.superViewController presentViewController:alert animated:YES completion:nil];
        [[Global globalManager] reloadAllData];
    }
    
    
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.superViewController.view animated:YES];
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
    [self.superViewController presentViewController:alert animated:YES completion:nil];
    
}

@end
