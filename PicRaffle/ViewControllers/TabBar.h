//
//  TabBar.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-29.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"

@interface TabBar : UIView

@property BasicWithSideBarViewController *superViewController;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *homeUnderLine;
@property (weak, nonatomic) IBOutlet UIView *cupUnderLine;
@property (weak, nonatomic) IBOutlet UIImageView *cameraicon;
@property (weak, nonatomic) IBOutlet UIImageView *uploadicon;
@property NSMutableDictionary *user_info;
@property NSMutableDictionary *todaycontestinfo;
@property BOOL isUploadAble;
-(void)setHomeActive;
-(void)setCupActive;
-(void)showCameraIcon;
-(void)showUploadIcon;

@end
