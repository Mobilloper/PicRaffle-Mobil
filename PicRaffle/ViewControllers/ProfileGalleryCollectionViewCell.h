//
//  ProfileGalleryCollectionViewCell.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileGalleryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


-(void)initWithUrl:(NSURL *)url;
@end
