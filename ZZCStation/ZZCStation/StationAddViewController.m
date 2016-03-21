//
//  StationAddViewController.m
//  
//
//  Created by Ray on 16/1/31.
//
//

#import "StationAddViewController.h"
#import "JsonDataRW.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <MapKit/MapKit.h>

@interface StationAddViewController ()
{
    bool isGeoSearch;
}
@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation StationAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _nameTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.stationNameTF.delegate = self;
    self.stationAddressTF.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    [self configStationNameTF];
    [self configStationAddressTF];
    [self configSearchBtn];
    [self configMapView];
    
    [self.view addSubview:self.stationNameTF];
    [self.view addSubview:self.stationAddressTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.mapView];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //[self searchAddressInMap];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    [_mapView setZoomLevel:15.0];
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



#pragma textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 215.0);//iPhone键盘高度216，iPad的为352
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.5f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_stationNameTF resignFirstResponder];
    [_stationAddressTF resignFirstResponder];
}

#pragma action
-(void)save{
    
    if (_stationNameTF.text.length == 0) {
        
        UIAlertView *stationNameString = [[UIAlertView alloc] initWithTitle:@"提示" message:@"站点名称不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [stationNameString show];
        
    }else if (_stationAddressTF.text.length == 0) {
        
        UIAlertView *stationNameString = [[UIAlertView alloc] initWithTitle:@"提示" message:@"站点地址不能为空!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [stationNameString show];
        
    }else{
//        NSString *stationName = [[NSString alloc] init];
//        stationName = self.stationNameTF.text;
        
//        NSString *stationAddress = [[NSString alloc] init];
//        stationAddress = self.stationAddressTF.text;
        
//        UIImage *stationImage = [[UIImage alloc] init];
//        stationImage = _stationImageAdd;
//        if (!_stationImageAdd) {
//            stationImage = [UIImage imageNamed:@"temp"];
//        }        
//        NSData *data =  UIImageJPEGRepresentation(stationImage, 0.9);
//        NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png",stationName];
//        [data writeToFile:[[jsonDataRW getFilePath] stringByAppendingPathComponent:imageName] atomically:YES];
        
        JsonDataRW *jsonDataRW = [[JsonDataRW alloc] init];
        
        NSDictionary *newDic = [[NSDictionary alloc] init];
        newDic = @{@"Name":self.stationNameTF.text,@"Address":self.stationAddressTF.text};
        
        [jsonDataRW jsonDataWrite:newDic];
        
        /**
         *  调用代理方法
         */
        [_delegate reloadWithDic:newDic];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}





- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//根据anntation生成对应的View
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
//        MKMapItem *mapItem=[MKMapItem mapItemForCurrentLocation];
//        [_mapView addAnnotation:mapItem];
        
        _mapView.centerCoordinate = result.location;
        
        _latitude = item.coordinate.latitude;
        _longitude = item.coordinate.longitude;
        
    }
}

-(void)searchAddressInMap{
    isGeoSearch = true;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"北京市";
    //geocodeSearchOption.address = _stationAddressTF.text;
    //geocodeSearchOption.address = @"海淀区供电局";
    if (_stationAddressTF.text.length == 0) {
        NSLog(@"地址为空");
        UIAlertView *messageAV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入站点地址！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [messageAV show];
    }
    else if (_stationAddressTF.text.length >= 1){
        geocodeSearchOption.address = _stationAddressTF.text;
    }
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag) {
        NSLog(@"geo检索发送成功");
    }
    else {
        NSLog(@"geo检索发送失败");
    }
    
}

#pragma configView
-(UITextField *)configStationNameTF{
    if (!_stationNameTF) {
        _stationNameTF = [[UITextField alloc] initWithFrame:CGRectMake(2, 2, self.view.bounds.size.width-60, 30)];
    }
    [_stationNameTF setPlaceholder:@"请输入站点名称"];
    //[_stationNameTF setBackgroundColor:[UIColor grayColor]];
    [_stationNameTF setBorderStyle:UITextBorderStyleRoundedRect];
    [_stationNameTF setClearButtonMode:UITextFieldViewModeAlways];
    
    return _stationNameTF;
}

-(UITextField *)configStationAddressTF{
    if (!_stationAddressTF) {
        _stationAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(2, 2+self.stationNameTF.bounds.size.height+2, self.view.bounds.size.width-60, 30)];
    }
    [_stationAddressTF setPlaceholder:@"请输入站点地址"];
    //[_stationAddressTF setBackgroundColor:[UIColor grayColor]];
    [_stationAddressTF setBorderStyle:UITextBorderStyleRoundedRect];
    [_stationAddressTF setClearButtonMode:UITextFieldViewModeAlways];
    return _stationAddressTF;
}

-(UIButton *)configSearchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        _searchBtn.frame = CGRectMake(self.stationNameTF.bounds.size.width+2+2, 4, self.view.bounds.size.width-self.stationNameTF.bounds.size.width-4-4,56);
        
    }
    [_searchBtn addTarget:self action:@selector(searchAddressInMap) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn setTitle:@"显示" forState:UIControlStateNormal];
    [_searchBtn setShowsTouchWhenHighlighted:YES];
    //[_searchBtn setHighlighted:YES];
    [_searchBtn setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
    //[_searchBtn setBackgroundColor:[UIColor blueColor]];
    [_searchBtn.layer setMasksToBounds:YES];
    [_searchBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [_searchBtn.layer setBorderWidth:2.0]; //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//    [_searchBtn.layer setBorderColor:colorref];//边框颜色

    
    return _searchBtn;
}

-(BMKMapView *)configMapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 32+32+2, self.view.bounds.size.width, self.view.bounds.size.height-64-32-32)];
    }
    return _mapView;
}



@end