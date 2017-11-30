//
//  AddPhotoView.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "AddPhotoView.h"
#import "TOCropViewController.h"
#import "TabBar.h"

@interface AddPhotoView()<TOCropViewControllerDelegate ,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property int xOffset;
@property CGFloat width;
@property NSMutableArray *capuredImageArray;
@property TabBar *tabBar;

@end

@implementation AddPhotoView

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
    [[NSBundle mainBundle] loadNibNamed:@"AddPhotoView" owner:self options:nil];
    [self addSubview: self.view];
    self.isSelected = NO;
    self.selectedNo = -1;
    self.capuredImageArray =  [NSMutableArray array];
    self.tabBar = [self.superViewController.superViews objectForKey:@"tabbar"];
    self.xOffset = 0;
    self.width = self.scrollImages.frame.size.height;
    self.img_1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.xOffset,0,_width, _width)];
    self.img_1.image = (UIImage*) [UIImage imageNamed:@"take picture"];
    self.img_1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAdd)];
    [self.img_1 addGestureRecognizer:tap];
    [self.scrollImages addSubview:self.img_1];
    self.xOffset+=_width+10;
    self.scrollImages.contentSize = CGSizeMake(200+self.xOffset,_width);
}


-(void)imageAdd
{
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
    popPresenter.sourceView = self.img_1;
    popPresenter.sourceRect = self.img_1.bounds;
    
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
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.xOffset,0,_width, _width)];
    img.image =image;// (UIImage*) [UIImage imageNamed:@"add photo image"];
    [self.scrollImages addSubview:img];
    self.xOffset+=_width+10;
    self.scrollImages.contentSize = CGSizeMake(self.xOffset,_width);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [img setUserInteractionEnabled:YES];
    [img addGestureRecognizer:singleTap];
    singleTap.view.tag =self.capuredImageArray.count;
    [self.capuredImageArray addObject:img];
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapDetected:(UITapGestureRecognizer*)tap{
     self.tabBar = [self.superViewController.superViews objectForKey:@"tabbar"];
    [self.tabBar showUploadIcon];
    [self.superViewController showUploadIcon];
    UIImageView *temp = [self.capuredImageArray objectAtIndex:tap.view.tag];
    self.selectedImageview.image = temp.image;
    self.isSelected = YES;
    self.selectedNo = tap.view.tag;
}

@end
