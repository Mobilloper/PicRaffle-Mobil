//
//  TicketListTableViewCell.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-02.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketListView.h"

@interface TicketListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *buyBTN;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketcountLabel;
@property NSInteger price;
@property NSInteger count;



-(void)activeCell;
-(void)deactiveCell;
-(void)setValues: (NSInteger)price count:(NSInteger) count;


@property TicketListView *superView;
@property UIViewController *superViewController;

@end
