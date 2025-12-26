//
//  MapNavigationCollectionViewCell.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/12.
//

#import "MapNavigationCollectionViewCell.h"

@implementation MapNavigationCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.bgView.layer.cornerRadius = 6;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        
        [self.bgView addSubview:self.timeL];
        [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.messageL];
        [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeL.mas_left).offset(0);
            make.right.mas_equalTo(self.timeL.mas_right).offset(0);
            make.top.mas_equalTo(self.timeL.mas_bottom).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        [self.bgView addSubview:self.typeL];
        [self.typeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeL.mas_left).offset(0);
            make.right.mas_equalTo(self.timeL.mas_right).offset(0);
            make.top.mas_equalTo(self.messageL.mas_bottom).offset(0);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

- (void)collectionViewIndexPath:(NSIndexPath *)indexPath dataList:(NSArray *)dataList selectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex == 0) {
        AMapNaviRoute *route = [dataList objectAtIndex:indexPath.row];
        self.timeL.text = [CheckTool replaceNullValue:[NSString formatTimeFromSeconds:route.routeTime]];
        NSString *routeLengthText = [NSString stringWithFormat:@"%ld米",route.routeLength];
        if (route.routeLength >= 1000) {
            routeLengthText = [NSString stringWithFormat:@"%ld公里",route.routeLength/1000];
        }
        if (route.routeTollCost > 0 && route.routeTrafficLightCount > 0) {
            self.messageL.text = [NSString stringWithFormat:@"%@ 🚦%ld ¥%ld",routeLengthText,route.routeTrafficLightCount,route.routeTollCost];
        } else if (route.routeTrafficLightCount > 0) {
            self.messageL.text = [NSString stringWithFormat:@"%@ 🚦%ld",routeLengthText,route.routeTrafficLightCount];
        } else if (route.routeTollCost > 0) {
            self.messageL.text = [NSString stringWithFormat:@"%@ ¥%ld",routeLengthText,route.routeTollCost];
        } else {
            self.messageL.text = [NSString stringWithFormat:@"%@",routeLengthText];
        }
        if (indexPath.row == 0) {
            self.typeL.text = [NSString stringWithFormat:@"方案%ld（推荐）",indexPath.row+1];
        } else {
            self.typeL.text = [NSString stringWithFormat:@"方案%ld",indexPath.row+1];
        }
    } else {
        
    }
}

#pragma mark - 懒加载
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor blackColor];
        _timeL.text = @"25分钟";
        _timeL.font = [UIFont boldSystemFontOfSize:16];
        _timeL.textAlignment = NSTextAlignmentCenter;
    }
    return _timeL;
}

- (UILabel *)messageL{
    if (!_messageL) {
        _messageL = [[UILabel alloc]init];
        _messageL.textColor = [UIColor blackColor];
        _messageL.text = @"15公里 🚦8 ¥10";
        _messageL.font = [UIFont systemFontOfSize:10];
        _messageL.textAlignment = NSTextAlignmentCenter;
    }
    return _messageL;
}

- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.textColor = [UIColor blackColor];
        _typeL.text = @"方案一（推荐）";
        _typeL.font = [UIFont systemFontOfSize:12];
        _typeL.textAlignment = NSTextAlignmentCenter;
    }
    return _typeL;
}


@end
