//
//  BuyTicketViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-10-02.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "BuyTicketViewController.h"
#import "Global.h"

@interface BuyTicketViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation BuyTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // self.iconImage.layer.cornerRadius = self.contentView.layer.frame.size.height / 2 ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)actionBackgroundBTN:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)actionNoThanksBTN:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)actionBuyATicket:(id)sender {
    [self.superViewController showBuyTicketListView];
    [[Global globalManager]loadTodayContestInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
