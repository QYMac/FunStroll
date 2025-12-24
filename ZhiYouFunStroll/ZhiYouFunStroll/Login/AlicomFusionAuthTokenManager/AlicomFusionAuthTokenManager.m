//
//  AlicomFusionAuthTokenManager.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/17.
//

#import "AlicomFusionAuthTokenManager.h"
#import "AlicomFusionDemoUtil.h"
#import "AFNetworkingManage+Login.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define AlicomColorHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define ALICOM_FUSION_DEMO_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define ALICOM_FUSION_DEMO_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ALICOM_FUSION_DEMO_STATUS_BAR_HEIGHT ([AlicomFusionDemoUtil getDemoStatusBarHeight])

@interface AlicomFusionAuthTokenManager ()<AlicomFusionAuthDelegate,AlicomFusionAuthUIDelegate>

@property (nonatomic,strong) NSString *tokenText;

@end

@implementation AlicomFusionAuthTokenManager

+ (instancetype)shareInstance {
    static AlicomFusionAuthTokenManager *instance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[AlicomFusionAuthTokenManager alloc] init];
        }
    });
    return instance;
}

- (void)oneClickLogin{
    
    if ([self hasSIMCard] == NO) {
        [AlertWith showAlertWithMessageText:@"请插 SIM 卡"];
        return;
    }
    
    [ZSProgressHUD showHUDShowText:@"请稍等..."];
    
    // 快速访问模式
    //[self alicomFusionAuthHandlerToken:DEMO_TEMPORATY_TOKEN];
    //return;
    
    [UserModel sharedUserModel].isAutoLogin = NO;
    
    WeakSelf
    // 正常访问
    [AFNetworkingManage LoginPlatform:@"iOS" success:^(id  _Nonnull responseObject) {
        NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
        NSString *tokenStr = [NSString stringWithFormat:@"%@",dict[@"model"]];
        weakSelf.tokenText = tokenStr;
        [weakSelf alicomFusionAuthHandlerToken:tokenStr];
    } failureHandler:^(NSError * _Nonnull error) {
        [ZSProgressHUD hideAllHUDAnimated:YES];
        [AlertWith showAlertWithMessageText:@"一键登录失败，请尝试其它登录方式"];
    }];
}

// 检测是否有SIM卡
- (BOOL)hasSIMCard{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    if (@available(iOS 12.0, *)) {
        // iOS 12+
        NSDictionary<NSString *, CTCarrier *> *carriers = networkInfo.serviceSubscriberCellularProviders;
        
        if (carriers.count == 0) {
            return NO; // 没有SIM卡
        }
        
        // 遍历所有运营商
        for (CTCarrier *carrier in carriers.allValues) {
            if (carrier.carrierName.length > 0 &&
                ![carrier.carrierName isEqualToString:@"Carrier"]) {
                // && ![carrier.carrierName isEqualToString:@"--"]
                return YES; // 有有效的SIM卡
            }
        }
        return NO;
    } else {
        // iOS 12之前
        CTCarrier *carrier = networkInfo.subscriberCellularProvider;
        
        if (!carrier ||
            carrier.carrierName.length == 0 ||
            [carrier.carrierName isEqualToString:@"Carrier"] ||
            [carrier.carrierName isEqualToString:@"--"]) {
            return NO;
        }
        return YES;
    }
}

- (void)alicomFusionAuthHandlerToken:(NSString *)token{
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        AlicomFusionAuthToken *tokenStr = [[AlicomFusionAuthToken alloc] initWithTokenStr:DEMO_TEMPORATY_TOKEN];
        weakSelf.handler = [[AlicomFusionAuthHandler alloc] initWithToken:tokenStr schemeCode:DEMO_SCHEME_CODE];
        [weakSelf.handler setFusionAuthDelegate:weakSelf];
    });
    
    
}

#pragma mark - AlicomFusionAuthDelegate
/**
 *  认证成功
 *  @note 必选回调
 *  @note 可以使用码号效验maskToken去APP Server做最终验证换取真实手机号码，如果换取手机号失败，可以通过SDK的continue接口继续后续场景流程
 *  @param handler handler
 *  @param maskToken 码号效验token
 */
- (void)onVerifySuccess:(AlicomFusionAuthHandler *)handler
               nodeName:(nonnull NSString *)nodeName
              maskToken:(NSString *)maskToken
                  event:(nonnull AlicomFusionEvent *)event {
    
    NSLog(@"获取到认证token:%@, 请到https://next.api.aliyun.com/api/Dypnsapi/2017-05-25/VerifyWithFusionAuthToken 校验结果，Demo默认校验已成功，流程结束，展示默认手机号码18888888888\n nodeName = %@ ", maskToken,nodeName);
    
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [AFNetworkingManage LoginToken:[CheckTool replaceNullValue:maskToken] success:^(id  _Nonnull responseObject) {
            NSDictionary *dict = [responseObject copy];
            NSDictionary *dict1 = dict[@"verifyWithModel"];
            NSString *phoneNumber = [NSString stringWithFormat:@"APP-OneClick@%@",[CheckTool replaceNullValue:dict1[@"phoneNumber"]]];
            NSString *phoneNumberText = [CheckTool replaceNullValue:dict1[@"phoneNumber"]];
            [AFNetworkingManage LoginMobile:phoneNumber grant_type:@"mobile" scope:@"app-server" success:^(id  _Nonnull responseObject) {
                
                // 储存用户信息
                NSDictionary *dict = [CheckTool replaceNullWithDictionary:responseObject];
                NSString *refresh_token = [CheckTool replaceNullValue:dict[@"refresh_token"]];
                NSString *access_token = [CheckTool replaceNullValue:dict[@"access_token"]];
                NSString *username = [CheckTool replaceNullValue:dict[@"username"]];
                NSString *user_id = [CheckTool replaceNullValue:dict[@"user_id"]];
                NSString *token_type = [CheckTool replaceNullValue:dict[@"token_type"]];
                [UserModel saveObject:refresh_token forKey:kRefreshToken];
                [UserModel saveObject:access_token forKey:kAccessToken];
                [UserModel saveObject:username forKey:kUserName];
                [UserModel saveObject:user_id forKey:kUserId];
                [UserModel saveObject:token_type forKey:kTokenType];
                [UserModel saveObject:phoneNumberText forKey:kPhoneNumber];
                [UserModel sharedUserModel].isAutoLogin = YES;
                
                [weakSelf.handler stopSceneWithTemplateId:LOGIN_TEMPLATEID];
                weakSelf.handler = nil;
                
                if (weakSelf.loginOutclickBlcok) {
                    weakSelf.loginOutclickBlcok();
                }
                
            } failureHandler:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
            
        } failureHandler:^(NSError * _Nonnull error) {
            
        }];
    });

}

/**
 *  认证失败
 *  @note 必选回调
 *  @note 当接收到这个回调的时候表示在场景的某个节点出现了获取token失败的情况，业务方可以根据实际情况决定是否需要执行下一个节点
 *  @param handler handler
 *  @param nodeName 获取token的节点名称
 *  @param error 错误
 */
- (void)onVerifyFailed:(AlicomFusionAuthHandler *)handler
              nodeName:(NSString *)nodeName
                 error:(AlicomFusionEvent *)error{
    [self.handler stopSceneWithTemplateId:LOGIN_TEMPLATEID];
    self.handler = nil;
}

/**
 *  token鉴权失败
 *  @note 必选回调，token初次鉴权失败&token更新后鉴权失败均会触发此回调
 *  @note token鉴权失败后，无法继续使用SDK的功能，请销毁SDK后重新初始化
 *  @param handler handler
 *  @param failToken 错误token
 *  @param error 错误定义
 */
- (void)onSDKTokenAuthFailure:(AlicomFusionAuthHandler *)handler
                    failToken:(AlicomFusionAuthToken *)failToken
                        error:(AlicomFusionEvent *)error {
    NSLog(@"%s，调用:{\n%@}",__func__,error.description);
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZSProgressHUD hideAllHUDAnimated:YES];
        [weakSelf.handler stopSceneWithTemplateId:LOGIN_TEMPLATEID];
        weakSelf.handler = nil;
        [AlertWith showAlertWithMessageText:@"一键登录失败，请尝试其它登录方式"];
    });
}

/**
 *  token鉴权成功
 *  @note 必选回调，token鉴权成功后，才可以调用startScene接口拉起场景
 *  @param handler handler
 */
- (void)onSDKTokenAuthSuccess:(AlicomFusionAuthHandler *)handler {
    NSLog(@"%s，调用",__func__);
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZSProgressHUD hideAllHUDAnimated:YES];
        [weakSelf.handler startSceneUIWithTemplateId:LOGIN_TEMPLATEID viewController:[TabBarViewController takeCurrentVC] delegate:weakSelf];
    });
}

/**
 *  token需要更新
 *  @note 必选回调，handler 初始化&历史token过期前5分钟，会触发此回调，由SDK维护token的生命周期
 *  @param handler handler
 *  @return token，APP更新最新token后，组装AlicomFusionAuthToken返回给到SDK，SDK会通过此token进行鉴权更新
 */
- (AlicomFusionAuthToken *)onSDKTokenUpdate:(AlicomFusionAuthHandler *)handler {
    NSLog(@"%s，调用",__func__);
    AlicomFusionAuthToken *token = [[AlicomFusionAuthToken alloc] initWithTokenStr:[NSString stringWithFormat:@"%@",self.tokenText]];
    return token;
}

/**
 *  填充手机号，用于校验手机号是否和输入的一致，或者重新绑定手机号场景自动填充手机号
 *  @note 必选回调，SDK内置UI部分手机号
 *  @note 比如重置密码场景，需要先填写原手机号码进行第一步效验，SDK需效验该填写值是否为真实的原手机号码，或者重新绑定手机号场景自动填充手机号
 *  @param handler handler
 *  @param event 事件
 *  @return 返回当前用户正在使用的手机号用于下一步操作
 */
- (NSString *)onGetPhoneNumberForVerification:(AlicomFusionAuthHandler *)handler
                                        event:(AlicomFusionEvent *)event{
    NSString *phoneNum = @"";
    return phoneNum;
}

/**
 *  中途认证节点，需要知道中途认证结果，否则影响流程继续执行，目前只有更换手机号的时候第一次验证码会回调
 *  @note 必选回调
 *  @note 可以使用码号效验maskToken去APP Server做最终验证换取真实手机号码，通过resultBlock告知SDK验证结果，如果失败则SDK不进行任何操作，成功则进入下一个节点
 *  @param handler handler
 *  @param nodeName 获取token的节点名称
 *  @param maskToken 码号效验token
 *  @param resultBlock 告知SDK校验结果
 */
- (void)onHalfwayVerifySuccess:(nonnull AlicomFusionAuthHandler *)handler nodeName:(nonnull NSString *)nodeName maskToken:(nonnull NSString *)maskToken event:(nonnull AlicomFusionEvent *)event resultBlock:(nonnull void (^)(BOOL))resultBlock {
    
}

/**
 *  点击协议富文本，返回协议标题以及协议URL，外部需要自定义容器打开该协议
 *  @note 必选回调，SDK协议详情页
 *  @note 一键登录的协议点击，短信验证码的协议点击
 *  @param handler handler
 *  @param protocolName 协议名称
 *  @param protocolUrl 协议URL
 *  @param event 事件
 */
- (void)onProtocolClick:(nonnull AlicomFusionAuthHandler *)handler protocolName:(nonnull NSString *)protocolName protocolUrl:(nonnull NSString *)protocolUrl event:(nonnull AlicomFusionEvent *)event {
    NSLog(@"protocolName:%@\nprotocolUrl:%@",protocolName,protocolUrl);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 跳转网页，显示用户条款
        WKWebViewController *navc = [[WKWebViewController alloc] init];
        navc.titleText = [CheckTool replaceNullValue:protocolName];
        navc.urlStr = [CheckTool replaceNullValue:protocolUrl];
        [[TabBarViewController takeCurrentVC].navigationController pushViewController:navc animated:YES];
    });
}

/**
 *  场景流程结束
 *  @note 必选回调，SDK当前场景流程结束，场景正常结束和异常结束均会触发此回调
 *  @param handler handler
 *  @param event 结束事件
 */
- (void)onTemplateFinish:(nonnull AlicomFusionAuthHandler *)handler event:(nonnull AlicomFusionEvent *)event {
    NSLog(@"认证流程结束");
    [self.handler stopSceneWithTemplateId:LOGIN_TEMPLATEID];
    self.handler = nil;
}


/**
 *  认证中断
 *  @note 必选回调
 *  @note 认证流程临时中断，APP可根据不同事件显示对应的提示信息
 *  @note 触发条件：1. 未勾选隐私协议框，进行认证；2. 验证手机号码输入格式错误，3sdk开始加载某个节点和结束加载某个节点，4、相关的接口可用校验
 *  @param handler handler
 *  @param event 中断原因
 */
- (void)onVerifyInterrupt:(nonnull AlicomFusionAuthHandler *)handler event:(nonnull AlicomFusionEvent *)event {
    
}

#pragma mark - AlicomFusionAuthUIDelegate
- (void)onPhoneNumberVerifyUICustomDefined:(AlicomFusionAuthHandler *)handler
                                templateId:(nonnull NSString *)templateId
                                    nodeId:(NSString *)nodeId
                                   UIModel:(AlicomFusionNumberAuthModel *)model {
    WeakSelf
    weakSelf.authmodel = model;
    model.changeBtnIsHidden = NO;
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.presentDirection = AlicomFusionPresentationDirectionBottom;
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录"];
    model.navColor = AlicomColorHex(0xEFF3F2);
    model.logoIsHidden = YES;
    model.numberColor = AlicomColorHex(0x262626);
    model.numberFont = [UIFont systemFontOfSize:24];
    NSDictionary *loginAttriDict = @{
        NSFontAttributeName: [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName: AlicomColorHex(0xFFFFFF)
    };
    NSMutableAttributedString *loginAttr = [[NSMutableAttributedString alloc] initWithString:@"一键登录" attributes:loginAttriDict];
    model.loginBtnText = loginAttr;
    UIImage *unSelectImage = [AlicomFusionDemoUtil demoImageWithColor:AlicomColorHex(0x0064C8) size:CGSizeMake(ALICOM_FUSION_DEMO_SCREEN_WIDTH - 32, 44) isRoundedCorner:NO radius:0.0];
    UIImage *selectImage = [AlicomFusionDemoUtil demoImageWithColor:AlicomColorHex(0x0064C8) size:CGSizeMake(ALICOM_FUSION_DEMO_SCREEN_WIDTH - 32, 44) isRoundedCorner:NO radius:0.0];
    UIImage *heighLightImage = [AlicomFusionDemoUtil demoImageWithColor:AlicomColorHex(0x0064C8) size:CGSizeMake(ALICOM_FUSION_DEMO_SCREEN_WIDTH - 32, 44) isRoundedCorner:NO radius:0.0];
    model.loginBtnBgImgs = @[unSelectImage, selectImage, heighLightImage];
    
    NSDictionary *sloganAttriDict = @{
        NSFontAttributeName: [UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName: AlicomColorHex(0x555555)
    };
    NSMutableAttributedString *sloganAttr = [[NSMutableAttributedString alloc] initWithString:@"阿里云为您提供认证服务" attributes:sloganAttriDict];
    model.sloganText = sloganAttr;
    model.privacyOperatorIndex = 2;
    model.privacyOne = @[@"用户协议",@"https://terms.alicdn.com/legal-agreement/terms/product/20230213121650869/20230213121650869.html"];
    model.privacyTwo = @[@"个人信息保护政策",@"https://terms.aliyun.com/legal-agreement/terms/suit_bu1_ali_cloud/suit_bu1_ali_cloud202112211045_86198.html?spm=a2c4g.11186623.0.0.72701a9edzzvbz"];
    model.privacyConectTexts = @[@"、",@" 和 "];
    model.privacyPreText = @"我已阅读并同意 ";
    model.privacyOperatorPreText = @"";
    model.privacyOperatorSufText = @"";
    model.privacyColors = @[AlicomColorHex(0x262626), AlicomColorHex(0x262626)];
    model.privacyAlertContentColors = @[AlicomColorHex(0x262626), AlicomColorHex(0x262626)];
    model.privacyFont = [UIFont systemFontOfSize:14];
    model.checkBoxIsHidden = NO;
    model.checkBoxIsChecked = NO;
    model.checkBoxWH = 21;
    model.backgroundColor = AlicomColorHex(0xEFF3F2);
    model.moreLoginActionBlock = ^{
        NSLog(@"其他登录方式");
    };
    
    UIButton *otherLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherLogin setTitle:@"其他手机号登录" forState:UIControlStateNormal];
    otherLogin.backgroundColor = UIColor.whiteColor;
    [otherLogin setTitleColor:AlicomColorHex(0x262626) forState:UIControlStateNormal];
    otherLogin.titleLabel.font = [UIFont systemFontOfSize:16];
    [otherLogin addTarget:weakSelf action:@selector(otherPhoneLoginClick) forControlEvents:UIControlEventTouchUpInside];
    model.otherLoginButton = otherLogin;
    
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGFloat x = (screenSize.width - frame.size.width) * 0.5;
        CGFloat y = screenSize.width>screenSize.height?30:214;
        CGRect rect = CGRectMake(x, y, frame.size.width, frame.size.height);
        return rect;
    };
    
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGFloat y = screenSize.width>screenSize.height?70:252;
        CGRect rect = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
        return rect;
    };
    
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGFloat y = screenSize.width>screenSize.height?104:318;
        CGRect rect = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
        return rect;
    };
    
    model.nameLabelFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return frame;
    };
    
    model.otherLoginButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return frame;
    };
    
    model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGRect rect = CGRectMake(frame.origin.x, screenSize.height - 60 - ALICOM_FUSION_DEMO_STATUS_BAR_HEIGHT - frame.size.height - 34, frame.size.width, frame.size.height);
        return rect;
    };
    
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect nameLabelFrame, CGRect otherLoginBtnFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        
    };
    
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGRect rect = CGRectMake(frame.origin.x, frame.origin.y - 45, frame.size.width, frame.size.height);
        return rect;
    };
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {};
    
    model.privacyAlertIsNeedShow = YES;
    model.privacyAlertIsNeedAutoLogin = YES;
    model.privacyAlertCornerRadiusArray = @[@4, @4, @4, @4];
    model.privacyAlertTitleFont = [UIFont systemFontOfSize:16];
    model.privacyAlertTitleColor = AlicomColorHex(0x262626);
    model.privacyAlertContentFont = [UIFont systemFontOfSize:16];
    model.privacyAlertContentAlignment = NSTextAlignmentCenter;
    model.privacyAlertButtonTextColors = @[AlicomColorHex(0x0064C8), AlicomColorHex(0x0064C8)];
    UIImage *imageUnselect = [AlicomFusionDemoUtil demoImageWithColor:AlicomColorHex(0xFFFFFF) size:CGSizeMake(ALICOM_FUSION_DEMO_SCREEN_WIDTH, 56) isRoundedCorner:NO radius:0.0];
    UIImage *imageSelect = [AlicomFusionDemoUtil demoImageWithColor:AlicomColorHex(0xFFFFFF) size:CGSizeMake(ALICOM_FUSION_DEMO_SCREEN_WIDTH, 56) isRoundedCorner:NO radius:0.0];
    model.privacyAlertBtnBackgroundImages = @[imageUnselect, imageSelect];
    model.privacyAlertButtonFont = [UIFont systemFontOfSize:16];
    model.tapPrivacyAlertMaskCloseAlert = NO;
    model.privacyAlertMaskColor = AlicomColorHex(0x262626);
    model.privacyAlertMaskAlpha = 0.88;
    
    model.privacyAlertFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGRect rect = CGRectMake(27, (superViewSize.height - 200)*0.382, superViewSize.width - 54, 200);
        return rect;
    };
    
    model.privacyAlertTitleFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGRect rect = CGRectMake(0, 32, frame.size.width, frame.size.height);
        return rect;
    };
    
    model.privacyAlertPrivacyContentFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGRect rect = CGRectMake(24, 70, superViewSize.width - 48, frame.size.height);
        return rect;
    };
    
    model.privacyAlertButtonFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGRect rect = CGRectMake(0, superViewSize.height - 56, superViewSize.width, 56);
        return rect;
    };
    
}

/**
 *  短信验证码认证自定义UI
 *  @note 短信验证码界面相关UI修改
 *  @param handler handler
 *  @param templateId 模版id
 *  @param nodeId 节点ID
 *  @param isAutoInput 手机号是否是自动填充
 *  @param view 短信验证码界面view
 */
- (void)onSMSCodeVerifyUICustomDefined:(AlicomFusionAuthHandler *)handler
                            templateId:(NSString *)templateId
                                nodeId:(NSString *)nodeId
                           isAutoInput:(BOOL)isAutoInput
                                  view:(AlicomFusionVerifyCodeView *)view{
    view.privacyTextView.y -= 34;
    view.checkBoxBtn.y -= 34;
    
    NSString *textStr = @"我已阅读并同意 用户协议、个人信息保护政策 和 阿里云融合认证服务条款";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    // 设置部分文字颜色
    NSRange range1 = [textStr rangeOfString:@"用户协议、"];
    if (range1.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName
                                 value:AlicomColorHex(0x0064C8)
                                 range:range1];
    }

    NSRange range2 = [textStr rangeOfString:@"个人信息保护政策"];
    if (range2.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName
                                 value:AlicomColorHex(0x0064C8)
                                 range:range2];
    }
    
    NSRange range3 = [textStr rangeOfString:@"阿里云融合认证服务条款"];
    if (range3.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName
                                 value:AlicomColorHex(0x0064C8)
                                 range:range3];
    }
    
    
    //view.privacyTextView.attributedText= attrStr;
}


- (void)otherPhoneLoginClick {
    [self.authmodel otherPhoneLogin];
}

@end
