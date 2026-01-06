//
//  AddCommentCollectionCell.h
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^addImgButtonBlcok)(NSMutableArray *addImageList);

typedef void(^removeImgButBlcok)(NSMutableArray *addImageList);

@interface AddCommentCollectionCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *commentImg;
@property(nonatomic,strong) UIButton *addImgButton;
@property(nonatomic,copy) UIButton *removeImgBut;

@property(nonatomic,strong) addImgButtonBlcok addImgButtonBlcok;
@property(nonatomic,strong) removeImgButBlcok removeImgButBlcok;

@property (nonatomic,copy) void(^addButClickBlcok)(void);

- (void)AddCommentIndexPath:(NSIndexPath *)indexPath imageList:(NSMutableArray *)imageList;

@end

NS_ASSUME_NONNULL_END
