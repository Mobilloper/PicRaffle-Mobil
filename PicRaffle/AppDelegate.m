//
//  AppDelegate.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-27.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "AppDelegate.h"
#import <Braintree/Braintree.h>
#import "Notification.h"
#import "Global.h"
#import "NSData+Conversion.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    user_info = [[NSDictionary alloc]init];
    
    
    [Braintree setReturnURLScheme:@"com.professmultimedia.mymoviemessages.payments"];
    
    NSDictionary *notificaiton = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificaiton != nil) {
        NSLog(@"Launch Option is %@", notificaiton);
        
    } else {
        if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
            UNUserNotificationCenter *notifiCenter = [UNUserNotificationCenter currentNotificationCenter];
            notifiCenter.delegate = self;
            [notifiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if( !error ){
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
            }];
        } else {
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        }
    }
    
    [Global.globalManager loadNotifications];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.professmultimedia.mymoviemessages.payments"] == NSOrderedSame) {
        return [Braintree handleOpenURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    }
    return NO;
}

// If you support iOS 7 or 8, add the following method.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.professmultimedia.mymoviemessages.payments"] == NSOrderedSame) {
        return [Braintree handleOpenURL:url sourceApplication:sourceApplication];
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSString *strToken = [devToken hexadecimalString];
    if(strToken != nil && ![strToken isEqualToString:@""] )
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *finalURL = [NSString stringWithFormat:SITE_DOMAIN];
            finalURL = [finalURL stringByAppendingString: ADDDEVICETOKEN_URL];
            NSURL *url = [NSURL URLWithString:finalURL];
            
            // comment
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:strToken forKey:@"dev_token"];
            [request setDidFinishSelector:@selector(returnedResponse:)];
            [request setDidFailSelector:@selector(failedResponse:)];
            [request setDelegate:self];
            [request startSynchronous];
        });
        
    });
    NSLog(@"My device token = %@", strToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Remote notification support is unavailable due to error: %@", err);
}

#pragma mark UNUserNotificationCenterDelegate


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    NSDictionary *apsInfo = [notification.request.content.userInfo objectForKey:@"aps"];
    NSLog(@"Notification = %@", apsInfo);
    Notification* noti = [[Notification alloc] init];
    noti.notiID = @"1";
    noti.notiContent = [apsInfo objectForKey:@"alert"];
    noti.notiKind = @"start";
    [Global.globalManager.notifications addObject:noti];
    [Global.globalManager saveNotifications];
    if(self.notificationView != nil)
    {
        [self.notificationView reloadTableView];
        [self.navigationBar setNotificationNumber:(int)[UIApplication sharedApplication].applicationIconBadgeNumber + 1];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }
    
    [[Global globalManager] reloadAllData];
    completionHandler(UNNotificationPresentationOptionAlert);
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddBadgeNotification"
                                                        object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMenuBadgeNotification"
                                                        object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearBadgeNotification"
                                                        object:self];

    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    completionHandler();
}

-(void) returnedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    
}

-(void) failedResponse:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
}



@end
