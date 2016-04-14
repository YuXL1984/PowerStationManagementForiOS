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
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *eMailName;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.eMailName.delegate = self;
    self.passWord.delegate = self;
    self.navigationItem.title = @"用户管理";
    self.navigationItem.hidesBackButton =YES;
}

- (IBAction)loginButton:(UIButton *)sender forEvent:(UIEvent *)event {
    [self requestUsersDataFromBackground];

}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.eMailName resignFirstResponder];
    [self.passWord resignFirstResponder];
}

//点击右下角或者回车回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)requestUsersDataFromBackground{
    __weak typeof (*&self) weakself = self;
    [AVUser logInWithUsernameInBackground:self.eMailName.text password:self.passWord.text  block:^(AVUser *user, NSError *error) {
        if (user) {
            
            [MBProgressHUD showSuccess:@"正在登陆" toView:weakself.view];
            StationManagementViewController *myVC = [[StationManagementViewController alloc] init];
            [self.navigationController pushViewController:myVC animated:YES];
            
        } else if (error){
            NSString *codeStr = [NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"code"]];
            if ([codeStr isEqualToString:@"211"]) {
                [MBProgressHUD showError:@"用户不存在" toView:weakself.view];
            } else if ([codeStr isEqualToString:@"210"]) {
                [MBProgressHUD showError:@"用户名和密码不匹配" toView:weakself.view];
            } else if ([codeStr isEqualToString:@"216"]) {
                [MBProgressHUD showError:@"邮件地址未验证" toView:weakself.view];
            } else {
                UIAlertView *loginError = [[UIAlertView alloc] initWithTitle:@"警告" message:[[error userInfo] objectForKey:@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [loginError show];
            }
        } else {
            [MBProgressHUD showError:@"网络异常,请检查网络" toView:weakself.view];
        }



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
