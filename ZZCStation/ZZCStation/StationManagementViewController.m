//
//  StationManagementViewController.m
//  ZZCStation
//
//  Created by Ray on 16/3/30.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "StationManagementViewController.h"
#import "ChineseString.h"
#import "BATableViewKit/BATableView.h"
#import "StationAddViewController.h"
#import "StationAddressDetailViewController.h"
#import "JsonDataRW.h"
#import "JSONKit.h"
#import "StationDataModel.h"
#import "MJExtension.h"
#import <AVOSCloud/AVOSCloud.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "StationListViewCell.h"
#import "StationSearchViewController.h"
#import "FromCallFunctionToDic.h"
#import "StationListViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface StationManagementViewController ()<BATableViewDelegate>

@property (nonatomic,strong) NSMutableArray *powerStationDataArray;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *searchStationDataArray;

@end

@implementation StationManagementViewController {
    BATableView *_BAtableview;
    UISearchBar *_searchBar;
    StationDataModel *delModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    //UICollectionView
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self setTitle:@"站点管理"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(searchAction)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self requestStationDataFromBackground];
}

-(void)setUpView{
    _BAtableview = [[BATableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ];
    _BAtableview.delegate = self;
    
//    _BAtableview.tableView.delegate = self;
//    _BAtableview.tableView.dataSource = self;
    [self.view addSubview:_BAtableview];
}

#pragma mark - UITableViewDataSource
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
//    return @[
//             @"A",@"B",@"C",@"D",@"E",
//             @"F",@"G",@"H",@"I",@"J",
//             @"K",@"L",@"M",@"N",@"O",
//             @"P",@"Q",@"R",@"S",@"T",
//             @"U",@"V",@"W",@"X",@"Y",
//             @"Z", @"#"
//             ];
    return self.indexArray;
}

- (NSString *)titleString:(NSInteger)section
{
    return  [self.indexArray objectAtIndex:section];
}



#pragma mark - UITableViewDataSource
//
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.indexArray;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.letterResultArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (StationDataModel *forAddress in self.powerStationDataArray) {
        if (forAddress.stationName == [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]) {
            cell.detailTextLabel.text = forAddress.stationAddress;
        }
        
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    lab.backgroundColor = [UIColor colorWithRed:188/255.0 green:189/255.0 blue:190/255.0 alpha:1];
    
    lab.text = [self.indexArray objectAtIndex:section];
    lab.textColor = [UIColor whiteColor];
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationAddressDetailViewController *StationAddressDetailVC = [[StationAddressDetailViewController alloc] init];
    
    NSString *stationName = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    StationAddressDetailVC.nameTitle = stationName;
    for (StationDataModel *forAddress in self.powerStationDataArray) {
        if (forAddress.stationName == [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]) {
             StationAddressDetailVC.addessTitle = forAddress.stationAddress;
        }
    }

    [self.navigationController pushViewController:StationAddressDetailVC animated:YES];
    
}

//-(void)searchAction{
//    StationSearchViewController *stationSearchVC = [[ StationSearchViewController alloc] init];
//    [self.navigationController pushViewController:stationSearchVC animated:YES];
//}

-(void)addAction{
    StationAddViewController *stationAddVC = [[StationAddViewController alloc] init];
    [self.navigationController pushViewController:stationAddVC animated:YES];
}

-(void)requestStationDataFromBackground{
    
    [FromCallFunctionToDic callFunctionInBackground:@"loadStationData" withParameters:nil block:^(id object, NSError *error) {
        if (error) {
            UIAlertView *loadFunctionError = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从后台获取数据异常！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [loadFunctionError show];
        } else {
            if ([object[@"code"] isEqualToString:@"1000"]) {
                self.powerStationDataArray = [StationDataModel mj_objectArrayWithKeyValuesArray:object[@"resultData"]];
                
                self.dataArray = [[NSMutableArray alloc] init];
                for (StationDataModel *sdModelForArr in self.powerStationDataArray) {
                    [self.dataArray addObject:sdModelForArr.stationName];
                }
                
                self.indexArray = [ChineseString IndexArray:self.dataArray];
                
                self.letterResultArr = [ChineseString LetterSortArray:self.dataArray];
                
                [_BAtableview reloadData];
            } else {
                UIAlertView *loadError = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从后台返回数据异常！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [loadError show];
            }
        }
    }];
}



//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        for (StationDataModel *forAddress in self.powerStationDataArray) {
            if (forAddress.stationName == [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]) {
                delModel = forAddress;
            }
        }

        NSDictionary *delDic = [[NSDictionary alloc] init];
        delDic = @{@"objectId":delModel.objectId};
        [FromCallFunctionToDic callFunctionInBackground:@"delStationDataForOid" withParameters:delDic block:^(id object, NSError *error) {
            if (error) {
                UIAlertView *delFunctionError = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从后台获取数据异常！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [delFunctionError show];
            } else {
                if ([object[@"code"] isEqualToString:@"1000"]) {
                    [self.powerStationDataArray removeObject:delModel];
                    
                    if ([[self.letterResultArr objectAtIndex:indexPath.section] count] == 1) {
                        
                        [self.letterResultArr removeObjectAtIndex:indexPath.section];
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                        
                    } else {
                        [[self.letterResultArr objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
                        [_BAtableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                    
                    //[_BAtableview.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                    
                    UIAlertView *delResultData = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"resultData"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [delResultData show];
                } else {
                    UIAlertView *delError = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [delError show];
                    
                }
            }
        }];
        _BAtableview.tableView.editing = NO;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
