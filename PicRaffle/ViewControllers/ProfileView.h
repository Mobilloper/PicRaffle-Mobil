//
//  ProfileView.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"

@interface ProfileView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

//@property NSArray *images;
@property BasicWithSideBarViewController *superViewController;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *user_name_tv;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *description_tv;

@property NSMutableDictionary *user_info;
@property NSMutableArray *mytickets;
@property NSMutableDictionary *today_contest;

@property Boolean isMe;


-(void)reloadView;
-(void)reloadViewWithOhterProfile:(NSString *)userId;
@end
