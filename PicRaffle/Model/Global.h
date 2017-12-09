//
//  Global.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-08.
//  Copyright © 2017 rubby star. All rights reserved.
//

#ifndef Global_h
#define Global_h


#define SITE_DOMAIN  @"http://192.168.1.61/backend/"
//#define SITE_DOMAIN                 @"http://admin.picraffleadmin.com/backend/"



#define BRAINTREE_CLIENT_TOKEN      @"getbraintreetoken"
#define BRAINTREE_MAKE_TRANSACTION  @"maketransaction"

//#define ACCOUNT_IMAGE_FOLDER        @"http://admin.picraffleadmin.com/assets/account_image/"
//#define TICKET_IMAGE_FOLDER         @"http://admin.picraffleadmin.com/assets/uploads/"
#define ACCOUNT_IMAGE_FOLDER        @"http://192.168.1.61/assets/account_image/"
#define TICKET_IMAGE_FOLDER         @"http://192.168.1.61/assets/uploads/"

#define LOGIN_URL                   @"login"
#define SIGNUP_URL                  @"signup"
#define TODAYCONTEST_URL            @"todaytickets"
#define GETTICKETSBYUSERID_URL      @"getticketsbyuserid/"
#define GETPASTWINNERS_URL          @"getpastwinners"
#define BUYTICKETS_URL              @"buytickets/"
#define GETTODAYCONTESTINFO_URL     @"gettodaycontestinfo"
#define CONTESTUPLOAD_URL           @"contestupload"
#define CHANGEUSERNAME_URL          @"changeusername"
#define CHANGEEMAIL_URL             @"changeemail"
#define CHANGEPASSWORD_URL          @"changepassword"
#define DELETEUSER_URL              @"deleteuser"
#define ADDDEVICETOKEN_URL          @"adddevicetoken"
#define GETUSERINFO_URL             @"getuserinfo"
#define CHANGEUSERPHOTOURL          @"changeuserphoto"
#define GETLEFTSECONDSURL           @"getleftsecondstodaycontest"
#define GETBALANCEURL               @"getbalance"
#define CHANGEPAYPALEMAIL           @"changepaypalemail"

#endif /* Global_h */

#import "Notification.h"


@interface Global : NSObject

@property(nonatomic, retain) NSMutableDictionary *user_info;
@property(nonatomic, retain) NSMutableDictionary *todaytickets;
@property(nonatomic, retain) NSMutableDictionary *mytickets;
@property(nonatomic, retain) NSMutableDictionary *pastwinners;
@property(nonatomic, retain) NSMutableDictionary *todaycontestinfo;
@property(nonatomic, retain) NSMutableArray *notifications;

@property NSString *userName;
@property NSString *userPassword;

@property NSString *locationCity;
@property NSString *locationCountry;

@property NSInteger balance;

+(Global *)globalManager;
+(void)releaseManager;
-(void)loadTodayTicktets;
-(void)loadMyTickets;
-(void)loadPastWinners;
-(void)loadTodayContestInfo;
-(void)loadUserInfo;
-(void)loadBalance;
-(void)reloadAllData;


-(void) setUserInfo:(NSMutableDictionary *) userinfo;
-(NSMutableDictionary*) getUserInfo;
-(NSMutableDictionary*) gettodaytickets;
-(NSMutableDictionary*) getMytickets;
-(NSMutableDictionary*) getPastWinners;
-(NSMutableDictionary*) getTodayContestInfo;


- (void)saveNotifications;
- (void)loadNotifications;
- (NSMutableArray*) getNotis;
- (void)saveUserLoginInfo;
- (void)loadUserLoginInfo;

@end
