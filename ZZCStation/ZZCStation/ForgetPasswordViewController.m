//
//  ForgetPasswordViewController.m
//  ZZCStation
//
//  Created by Ray on 16/4/13.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface ForgetPasswordViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTF;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailAddressTF.delegate = self;
    self.emailAddressTF.autocorrectionType = UITextAutocorrectionTypeNo;

    self.navigationItem.title = @"找回密码";
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailAddressTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)findPassword:(UIButton *)sender {
    __weak typeof (*&self) weakself = self;
    [AVUser requestPasswordResetForEmailInBackground:self.emailAddressTF.text block:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"code"] ];
            if ([errorCode isEqualToString:@"205"]) {
                [MBProgressHUD showError:@"邮件地址未注册" toView:weakself.view];
            } else {
                [MBProgressHUD showError:[[error userInfo] objectForKey:@"error"] toView:weakself.view];
            }
        } else if (succeeded == YES) {
            UIAlertView *succeeded = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请查收邮件，进行密码重置！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [succeeded show];
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
