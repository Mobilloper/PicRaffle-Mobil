//
//  DashboardView.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-30.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "DashboardView.h"
#import "Global.h"
#import "UIImageView+WebCache.h"

@implementation DashboardView

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
    self.wrap = YES;
    self.items = [NSMutableArray array];
    
    NSString *success_code = [[[Global globalManager] gettodaytickets] objectForKey:@"success"];
    if([success_code isEqualToString:@"0"])
    {
        self.items = nil;
    }
    else  if([success_code isEqualToString:@"1"])
    {
        NSDictionary *temp = [[Global globalManager] gettodaytickets];
        self.items = (NSMutableArray*)[temp objectForKey:@"msg"];
    }
    else{
        self.items = nil;
    }
    
    self.today_contest = [[Global globalManager] getTodayContestInfo];
    [[NSBundle mainBundle] loadNibNamed:@"Dashboard" owner:self options:nil];
    
    [self loadAllDataComponets];
    [self addSubview: self.view];
    self.carousel.type = 1;
    [self.carousel setScrollOffset:40.0f];
}

-(void)loadAllDataComponets
{
    self.today_contest = [[Global globalManager] getTodayContestInfo];
    if([[self.today_contest objectForKey:@"success"] isEqualToString:@"1"])
    {
        NSMutableDictionary *temp = [self.today_contest objectForKey:@"msg"];
        NSString *prize = [temp objectForKey:@"prize"];
        self.today_prize_tv.text = [NSString stringWithFormat:@"TODAY'S PRIZE $%@", prize];
    }
}



#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSDictionary *temp = [self.items objectAtIndex:index];
    
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.carousel.frame.size.width, self.carousel.frame.size.height)];
        
        NSString *finalURL = [NSString stringWithFormat:TICKET_IMAGE_FOLDER];
        finalURL = [finalURL stringByAppendingString: [temp objectForKey:@"image_name"]];
        NSURL *url = [NSURL URLWithString:finalURL];
        
        //NSData *image_data = [NSData dataWithContentsOfURL:url];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.carousel.frame.size.width-20, self.carousel.frame.size.height)];
        
        __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.center = imageView.center;
        activityIndicator.hidesWhenStopped = YES;
        [imageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        //[imageView setImage:[UIImage imageWithData:image_data]];
        [imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error == nil) {
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                //self.flagDownloading = NO;
            } else {
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                //self.flagDownloading = NO;
            }
        }];
        
        view.contentMode = UIViewContentModeCenter;
        [view addSubview:imageView];
        
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
      label.text = @"test";
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.carousel.frame.size.width,self.carousel.frame.size.height)];


        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.carousel.frame.size.width-20, self.carousel.frame.size.height)];
        [imageView setImage:[UIImage imageNamed:@"dashboard image@2x.png"]];
        view.contentMode = UIViewContentModeCenter;
        [view addSubview:imageView];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }

    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.items)[(NSUInteger)index];
    NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
    NSDictionary *temp = [self.items objectAtIndex:self.carousel.currentItemIndex];
    self.ticket_user_tv.text = [temp objectForKey:@"name"];
}

- (IBAction)actionJoinBTN:(id)sender {
    self.user_info = [[Global globalManager] getUserInfo];
    NSString *count_tickets = [_user_info objectForKey:@"tickets"];
    if([count_tickets isEqualToString:@"0"])
    {
     [self.superViewController performSegueWithIdentifier:@"buyticket" sender:nil];
    }
    else{
        [self.superViewController showAddPhotoView];
    }
}

-(void)reloadView
{
    NSString *success_code = [[[Global globalManager] gettodaytickets] objectForKey:@"success"];
    if([success_code isEqualToString:@"0"])
    {
        self.items = nil;
    }
    else  if([success_code isEqualToString:@"1"])
    {
        NSDictionary *temp = [[Global globalManager] gettodaytickets];
        self.items = (NSMutableArray*)[temp objectForKey:@"msg"];
    }
    else{
        self.items = nil;
    }
    [self.carousel reloadData];
    [self loadAllDataComponets];
}
@end
