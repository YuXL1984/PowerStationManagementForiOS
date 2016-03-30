//
//  FromCallFunctionToDic.m
//  ZZCStation
//
//  Created by Ray on 16/3/29.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "FromCallFunctionToDic.h"
#import <AVOSCloud/AVOSCloud.h>
#import "JSONKit.h"

@implementation FromCallFunctionToDic

+(void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)args block:(ResultBlock)resultBlock{
    
    [AVCloud callFunctionInBackground:function withParameters:args block:^(id object, NSError *error) {
        
        if (error) {
            
            resultBlock(nil,error);
            return ;
        }
        if ([[object class] isSubclassOfClass:[NSString class]])
        {
            resultBlock([object objectFromJSONStringWithParseOptions:JKSerializeOptionEscapeUnicode error:&error], error);
        }
    }];
}

@end
