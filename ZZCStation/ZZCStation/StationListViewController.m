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

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件


@interface StationListViewController () <StationAddViewControllerDelegate>

@property(nonatomic,strong)UITableView *stationListVC;
@property (nonatomic,strong)JsonDataRW *jsonDataRW;

@end

@implementation StationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.stationListVC = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    //self.stationListVC.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.view addSubview:self.stationListVC];
    
    [self setTitle:@"站点管理"];
    
    _jsonDataRW = [[JsonDataRW alloc] init];
    [_jsonDataRW jsonDataRead];
    
//    [AVCloud callFunction:@"demo" withParameters:@{@"stationName":@"银河SOHO",@"stationAddress":@"北京市崇文区"}];
    

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
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
    
}

-(void)reloadWithDic:(NSDictionary *)dic
{
    
    [_jsonDataRW.dataArray insertObject:dic atIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stationListVC reloadData];
        
    });
}

//-(void)viewWillAppear:(BOOL)animated{
//    [self.chatTV reloadData];
//}

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
    NSDictionary *tempDic = _jsonDataRW.dataArray[indexPath.row];
    StationAddressDetailVC.nameTitle = [tempDic valueForKey:@"Name"];
    StationAddressDetailVC.addessTitle = [tempDic valueForKey:@"Address"];
    [self.navigationController pushViewController:StationAddressDetailVC animated:YES];
    
}

//滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
//    [_jsonDataRW.dataArray removeObjectAtIndex:row];//_jsonDataRW.dataArray 为当前table中显示的array
    [self.jsonDataRW jsonDataRemove:&row];

    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationLeft];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _jsonDataRW.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //return [UITableViewCell new];
    
    static NSString *cellIdentifier = @"cell";
    
    //TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        //cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *tempDic = _jsonDataRW.dataArray[indexPath.row];
    cell.textLabel.text = [tempDic valueForKey:@"Name"];
    cell.detailTextLabel.text = [tempDic valueForKey:@"Address"];
    return cell;
}





-(void)addAction{
    
    StationAddViewController *stationAddVC = [[StationAddViewController alloc] init];
    stationAddVC.delegate = self;
    [self.navigationController pushViewController:stationAddVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

