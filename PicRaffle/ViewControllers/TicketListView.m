//
//  TicketListView.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-02.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "TicketListView.h"
#import "TicketListTableViewCell.h"
#import "TicketListCustomeTableViewCell.h"
#import "Global.h"

@implementation TicketListView

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
    [[NSBundle mainBundle] loadNibNamed:@"TicketListView" owner:self options:nil];
    [self.tableview registerNib:[UINib nibWithNibName:@"TicketListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ticketItem"];
    
    self.todaycontest = [[Global globalManager] todaycontestinfo];
    
    [self addSubview: self.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *successcode = [self.todaycontest objectForKey:@"success"];
    if([successcode isEqualToString:@"0"])
    {
        return 0;
    }
    
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *temprow = [self.todaycontest objectForKey:@"msg"];
   // NSDictionary *temprow = [temparray objectAtIndex:0];
    
    
    if(indexPath.row == 0)
    {
        [self.tableview registerNib:[UINib nibWithNibName:@"TicketListCustomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ticketItemCustome"];
        TicketListCustomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketItemCustome"];
        [cell setPriceOneTicket:[temprow objectForKey:@"price_one_ticket"]];
        cell.superViewController = self.viewController;
        return cell;
    }
    
    [self.tableview registerNib:[UINib nibWithNibName:@"TicketListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ticketItem"];
    TicketListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketItem"];
    cell.superView = self;
    cell.superViewController = self.viewController;
    
    
    switch (indexPath.row) {
        case 1:
            [cell setValues:[[temprow objectForKey:@"t30_tickets_price"] integerValue] count:5];
            break;
        case 2:
            [cell setValues:[[temprow objectForKey:@"t70_tickets_price"] integerValue] count:10];
            break;
        case 3:
            [cell setValues:[[temprow objectForKey:@"t120_tickets_price"] integerValue] count:20];
            break;
        case 4:
            [cell setValues:[[temprow objectForKey:@"t200_tickets_price"] integerValue] count:50];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *temp = [tableView cellForRowAtIndexPath:indexPath];
    
    for (int i=0; i<5; i++) {
        NSIndexPath *tempIndex = [NSIndexPath indexPathForItem:i inSection:0];
        UITableViewCell *temp_cell = [tableView cellForRowAtIndexPath:tempIndex];
        
        if(temp_cell == temp)
        {
            continue;
        }
         [tableView deselectRowAtIndexPath:tempIndex animated:YES];
        if(indexPath.row == 0)
        {
           
            [(TicketListCustomeTableViewCell*)temp_cell deactiveCell];
        }
        else{
             [(TicketListTableViewCell*)temp_cell deactiveCell];
        }
    }
    
    if(indexPath.row == 0)
    {
        
        [(TicketListCustomeTableViewCell*)temp activeCell];
    }
    else{
        [(TicketListTableViewCell*)temp activeCell];
    }
    
}

-(void)reloadView
{
    self.todaycontest = [[Global globalManager] todaycontestinfo];
    [self.tableview reloadData];
}

@end
