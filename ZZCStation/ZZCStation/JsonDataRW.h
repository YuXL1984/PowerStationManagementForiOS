//
//  JsonDataRW.h
//  ZZCDemo
//
//  Created by Ray on 16/1/25.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JsonDataRW : NSObject

@property(nonatomic,strong) NSMutableArray *dataArray;

-(void)jsonDataRead;
-(void)jsonDataWrite:(NSDictionary *)dataDic;
-(void)jsonDataRemove:(NSUInteger *)removeIndex;
-(NSString *)getFilePath;

@end
