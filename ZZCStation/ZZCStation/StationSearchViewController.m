//
//  StationSearchViewController.m
//  ZZCStation
//
//  Created by Ray on 16/3/24.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "StationSearchViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "JSONKit.h"
#import "StationDataModel.h"
#import "MJExtension.h"
#import "FromCallFunctionToDic.h"
#import "StationAddressDetailViewController.h"

@interface StationSearchViewController ()

@property (nonatomic,strong)UITextField *searchTextField;
@property (nonatomic,strong)UIButton *searchBtn;
@property (nonatomic,strong)NSMutableArray *searchStationDataArray;
@property (nonatomic,strong)StationDataModel *sdModel;
@property (nonatomic,strong)UITableView *searchTableView;

@end
@implementation StationSearchViewController

- (void)viewDidLoad {
    
    [self setTitle:@"站点搜索"];
    [self.view addSubview:[self confitSearchTextField]];
    [self.view addSubview:[self configSearchBtn]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchTextField.delegate = self;
}

#pragma tableviewDeleget
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchStationDataArray) {
        return self.searchStationDataArray.count;
    } else {
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //return [UITableViewCell new];
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    StationDataModel *sdModel = self.searchStationDataArray[indexPath.row];
    cell.textLabel.text = sdModel.stationName;
    cell.detailTextLabel.text = sdModel.stationAddress;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StationAddressDetailViewController *StationAddressDetailVC = [[StationAddressDetailViewController alloc] init];
    NSDictionary *tempDic = self.searchStationDataArray[indexPath.row];
    StationAddressDetailVC.nameTitle = [tempDic valueForKey:@"stationName"];
    StationAddressDetailVC.addessTitle = [tempDic valueForKey:@"stationAddress"];
    [self.navigationController pushViewController:StationAddressDetailVC animated:YES];
}

#pragma textFieldDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchTextField resignFirstResponder];
}

//点击右下角或者回车回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    return YES;
}

#pragma configView
-(UITableView *)configSearchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 32, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-32-64-2) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.rowHeight = 50.f;
        _searchTableView.showsVerticalScrollIndicator = NO;
    }
    return _searchTableView;
}

-(UITextField *)confitSearchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, self.view.bounds.size.width-60, 30)];
    }
    [_searchTextField setPlaceholder:@"请输入要搜索的站点名称"];
    [_searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_searchTextField setClearButtonMode:UITextFieldViewModeAlways];
    
    
    return _searchTextField;
}

-(UIButton *)configSearchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchTextField.frame)+2, 2, self.view.bounds.size.width-self.searchTextField.bounds.size.width-4-4,30)];
        [_searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
//        [_searchBtn setBackgroundColor:[UIColor redColor]];
        [_searchBtn setShowsTouchWhenHighlighted:YES];
        //[_searchBtn setHighlighted:YES];
        [_searchBtn setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
        //[_searchBtn setBackgroundColor:[UIColor blueColor]];
        [_searchBtn.layer setMasksToBounds:YES];
        [_searchBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        [_searchBtn.layer setBorderWidth:2.0]; //边框宽度
    }
    return _searchBtn;
}

#pragma event
-(void)searchBtnAction{
//    self.searchTextField.enabled = NO;
    NSDictionary *searchDic = @{@"stationName":self.searchTextField.text};
    [FromCallFunctionToDic callFunctionInBackground:@"searchStationDataForName" withParameters:searchDic block:^(id object, NSError *error) {
        if (error) {
            UIAlertView *searchFunctionError = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从后台获取数据异常！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [searchFunctionError show];
        } else {
            if ([object[@"code"] isEqualToString:@"1000"]) {
                self.searchStationDataArray = [StationDataModel mj_objectArrayWithKeyValuesArray:object[@"resultData"]];
                NSString *searchMessage = [NSString stringWithFormat:@"共有%ld个搜索结果",self.searchStationDataArray.count];
                UIAlertView *searchResultData = [[UIAlertView alloc] initWithTitle:@"提示" message:searchMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [searchResultData show];
                [self.view addSubview:[self configSearchTableView]];
                [self.searchTableView reloadData];
            } else {
                UIAlertView *searchError = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [searchError show];
            }
        }
    }];
}



@end
