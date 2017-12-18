//
//  Global.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-25.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "AppDelegate.h"

@interface Global()
-(void) returnedTodayContest:(ASIHTTPRequest *)request;
-(void) failedResponse:(ASIHTTPRequest *)request;
@end

@implementation Global

static Global *_globalManager;

+(Global *)globalManager
{
    @synchronized (self)
    {
        if (_globalManager == nil) {
            _globalManager =[[Global alloc]init];
        }
    }
    return _globalManager;
}

+(void)releaseManager
{
    if(_globalManager != nil)
    {
        _globalManager = nil;
    }
}

-(void)loadTodayTicktets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: TODAYCONTEST_URL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
         
            [request setDidFinishSelector:@selector(returnedTodayContest:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        });
        
    });
}

-(void)loadMyTickets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: GETTICKETSBYUSERID_URL];
            finalURL = [finalURL stringByAppendingString: [self.user_info objectForKey:@"userId"]];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            [request setDidFinishSelector:@selector(returnedMyTickets:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        });
        
    });
}
-(void)loadPastWinners
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: GETPASTWINNERS_URL];
            
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            [request setDidFinishSelector:@selector(returnedPastWinners:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        });
        
    });
}

-(void)loadTodayContestInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: GETTODAYCONTESTINFO_URL];
            
            NSURL *url = [NSURL URLWithString:finalURL];
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setDidFinishSelector:@selector(returnedTodayContestInfo:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        });
        
    });
}

-(void)loadUserInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: GETUSERINFO_URL];
            
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:[self.user_info objectForKey:@"userId"] forKey:@"user_id"];
            [request setDidFinishSelector:@selector(returnedUserInfo:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        });
    });
}

-(void) loadBalance
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: GETBALANCEURL];
            NSURL *url = [NSURL URLWithString:finalURL];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:[self.user_info objectForKey:@"userId"] forKey:@"user_id"];
            [request setDidFinishSelector:@selector(returnedBalance:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
            
        });
    });
}

-(void)reloadAllData
{
    [self loadUserInfo];
    [self loadTodayTicktets];
    [self loadMyTickets];
    [self loadPastWinners];
    [self loadTodayContestInfo];
}

-(id)init
{
    if((self = [super init]))
    {
        self.user_info = [[NSMutableDictionary alloc]init];
        self.notifications = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) setUserInfo:(NSMutableDictionary *) userinfo
{
    self.user_info = userinfo;
}

-(NSMutableDictionary*) getUserInfo
{
    return self.user_info;
}


-(NSMutableDictionary*) gettodaytickets
{
    return self.todaytickets;
}

-(NSMutableDictionary*) getMytickets
{
    return self.mytickets;
}

-(NSMutableDictionary*) getPastWinners
{
    return self.pastwinners;
}

-(NSMutableDictionary*) getTodayContestInfo
{
    return self.todaycontestinfo;
}

-(void) returnedUserInfo:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    [[Global globalManager] setUserInfo:[values objectForKey:@"msg"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfochanged" object:nil];
}

-(void) returnedTodayContest:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    self.todaytickets = (NSMutableDictionary *) [responseString JSONValue];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appdelegate.dashboardView != nil) {
        [appdelegate.dashboardView reloadView];
    }
}

-(void) returnedMyTickets:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    self.mytickets = (NSMutableDictionary *) [responseString JSONValue];
}

-(void) returnedPastWinners:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    self.pastwinners = (NSMutableDictionary *) [responseString JSONValue];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appdelegate.activityView != nil) {
        [appdelegate.activityView reloadView];
    }
}

-(void) returnedTodayContestInfo:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    self.todaycontestinfo = (NSMutableDictionary *) [responseString JSONValue];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appdelegate.dashboardView != nil) {
        [appdelegate.dashboardView reloadView];
    }
    if(appdelegate.ticketListView != nil)
    {
        [appdelegate.ticketListView reloadView];
    }
}

-(void)returnedBalance:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *values=(NSDictionary *) [responseString JSONValue];
    NSString *balance = [values objectForKey:@"balance"];
    [Global globalManager].balance = [balance intValue];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"balancechanged" object:nil];
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    //NSString *responseString = [request responseString];
}

- (void)saveNotifications{
    // Set archive nsdata
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:self.notifications.count];
    for( Notification* notificationObj in self.notifications) {
        NSData * encodedObj = [NSKeyedArchiver archivedDataWithRootObject:notificationObj];
        [arr addObject:encodedObj];
    }
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    [defaultUser setObject:arr forKey:@"notis"];
}

- (void)loadNotifications{

    NSMutableArray *savedArr  = [[NSUserDefaults standardUserDefaults] objectForKey:@"notis"];
    self.notifications = [[NSMutableArray alloc] init];
    for(NSData *tempdata in savedArr)
    {
        Notification *tempNoti = [NSKeyedUnarchiver unarchiveObjectWithData:tempdata];
        [self.notifications addObject:tempNoti];
    }
}

-(NSMutableArray*)getNotis{
    return  self.notifications;
}

- (void)loadUserLoginInfo
{
    NSData *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSData *userpassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    self.userName = [NSKeyedUnarchiver unarchiveObjectWithData:username];
    self.userPassword = [NSKeyedUnarchiver unarchiveObjectWithData:userpassword];
}

- (void)saveUserLoginInfo
{
    NSData *userName = [NSKeyedArchiver archivedDataWithRootObject:self.userName];
    NSData *password = [NSKeyedArchiver archivedDataWithRootObject:self.userPassword];
    NSUserDefaults * defaultUser = [NSUserDefaults standardUserDefaults];
    [defaultUser setObject:userName forKey:@"username"];
    [defaultUser setObject:password forKey:@"password"];
    
}
@end
