//
//  StationListViewController.m
//  
//
//  Created by Ray on 16/1/31.
//
//

#import "StationListViewController.h"
#import "StationAddViewController.h"
#import "StationAddressDetailViewController.h"
#import "JsonDataRW.h"
#import "JSONKit.h"
#import "StationDataModel.h"
#import "MJExtension/MJExtension.h"
#import <AVOSCloud/AVOSCloud.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "StationListViewCell.h"

@interface StationListViewController () //<StationAddViewControllerDelegate>

@property (nonatomic,strong)UITableView *stationListVC;
@property (nonatomic,strong)StationListViewCell *cell;

//@property (nonatomic,strong)JsonDataRW *jsonDataRW;

@end

@implementation StationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.stationListVC = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    //self.stationListVC.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.view addSubview:self.stationListVC];
    
    [self setTitle:@"站点管理"];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    //设置行高
    self.stationListVC.rowHeight = 50;
    
    //设置分割线颜色
    //self.chatTV.separatorColor = [UIColor redColor];
    
    //设置分割线样式
    self.stationListVC.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置数据源,如果不设置cell将无数据
    self.stationListVC.dataSource = self;
    
    //设置代理，如果不设置部分设置将无法生效
    self.stationListVC.delegate = self;
    
    //不显示垂直滚动条
    self.stationListVC.showsVerticalScrollIndicator = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self requestStationDataFromBackground];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    //    UIStoryboard *story = [UIStoryboard storyboardWithName:@"DetailViewController" bundle:[NSBundle mainBundle]];
    //    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    //    DetailViewController *detailVC = [story instantiateViewControllerWithIdentifier:@"testId"];
    //
    //    NSDictionary *tempDic = _jsonDataRW.dataArray[indexPath.row];
    //    detailVC.nameTitle = [tempDic valueForKey:@"Name"];
    //    detailVC.addessTitle = [tempDic valueForKey:@"Address"];
    //
    //    //由navigationController推向我们要推向的view
    //    [self.navigationController pushViewController:detailVC animated:YES];
    
    StationAddressDetailViewController *StationAddressDetailVC = [[StationAddressDetailViewController alloc] init];
    NSDictionary *tempDic = self.powerStationDataArray[indexPath.row];
    StationAddressDetailVC.nameTitle = [tempDic valueForKey:@"stationName"];
    StationAddressDetailVC.addessTitle = [tempDic valueForKey:@"stationAddress"];
    [self.navigationController pushViewController:StationAddressDetailVC animated:YES];
    
}

//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        StationDataModel *sdModel = self.powerStationDataArray[indexPath.row];
        NSDictionary *delDic = @{@"objectId":sdModel.objectId};
        [AVCloud callFunctionInBackground:@"delStationDataForOid" withParameters:delDic block:^(id object, NSError *error) {
            NSDictionary *tempDic = [object objectFromJSONStringWithParseOptions:JKSerializeOptionEscapeUnicode error:&error];
            NSLog(@"tempDic = %@",tempDic);
            if ([tempDic[@"code"] isEqualToString:@"1000"]) {
                [self.powerStationDataArray removeObjectAtIndex:indexPath.row];
                [self.stationListVC deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                NSDictionary *resultDataDic = [object objectFromJSONStringWithParseOptions:JKSerializeOptionEscapeUnicode error:&error];
                UIAlertView *alertViewForResultData = [[UIAlertView alloc] initWithTitle:@"提示" message:resultDataDic[@"resultData"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertViewForResultData show];
            } else {
                NSDictionary *errorDic = [object objectFromJSONStringWithParseOptions:JKSerializeOptionEscapeUnicode error:&error];
                UIAlertView *alertViewForError = [[UIAlertView alloc] initWithTitle:@"提示" message:errorDic[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertViewForError show];
            }
        }];
        self.stationListVC.editing = NO;

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return _jsonDataRW.dataArray.count;
    return self.powerStationDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //return [UITableViewCell new];
    
    static NSString *cellIdentifier = @"cell";
    
    //TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        //cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell = [[StationListViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    StationDataModel *sdModel = self.powerStationDataArray[indexPath.row];
    cell.textLabel.text = sdModel.stationName;
    cell.detailTextLabel.text = sdModel.stationAddress;
    
    return cell;
}





-(void)addAction{
    StationAddViewController *stationAddVC = [[StationAddViewController alloc] init];
    [self.navigationController pushViewController:stationAddVC animated:YES];
}

-(void)requestStationDataFromBackground{
    [AVCloud callFunctionInBackground:@"loadStationData" withParameters:nil block:^(id object, NSError *error) {
        if (!error) {
            NSDictionary *tempDic = [object objectFromJSONStringWithParseOptions:JKSerializeOptionEscapeUnicode error:&error];
            if ([[tempDic objectForKey:@"code"] isEqualToString:@"1000"]) {
                NSArray *tempArray = [tempDic objectForKey:@"resultData"];
                self.powerStationDataArray = [StationDataModel mj_objectArrayWithKeyValuesArray:tempArray];
                NSLog(@"powerStationDataArray.count = %ld",self.powerStationDataArray.count);
                [self.stationListVC reloadData];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法正常从后台获取数据！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

