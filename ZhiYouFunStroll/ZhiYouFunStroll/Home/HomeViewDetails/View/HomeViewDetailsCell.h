//
//  HomeViewDetailsCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/1.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewDetailsCell : UITableViewCell

@property (nonatomic,strong) UIView *towBgOneView;
@property (nonatomic,strong) UIImageView *avatarImage;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UIButton *numBut;
@property (nonatomic,strong) UIButton *replyBut;
@property (nonatomic,strong) UIButton *likeBut;
@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UIImageView *contentImg;
@property (nonatomic,strong) CommentItem *model;
@property (nonatomic,strong) NSMutableArray *imgList;

@end

NS_ASSUME_NONNULL_END
