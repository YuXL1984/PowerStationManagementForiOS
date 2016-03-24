//
//  StationAddViewController.h
//  
//
//  Created by Ray on 16/1/31.
//
//

#import <UIKit/UIKit.h>
#import "JsonDataRW.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

//@protocol StationAddViewControllerDelegate <NSObject>
//-(void)reloadWithDic:(NSDictionary *)dic;
//@end

@interface StationAddViewController : UIViewController <UITextFieldDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate>

//@property(nonatomic,weak)id<StationAddViewControllerDelegate>delegate;

@property (strong, nonatomic) UITextField *stationNameTF;
@property (strong, nonatomic) UITextField *stationAddressTF;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)BMKGeoCodeSearch *geocodesearch;
@property(nonatomic,strong)BMKMapView *mapView;
@property (copy,nonatomic) NSString *nameTitle;
@property (copy,nonatomic) NSString *addessTitle;

/**
 * 经度
 */
@property(nonatomic,assign)double latitude;

/**
 *  纬度
 */
@property(nonatomic,assign)double longitude;
@end