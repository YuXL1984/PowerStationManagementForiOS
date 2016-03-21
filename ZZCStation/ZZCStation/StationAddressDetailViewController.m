//
//  StationAddressDetailViewController.m
//  
//
//  Created by Ray on 16/1/31.
//
//

#import "StationAddressDetailViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "LocationViewController.h"


@interface StationAddressDetailViewController ()
{
    bool isGeoSearch;
}
@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation StationAddressDetailViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //[_mapView setZoomLevel:14];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"导航预留" style:UIBarButtonItemStyleDone target:self action:@selector(goToNavi)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.title = _nameTitle;
    [self.view addSubview:[self configMapView]];
    [self searchAddressInMap];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    [_mapView setZoomLevel:16.0];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    
    return annotationView;

}

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索BMKGeoCodeSearch结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        
        _latitude = item.coordinate.latitude;
        _longitude = item.coordinate.longitude;
        
    }
}

/**
 *根据地址名称获取地理信息
 *异步函数，返回结果在BMKGeoCodeSearchDelegate的onGetAddrResult通知
 *@param geoCodeOption       geo检索信息类
 *@return 成功返回YES，否则返回NO
 */
-(void)searchAddressInMap{
    isGeoSearch = true;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"北京市";
    geocodeSearchOption.address = _addessTitle;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag) {
        NSLog(@"geo检索发送成功");
    }
    else {
        NSLog(@"geo检索发送失败");
    }
    
}

-(BMKMapView *)configMapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    }
    return _mapView;
}

-(void)goToNavi{
//    NaviViewController *naviVC = [[NaviViewController alloc] init];
//    naviVC.latitude = _latitude;
//    naviVC.longitude = _longitude;
//    naviVC.addessTitle = _addessTitle;
//    [self.navigationController pushViewController:naviVC animated:YES];
    LocationViewController *locationVC = [[LocationViewController alloc] init];
    [self.navigationController pushViewController:locationVC animated:YES];
}

#pragma 地图标注
//- (void) viewDidAppear:(BOOL)animated {
//    // 添加一个PointAnnotation
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
//    annotation.coordinate = coor;
//    annotation.title = _addessTitle;
//    [_mapView addAnnotation:annotation];
//}


@end
