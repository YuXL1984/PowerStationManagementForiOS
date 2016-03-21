//
//  JsonDataRW.m
//  ZZCDemo
//
//  Created by Ray on 16/1/25.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "JsonDataRW.h"
#import "JSONKit.h"

@implementation JsonDataRW

-(void)jsonDataRead{
    NSError *readJsonStr;
    NSString *getStr = [NSString stringWithContentsOfFile:[self getFilePath] usedEncoding:nil error:&readJsonStr];
    //NSLog(@"getStr : %@",getStr);
    _dataArray = [[NSMutableArray alloc] init];
    [_dataArray addObjectsFromArray:[getStr objectFromJSONString]];

    //NSArray *dataRead = [getStr objectFromJSONString];
    //NSLog(@"%@",_dataArray);
}
-(void)jsonDataWrite:(NSDictionary *)dataDic{
    [self jsonDataRead];
    //[_dataArray addObject:dataDic];
    [_dataArray insertObject:dataDic atIndex:0];
    NSError *error;
    NSString *jsonStr = [_dataArray JSONStringWithOptions:JKSerializeOptionNone error:&error];
    NSError *errorForWrite;
    [jsonStr writeToFile:[self getFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&errorForWrite];
    //NSLog(@"jsonStr:%@",jsonStr);
}

-(void)jsonDataRemove:(NSUInteger *)removeIndex{
    [self jsonDataRead];
    //[_dataArray addObject:dataDic];
    [_dataArray removeObjectAtIndex:*removeIndex];
    NSError *error;
    NSString *jsonStr = [_dataArray JSONStringWithOptions:JKSerializeOptionNone error:&error];
    NSError *errorForWrite;
    [jsonStr writeToFile:[self getFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&errorForWrite];
}

-(NSString *)getFilePath{
    //==Json文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    //NSLog(@"path = %@",path);
    NSString *JsonPath = [path stringByAppendingPathComponent:@"StationsData.json"];
    return JsonPath;
}
@end
