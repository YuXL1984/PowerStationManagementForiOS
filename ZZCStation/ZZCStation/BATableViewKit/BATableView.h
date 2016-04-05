//
//  ABELTableView.h
//  ABELTableViewDemo
//
//  Created by abel on 14-4-28.
//  Copyright (c) 2014年 abel. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BATableViewDelegate;
@interface BATableView : UIView <UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) id<BATableViewDelegate> delegate;
- (void)reloadData;
- (void)hideFlotage;
//添加的
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
-(void)beginUpdates;
-(void)endUpdates;
@end

@protocol BATableViewDelegate <UITableViewDataSource,UITableViewDelegate>

- (NSArray *)sectionIndexTitlesForABELTableView:(BATableView *)tableView;
- (NSString *)titleString:(NSInteger)section;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com