//
//  StationListViewCell.m
//  ZZCStation
//
//  Created by Ray on 16/3/22.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "StationListViewCell.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation StationListViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configStationImageView];
        [self configStationNameLable];
        [self configStationAddressLable];
        
        
        
        [self.contentView addSubview:self.stationImageView];
        [self.contentView addSubview:self.stationNameLable];
        [self.contentView addSubview:self.stationAddressLable];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.stationImageView.frame = CGRectMake(5, (self.bounds.size.height-50)/2, 50, 50);
    self.stationNameLable.frame = CGRectMake(self.stationImageView.bounds.size.width+10, (self.bounds.size.height-20)/2, 100, 20);
    self.stationAddressLable.frame = CGRectMake(self.stationImageView.bounds.size.width+10, (self.bounds.size.height+20)/2, 200, 20);
    
    
}

-(UIImageView *)configStationImageView{
    if (!_stationImageView) {
        _stationImageView = [[UIImageView alloc] init];
    }
    return _stationImageView;
}

-(UILabel *)configStationNameLable{
    if (!_stationNameLable) {
        _stationNameLable = [[UILabel alloc] init];
    }
    return _stationNameLable;
}

-(UILabel *)configStationAddressLable{
    if (!_stationAddressLable) {
        _stationAddressLable = [[UILabel alloc] init];
        _stationAddressLable.font = [UIFont systemFontOfSize:14.0f];
        _stationAddressLable.textColor = [UIColor grayColor];
    }
    return _stationAddressLable;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
