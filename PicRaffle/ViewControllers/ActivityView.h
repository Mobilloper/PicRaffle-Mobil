//
//  ActivityView.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicWithSideBarViewController.h"
#import "MZTimerLabel.h"

@interface ActivityView : UIView<UICollectionViewDelegate,UICollectionViewDataSource, MZTimerLabelDelegate>
{
    MZTimerLabel *timerLabel;
}

@property BasicWithSideBarViewController *superViewController;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *today_prize;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;




@property NSMutableArray *pastwinners;
@property NSMutableDictionary *today_contest;

-(void)reloadView;
-(void) initTimer;

@end
