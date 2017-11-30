//
//  BasicViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "BasicViewController.h"
#import "LeftSidBarViewController.h"
#import "NavigationController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *    storyboardobj=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BasicWithSideBarViewController* viewController = (BasicWithSideBarViewController*)[storyboardobj instantiateViewControllerWithIdentifier:@"dashboard_stb"];
    
    
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:viewController];
    [navigationController setNavigationBarHidden:YES animated:YES];
    
    
    self.rootViewController = navigationController;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
//    window.rootViewController = self;
    
    LeftSidBarViewController* lvc = (LeftSidBarViewController*)[storyboardobj instantiateViewControllerWithIdentifier:@"leftsidebar_stb"];
    lvc.superViewController = (BasicWithSideBarViewController *)self.rootViewController;
    self.leftViewController = lvc;
    lvc.superViewController  = viewController;
    
    self.leftViewWidth = 250.0;
    //self.leftViewBackgroundImage = [UIImage imageNamed:@"imageLeft"];
    self.leftViewBackgroundColor = [UIColor colorWithRed:0.5 green:0.65 blue:0.5 alpha:0.95];
    self.rootViewCoverColorForLeftView = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideAbove;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];

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

@end
