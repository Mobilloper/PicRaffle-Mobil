//
//  ProfileGalleryCollectionViewCell.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "ProfileGalleryCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ProfileGalleryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initWithUrl:(NSURL *)url
{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
//
//            NSData *data0 = [NSData dataWithContentsOfURL:url];
//            UIImage *image = [UIImage imageWithData:data0];
//            dispatch_sync(dispatch_get_main_queue(), ^(void){
//                self.imageView.image = image;
//            });
//        });
    
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.center = self.imageView.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.imageView addSubview:activityIndicator];
    [activityIndicator startAnimating];

    [self.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil) {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
        } else {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
        }
    }];
}

@end
