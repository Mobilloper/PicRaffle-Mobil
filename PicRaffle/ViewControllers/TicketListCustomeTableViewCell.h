//
//  TicketListCustomeTableViewCell.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-08.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TicketListCustomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *tf_countOfTickets;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *buyBTN;
@property (weak, nonatomic) IBOutlet UILabel *price_one_ticket;
@property UIViewController *superViewController;
@property NSInteger price;

-(void)deactiveCell;
-(void)activeCell;
-(void)setPriceOneTicket:(NSString*)price;
@end
