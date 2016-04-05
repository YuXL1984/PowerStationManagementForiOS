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
@property(nonatomic,strong) NSMutableArray *indexArray;
@property(nonatomic,strong) NSMutableArray *letterResultArr;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *searchStationDataArray;
@property(nonatomic,strong) NSString *searchStr;
@end

@implementation StationManagementViewController {
    BATableView *_BAtableview;
    UISearchBar *theSearchBar;
    UISearchDisplayController *searchDisplayController;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:[self configSearchBar]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setUpView];
    //UICollectionView
//    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self setTitle:@"站点管理"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"网络搜索" style:UIBarButtonItemStyleDone target:self action:@selector(searchAction)];
//    self.navigationItem.leftBarButtonItem = leftBtn;

    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self requestStationDataFromBackground];
}

-(void)setUpView{
    _BAtableview = [[BATableView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(theSearchBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-64) ];
    _BAtableview.delegate = self;
    //不显示垂直滚动条
    _BAtableview.tableView.showsVerticalScrollIndicator = NO;
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
    if (tableView == _BAtableview.tableView) {
        return key;
    } else {
        return nil;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _BAtableview.tableView) {
        return [self.letterResultArr count];
    } else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _BAtableview.tableView) {
        return [[self.letterResultArr objectAtIndex:section] count];
    } else
        return self.searchStationDataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (tableView == _BAtableview.tableView) {
        StationDataModel *sdModelForCell = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        cell.textLabel.text = sdModelForCell.stationName;
        cell.detailTextLabel.text = sdModelForCell.stationAddress;
        return cell;
    } else {
        StationDataModel *sdModelForCell = [self.searchStationDataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = sdModelForCell.stationName;
        cell.detailTextLabel.text = sdModelForCell.stationAddress;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lableForHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    lableForHeader.backgroundColor = [UIColor colorWithRed:188/255.0 green:189/255.0 blue:190/255.0 alpha:1];
    
    lableForHeader.text = [NSString stringWithFormat:@"   %@",[self.indexArray objectAtIndex:section]];
    lableForHeader.textColor = [UIColor whiteColor];
    return lableForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationAddressDetailViewController *StationAddressDetailVC = [[StationAddressDetailViewController alloc] init];
    if (tableView == _BAtableview.tableView) {
        StationDataModel *sdModelForSelect = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        StationAddressDetailVC.nameTitle = sdModelForSelect.stationName;
        StationAddressDetailVC.addessTitle = sdModelForSelect.stationAddress;
    } else {
        StationDataModel *sdModelForSelect = self.searchStationDataArray[indexPath.row];
        StationAddressDetailVC.nameTitle = sdModelForSelect.stationName;
        StationAddressDetailVC.addessTitle = sdModelForSelect.stationAddress;
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

//从后台请求所有站点数据并排序处理
-(void)requestStationDataFromBackground{
    
    [FromCallFunctionToDic callFunctionInBackground:@"loadStationData" withParameters:nil block:^(id object, NSError *error) {
        if (error) {
            UIAlertView *loadFunctionError = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从后台获取数据异常！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [loadFunctionError show];
        } else {
            if ([object[@"code"] isEqualToString:@"1000"]) {
                self.powerStationDataArray = [StationDataModel mj_objectArrayWithKeyValuesArray:object[@"resultData"]];
                theSearchBar.placeholder = [NSString stringWithFormat:@"搜索（共%ld个站点）",self.powerStationDataArray.count];
                self.dataArray = [[NSMutableArray alloc] init];
                for (StationDataModel *sdModelForDataArray in self.powerStationDataArray) {
                    [self.dataArray addObject:sdModelForDataArray.stationName];
                }
                
                self.indexArray = [ChineseString IndexArray:self.dataArray];
                
                self.letterResultArr = [ChineseString LetterSortArray:self.dataArray WithModelArray:self.powerStationDataArray];
                
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

        StationDataModel *sdModelForDel = [[StationDataModel alloc] init];
        sdModelForDel = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        NSDictionary *delDic = [[NSDictionary alloc] init];
        delDic = @{@"objectId":sdModelForDel.objectId};
        [FromCallFunctionToDic callFunctionInBackground:@"delStationDataForOid" withParameters:delDic block:^(id object, NSError *error) {
            if (error) {
                UIAlertView *delFunctionError = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从后台获取数据异常！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [delFunctionError show];
            } else {
                if ([object[@"code"] isEqualToString:@"1000"]) {

                    [self.powerStationDataArray removeObject:sdModelForDel];
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

-(UISearchBar *)configSearchBar{
    if (!theSearchBar) {
        theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        theSearchBar.delegate = self;
         //关闭自动校正
        theSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//        theSearchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        theSearchBar.showsScopeBar = YES;
        theSearchBar.keyboardType = UIKeyboardTypeNamePhonePad;
        [theSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [theSearchBar sizeToFit];
        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:theSearchBar contentsController:self];
        searchDisplayController.searchResultsDataSource = self;
        searchDisplayController.searchResultsDelegate = self;
        
        searchDisplayController.delegate = self;
        theSearchBar.scopeButtonTitles = self.indexArray;
    }
    return theSearchBar;
}

#pragma mark-searchBarDelegate
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{

    [self.searchStationDataArray removeAllObjects];

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchStr = searchText;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self searchStationWithName:self.searchStr];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    for(UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
        
        if([subview isKindOfClass:[UILabel class]]) {
            
            [(UILabel*)subview setText:@"请点击键盘上的搜索按钮，开始搜索！"];
            
        }
        
    }
    return YES;
}

//- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
//    
//}
//
//- (void)searchResultsTableShouldChange {
//    
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)sbar {
//    
//}

-(void)searchStationWithName:(NSString *)searchStr {
    NSDictionary *searchDic = @{@"stationName":searchStr};
    [FromCallFunctionToDic callFunctionInBackground:@"searchStationDataForName" withParameters:searchDic block:^(id object, NSError *error) {
        if (error) {
            UIAlertView *searchFunctionError = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从后台获取数据异常！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [searchFunctionError show];
        } else {
            if ([object[@"code"] isEqualToString:@"1000"]) {
                [self.searchStationDataArray removeAllObjects];
                self.searchStationDataArray = [StationDataModel mj_objectArrayWithKeyValuesArray:object[@"resultData"]];
                NSString *searchMessage = [NSString stringWithFormat:@"共有%ld个搜索结果",self.searchStationDataArray.count];
                UIAlertView *searchResultData = [[UIAlertView alloc] initWithTitle:@"提示" message:searchMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [searchResultData show];
                [searchDisplayController.searchResultsTableView reloadData];
            } else {
                UIAlertView *searchError = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [searchError show];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end