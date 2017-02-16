//
//  DKFBLoginViewController.m
//  CheckList
//
//  Created by Dmitry Kulakov on 15.02.17.
//  Copyright © 2017 kulakoff. All rights reserved.
//

#import "DKFBLoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DKListsViewController.h"

static NSString *ListsSegueIdentifier = @"ListsSegue";

@interface DKFBLoginViewController () <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong,nonatomic) NSArray *permissions;

@end

@implementation DKFBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLoginButton];
    [self configureNavigationBar];
    if ([self checkStatus]) {
        [self fetchProfile];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self checkStatus];
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (!result.isCancelled) {
        [self fetchProfile];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"LOGOUT");
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - Configure Elements

- (void)configureNavigationBar {
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(presentListViewController)];
    self.navigationItem.rightBarButtonItem = menuItem;
}

- (void)configureLoginButton {
    self.loginButton.delegate = self;
    self.permissions = @[@"public_profile", @"email"];
    self.loginButton.readPermissions = self.permissions;
}

#pragma mark - Helpers

- (void)fetchProfile {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         NSLog(@"%@",result);
         if(error == nil) {
             self.userNameLabel.text = [result valueForKey:@"name"];
         }
     }];
    [self presentListViewController];
}

- (BOOL)checkStatus {
    if ([FBSDKAccessToken currentAccessToken]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        // User is logged in, do work such as go to next view controller.
        return YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return NO;
    }
}

#pragma mark - Navigation

- (void)presentListViewController {
    [self performSegueWithIdentifier:ListsSegueIdentifier sender:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
