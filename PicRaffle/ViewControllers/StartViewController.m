//
//  StartViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "StartViewController.h"
#import "NavigationController.h"
#import "BasicWithSideBarViewController.h"

@interface StartViewController ()<UIScrollViewDelegate>

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height-5);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLogoutNotification:) name:@"Logout" object:nil];

    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) receiveLogoutNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"Logout"])
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -custom func
-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)actionBackBT:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionStartBT:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
