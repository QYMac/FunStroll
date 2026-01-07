//
//  AddCommentTableViewCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2026/1/4.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCommentTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *numCommentL;
@property (nonatomic,strong) UIImageView *avatarImage;
@property (nonatomic,strong) UIButton *addBut;
@property (nonatomic,strong) UIButton *expressionBut;
@property (nonatomic,strong) UIButton *addImgBut;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSString *imgURL;
@property (nonatomic,strong) CommentListModel *model;

@end

NS_ASSUME_NONNULL_END
