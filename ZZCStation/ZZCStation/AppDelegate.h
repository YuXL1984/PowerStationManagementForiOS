//
//  AppDelegate.h
//  ZZCStation
//
//  Created by Ray on 16/1/31.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) BMKMapManager *mapManager;


@end

