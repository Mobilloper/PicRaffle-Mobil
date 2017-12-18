//
//  ActivityView.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-01.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "ActivityView.h"
#import "ActivityCollectionViewCell.h"
#import "ViewPhotoViewController.h"
#import "Global.h"
#import "UIImageView+WebCache.h"
#import "MZTimerLabel.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation ActivityView

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
    [[NSBundle mainBundle] loadNibNamed:@"ActivityView" owner:self options:nil];
     [self.galleryCollectionView registerNib:[UINib nibWithNibName:@"ActivityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"gallerycell"];
    
    self.pastwinners = [NSMutableArray array];
    NSDictionary *temp =[[Global globalManager] getPastWinners];
    if([[temp objectForKey:@"success"] isEqualToString:@"0"])
    {
        self.pastwinners = nil;
    }
    else if([[temp objectForKey:@"success"] isEqualToString:@"1"])
    {
        self.pastwinners = [temp objectForKey:@"msg"];
    }
    else{
        self.pastwinners = nil;
    }
    self.today_contest = [[Global globalManager] getTodayContestInfo];
    [self initTimer];
    [self addSubview: self.view];
}

-(void) initTimer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: GETLEFTSECONDSURL];
            
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        });
        
    });
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    NSString *successcode = [values objectForKey:@"success"];
    if([successcode isEqualToString:@"1"])
    {
        NSDecimalNumber *seconds =[values objectForKey:@"msg"];
        timerLabel = [[MZTimerLabel alloc] initWithLabel:self.countdownLabel andTimerType:MZTimerLabelTypeTimer];
        [timerLabel setCountDownTime:[seconds intValue]];
        [timerLabel start];
    }
}


-(void) failedResponse:(ASIHTTPRequest *)request
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Network Error!" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    }]];
    
    [self.superViewController presentViewController:alertController animated:YES completion:nil];
}
-(void)loadAllDataComponets
{
    self.today_contest = [[Global globalManager] getTodayContestInfo];
    if([[self.today_contest objectForKey:@"success"] isEqualToString:@"1"])
    {
        NSMutableDictionary *temp = [self.today_contest objectForKey:@"msg"];
        NSString *prize = [temp objectForKey:@"prize"];
        self.today_prize.text = [NSString stringWithFormat:@"$%@", prize];
    }
}



#pragma mark collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pastwinners.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (ActivityCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    ProfileGalleryCollectionViewCell *cell = [[ProfileGalleryCollectionViewCell alloc]init];
    ActivityCollectionViewCell *cell = [self.galleryCollectionView dequeueReusableCellWithReuseIdentifier:@"gallerycell" forIndexPath:indexPath];
    
    
    NSDictionary *temp = [self.pastwinners objectAtIndex:indexPath.row];
    
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
    return CGSizeMake(collectionView.frame.size.width/3,collectionView.frame.size.width/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // [self.superViewController showDashboardView];
    ViewPhotoViewController *vpVC = (ViewPhotoViewController *) [self.superViewController.storyboard instantiateViewControllerWithIdentifier:@"view_photo_std"];
    //[vpVC setRefer:self.superViewController.navigationController];
    
    NSDictionary *temp = [self.pastwinners objectAtIndex:indexPath.row];
    
    NSString *finalURL = [NSString stringWithFormat:TICKET_IMAGE_FOLDER];
    finalURL = [finalURL stringByAppendingString: [temp objectForKey:@"image_name"]];
    NSURL *url = [NSURL URLWithString:finalURL];
    
    vpVC.imageUrl = url;

    
    [self.superViewController presentViewController:vpVC animated:YES completion:nil];
}

-(void)reloadView
{
    self.pastwinners = [NSMutableArray array];
    NSDictionary *temp =[[Global globalManager] getPastWinners];
    if([[temp objectForKey:@"success"] isEqualToString:@"0"])
    {
        self.pastwinners = nil;
    }
    else if([[temp objectForKey:@"success"] isEqualToString:@"1"])
    {
        self.pastwinners = [temp objectForKey:@"msg"];
    }
    else{
        self.pastwinners = nil;
    }
    [self.galleryCollectionView reloadData];
    [self loadAllDataComponets];
}

@end
