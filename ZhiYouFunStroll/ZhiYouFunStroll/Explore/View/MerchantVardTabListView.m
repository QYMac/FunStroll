//
//  MerchantVardTabListView.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/27.
//

#import "MerchantVardTabListView.h"
#import "MerchantVardTabListCell.h"

@interface MerchantVardTabListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MerchantVardTabListView

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        self.tableView.layer.cornerRadius = 6;
        self.tableView.layer.masksToBounds = YES;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }
    
    return self;
}

#pragma mark - tableViewDelegate\UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MerchantVardTabListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MerchantVardTabListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

@end
