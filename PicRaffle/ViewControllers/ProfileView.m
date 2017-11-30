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

-(void)reloadView
{
    self.user_info = [[Global globalManager] getUserInfo];
    
    self.user_name_tv.text = [self.user_info objectForKey:@"name"];
    
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
