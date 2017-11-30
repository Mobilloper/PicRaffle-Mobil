//
//  MyTicketsViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-08.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "MyTicketsViewController.h"
#import "Global.h"
#import "TicketListView.h"


@interface MyTicketsViewController ()
@property (weak, nonatomic) IBOutlet TicketListView *ticket_listview;

@end

@implementation MyTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user_info = [[Global globalManager] getUserInfo];
    NSString *tickets = [self.user_info objectForKey:@"tickets"];
    tickets = [tickets stringByAppendingString:@" Tickets"];
    self.ticket_count_tv.text = tickets;
    self.ticket_listview.viewController = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionMyTicketsBTN:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
