//
//  AppDelegate.m
//  ZZCStation
//
//  Created by Ray on 16/1/31.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "AppDelegate.h"
#import "StationListViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "JSONKit.h"
#import "MJExtension.h"
#import "StationDataModel.h"
#import "StationManagementViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AVOSCloud setApplicationId:@"kUtHLJ5yjfTWngQ6AoispIe0-gzGzoHsz"
                      clientKey:@"1NMjNSW5V1h3SsWXpkdoum6x"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    AVUser * currentUser = [AVUser currentUser];
    if (currentUser &&[currentUser signUp:nil] ) {
        NSLog(@"用户存在");
        if (currentUser.username.length>0) {
            StationManagementViewController *stationManagementVC = [[StationManagementViewController alloc] init];
            self.navigationController = [[UINavigationController alloc] initWithRootViewController:stationManagementVC];

        }
    } else {
        //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserManagement" bundle:[NSBundle mainBundle]];
        //由storyboard根据myView的storyBoardID来获取我们要切换的视图
        LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"login"];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        }
    

    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
//        self.navigationController.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"IZwblfVUGx61FZZNqxWXahEm"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    [self.window addSubview:_navigationController.view];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
