//
//  LoginViewController.m
//  ZZCStation
//
//  Created by Ray on 16/4/8.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "LoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "FromCallFunctionToDic.h"
#import "StationManagementViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *eMailName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginButton:(UIButton *)sender forEvent:(UIEvent *)event {
    [self requestUsersDataFromBackground];

}

-(void)requestUsersDataFromBackground{

    [AVUser logInWithUsernameInBackground:self.eMailName.text password:self.passWord.text  block:^(AVUser *user, NSError *error) {

            StationManagementViewController *myVC = [[StationManagementViewController alloc] init];
            [self.navigationController pushViewController:myVC animated:YES];

    }];
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
