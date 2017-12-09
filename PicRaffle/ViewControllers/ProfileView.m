//
//  ProfileView.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "ProfileView.h"
#import "ProfileGalleryCollectionViewCell.h"
#import "ViewPhotoViewController.h"
#import "Global.h"
#import "UIImageView+WebCache.h"
#import "TOCropViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"


@interface ProfileView()<TOCropViewControllerDelegate ,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ProfileView

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
    [[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil];
    //self.profileImage.layer.cornerRadius = self.profileImage.layer.frame.size.height / 2 ;
    [self.galleryCollectionView registerNib:[UINib nibWithNibName:@"ProfileGalleryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"gallerycell"];
    
    
    self.user_info = [[Global globalManager] getUserInfo];
    self.user_name_tv.text = [self.user_info objectForKey:@"name"];
    self.location.text = [NSString stringWithFormat:@"%@, %@",[Global globalManager].locationCity, [Global globalManager].locationCountry];
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
    self.profileImage.image = [UIImage imageWithData:image_data];
    
    self.mytickets = [NSMutableArray array];
    NSDictionary *temp =[[Global globalManager] getMytickets];
    if([[temp objectForKey:@"success"] isEqualToString:@"0"])
    {
        self.mytickets = nil;
    }
    else if([[temp objectForKey:@"success"] isEqualToString:@"1"])
    {
        self.mytickets = [temp objectForKey:@"msg"];
    }
    else{
        self.mytickets = nil;
    }
    
    self.today_contest = [[Global globalManager]getTodayContestInfo];
    
    
    [self addSubview: self.view];
}



#pragma mark collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mytickets.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (ProfileGalleryCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    ProfileGalleryCollectionViewCell *cell = [[ProfileGalleryCollectionViewCell alloc]init];
    ProfileGalleryCollectionViewCell *cell = [self.galleryCollectionView dequeueReusableCellWithReuseIdentifier:@"gallerycell" forIndexPath:indexPath];
    
    NSDictionary *temp = [self.mytickets objectAtIndex:indexPath.row];
    
    NSString *finalURL = [NSString stringWithFormat:TICKET_IMAGE_FOLDER];
    finalURL = [finalURL stringByAppendingString: [temp objectForKey:@"image_name"]];
    NSURL *url = [NSURL URLWithString:finalURL];
    
    [cell.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil) {
           
           
        } else {
            
           
        }
    }];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/3-10,collectionView.frame.size.width/3-10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // [self.superViewController showDashboardView];
    ViewPhotoViewController *vpVC = (ViewPhotoViewController *) [self.superViewController.storyboard instantiateViewControllerWithIdentifier:@"view_photo_std"];
    //[vpVC setRefer:self.superViewController.navigationController];
    
    NSDictionary *temp = [self.mytickets objectAtIndex:indexPath.row];
    
    NSString *finalURL = [NSString stringWithFormat:TICKET_IMAGE_FOLDER];
    finalURL = [finalURL stringByAppendingString: [temp objectForKey:@"image_name"]];
    NSURL *url = [NSURL URLWithString:finalURL];
    
    vpVC.imageUrl = url;

    [self.superViewController presentViewController:vpVC animated:YES completion:nil];
}
- (IBAction)actionImageClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:cancelAction];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        UIImagePickerController *picker;
                                        picker  = [[UIImagePickerController alloc]init];
                                        picker.delegate = self;
                                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        [self.superViewController presentViewController:picker animated:YES completion:nil];
                                    }];
    [alertController addAction:libraryAction];
    
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take from Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                      {
                                          UIImagePickerController *picker;
                                          picker  = [[UIImagePickerController alloc]init];
                                          picker.delegate = self;
                                          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                          [self.superViewController presentViewController:picker animated:YES completion:nil];
                                          
                                      }];
    [alertController addAction:takePhotoAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
    popPresenter.sourceView = self.profileImage;
    popPresenter.sourceRect = self.profileImage.bounds;
    
    [self.superViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma imagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image =info[UIImagePickerControllerOriginalImage];
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc]initWithImage:image];
    cropViewController.delegate = self;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.superViewController presentViewController:cropViewController animated:YES completion:nil];
}

#pragma tocropviewcontroller delegate

//- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropImageToRect:(CGRect)cropRect angle:(NSInteger)angle NS_SWIFT_NAME(cropViewController(_:didCropToRect:angle:))
//{
//    [cropViewController dismissViewControllerAnimated:YES completion:nil];
//}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    // 'image' is the newly cropped version of the original image
 
    self.profileImage.image =image;// (UIImage*) [UIImage imageNamed:@"add photo image"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: CHANGEUSERPHOTOURL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            request.requestMethod = @"POST";
            NSString *fileName = @"iphone.jpg";
            [request addPostValue:fileName forKey:@"name"];
            UIImage *img = self.profileImage.image;
            NSData *imageData = UIImageJPEGRepresentation(img, 90);
            
            [request setData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"image"];
            [request setPostValue:[_user_info objectForKey:@"userId"] forKey:@"user_id"];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startAsynchronous];
        });
        
    });
    
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSMutableDictionary *values=(NSMutableDictionary *) [responseString JSONValue];
    NSString *successcode = [values objectForKey:@"success"];
    if([successcode isEqualToString:@"0"])
    {
       
    }
    else if([successcode isEqualToString:@"1"]){
        
    }
    [[Global globalManager] reloadAllData];
    
    
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
}


-(void)reloadView
{
    self.user_info = [[Global globalManager] getUserInfo];
    self.user_name_tv.text = [self.user_info objectForKey:@"name"];
    self.location.text = [NSString stringWithFormat:@"%@, %@",[Global globalManager].locationCity, [Global globalManager].locationCountry];
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
    self.profileImage.image = [UIImage imageWithData:image_data];
    
    self.mytickets = [NSMutableArray array];
    NSDictionary *temp =[[Global globalManager] getMytickets];
    if([[temp objectForKey:@"success"] isEqualToString:@"0"])
    {
        self.mytickets = nil;
    }
    else if([[temp objectForKey:@"success"] isEqualToString:@"1"])
    {
        self.mytickets = [temp objectForKey:@"msg"];
    }
    else{
        self.mytickets = nil;
    }
    
    [self.galleryCollectionView reloadData];
}
@end
