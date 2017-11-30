//
//  NotificationView.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-30.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

@interface NotificationView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *nothingview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property NSMutableArray *notifications;

-(void)reloadTableView;
@end
