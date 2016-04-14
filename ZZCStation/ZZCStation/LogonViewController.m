//
//  LogonViewController.m
//  ZZCStation
//
//  Created by Ray on 16/4/13.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "LogonViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface LogonViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UITextField *rePassWordTF;

@end

@implementation LogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailNameTF.delegate = self;
    self.passWordTF.delegate = self;
    self.rePassWordTF.delegate = self;
    self.navigationItem.title = @"用户注册";
    // Do any additional setup after loading the view.
}
- (IBAction)userLogon:(UIButton *)sender {
    if (self.emailNameTF.text.length == 0) {
        [MBProgressHUD showError:@"邮件地址不能为空" toView:self.view];
        return;
    }
    
    if (self.passWordTF.text.length == 0 ) {
        [MBProgressHUD showError:@"密码不能为空" toView:self.view];
        return;
    }
    
    if (self.rePassWordTF.text.length == 0 ) {
        [MBProgressHUD showError:@"再次输入密码不能为空" toView:self.view];
        return;
    }
    
    NSString *regex = @"[A-Z0-9a-z]{6,20}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:self.passWordTF.text];
    if (!isValid) {
        [MBProgressHUD showError:@"输入6~20位数字、或字母的密码,不支持特殊符号！" toView:self.view];
        return;
    }
    
    if (self.passWordTF.text != self.rePassWordTF.text) {
        [MBProgressHUD showError:@"两次输入密码不一致" toView:self.view];
        return;
    }
    
    if (self.passWordTF.text == self.rePassWordTF.text) {
        [self userLogonInBackground];
    }
    
}

- (void)userLogonInBackground{
    AVUser *user = [AVUser user];
    user.username = self.emailNameTF.text;
    user.password = self.passWordTF.text;
    user.email = self.emailNameTF.text;
    
    __weak typeof (*&self) weakself = self;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"code"] ];
            if ([errorCode isEqualToString:@"125"]) {
                [MBProgressHUD showError:@"邮件地址无效" toView:weakself.view];
            }else {
                [MBProgressHUD showError:[[error userInfo] objectForKey:@"error"] toView:weakself.view];
            }
            
        } else if (succeeded == YES) {
            UIAlertView *logonSucceeded = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"注册成功,请登录邮箱验证后，在此页面登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [logonSucceeded show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"网络异常,请检查网络" toView:weakself.view];
        }
        
    }];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.emailNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
    [self.rePassWordTF resignFirstResponder];
}

//点击右下角或者回车回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
