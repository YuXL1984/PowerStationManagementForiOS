//
//  StationListViewController.h
//  
//
//  Created by Ray on 16/1/31.
//
//

#import <UIKit/UIKit.h>
#import "StationDataModel.h"

@interface StationListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *powerStationDataArray;

@end
