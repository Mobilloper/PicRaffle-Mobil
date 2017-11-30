//
//  NotificationView.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-30.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "NotificationView.h"
#import "Global.h"
#import "NotificationTableViewCell.h"
#import "Notification.h"

@implementation NotificationView

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
    [[NSBundle mainBundle] loadNibNamed:@"NotificationView" owner:self options:nil];
    [self addSubview: self.view];
   
    [self.tableview registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"notificationItem"];
    self.notifications = [[Global globalManager] getNotis];
    if(self.notifications.count == 0)
    {
        [self.nothingview setHidden:NO];
        [self.tableview setHidden:YES];
    }
    else
    {
        [self.nothingview setHidden:YES];
        [self.tableview setHidden:NO];
    }
    
}

-(void)reloadTableView
{
    self.notifications = [[Global globalManager] getNotis];
    if(self.notifications.count == 0)
    {
        [self.nothingview setHidden:NO];
        [self.tableview setHidden:YES];
    }
    else
    {
        [self.nothingview setHidden:YES];
        [self.tableview setHidden:NO];
    }
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationItem"];
    
    Notification *tempNotification = self.notifications[indexPath.row];
    
    cell.notification_content.text = tempNotification.notiContent;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *temp = [tableView cellForRowAtIndexPath:indexPath];
    
}

@end
