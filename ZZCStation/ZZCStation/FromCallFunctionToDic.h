//
//  FromCallFunctionToDic.h
//  ZZCStation
//
//  Created by Ray on 16/3/29.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FromCallFunctionToDic : NSObject

typedef void (^ResultBlock)(id object, NSError *error);

+(void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)args block:(ResultBlock)resultBlock;

@end
