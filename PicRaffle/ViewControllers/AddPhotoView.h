//
//  AddPhotoView.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"

@interface AddPhotoView : UIView

@property BasicWithSideBarViewController *superViewController;

@property UIImageView *img_1;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImages;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageview;
@property BOOL isSelected;
@property NSInteger selectedNo;

-(void)imageAdd;
-(void)enableIsSelected;
@end
