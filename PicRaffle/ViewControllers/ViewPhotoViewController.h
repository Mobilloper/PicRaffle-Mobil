//
//  ViewPhotoViewController.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property NSURL *imageUrl;
@end
