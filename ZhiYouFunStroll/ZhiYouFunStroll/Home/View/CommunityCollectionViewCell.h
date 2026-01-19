//
//  CommunityCollectionViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/11/25.
//

#import <UIKit/UIKit.h>
#import "HomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *homeImage;
@property (nonatomic,strong) TopLeftLabel *titleL;
@property (nonatomic,strong) UIImageView *avatarImage;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIButton *collectionBut;
@property (nonatomic,strong) UIButton *likeBut;
@property (nonatomic,strong) NSString *titleText;
@property (nonatomic,strong) HomeListRecordModel *model;

@end

NS_ASSUME_NONNULL_END
