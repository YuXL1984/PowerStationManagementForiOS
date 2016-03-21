//
//  StationAddressDetailViewController.h
//  
//
//  Created by Ray on 16/1/31.
//
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface StationAddressDetailViewController : UIViewController <BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>
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

