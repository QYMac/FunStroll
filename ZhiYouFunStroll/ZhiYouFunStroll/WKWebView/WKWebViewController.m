//
//  WKWebViewController.m
//  ZhiYouFunStroll
//
//  Created by Qingyun Wei on 2025/12/18.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <MessageUI/MessageUI.h>

@interface WKWebViewController ()<WKNavigationDelegate,MFMessageComposeViewControllerDelegate,WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    self.navigationItem.title = [CheckTool replaceNullValue:self.titleText];
    [self setupWebViewUI];
}

- (void)setupWebViewUI{
    
    NSURL *httpURL = [NSURL URLWithString:[CheckTool replaceNullValue:self.urlStr]];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.webView loadRequest:[NSURLRequest requestWithURL:httpURL]];
    self.webView.navigationDelegate = self;
    
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view insertSubview:self.webView atIndex:99];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}

#pragma mark - WKNavigationDelegate
// 开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    NSURL *URL = navigationAction.request.URL;
    
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *iphoneStr = [NSString stringWithFormat:@"telprompt:%@", resourceSpecifier];
        // 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iphoneStr] options:@{} completionHandler:nil];
        });
    }else if([scheme isEqualToString:@"sms"]){
        // 暂时没有用处
        NSString *resourceSpecifier = [URL resourceSpecifier];
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
        // 内容
        vc.body = @"";
        // 收件人列表
        vc.recipients = @[resourceSpecifier];  // 号码数组
        // 颜色
        vc.navigationBar.tintColor = [UIColor whiteColor];
        vc.messageComposeDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(actionPolicy);
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result{
    
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if(result == MessageComposeResultCancelled) {
        [AlertWith showAlertWithMessageText:@"短信已取消"];
    } else if(result == MessageComposeResultSent) {
        [AlertWith showAlertWithMessageText:@"短信已发送"];
    } else {
        [AlertWith showAlertWithMessageText:@"短信发送失败，请检查是否插入 SIM 卡"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIImage * image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(dismissaBtu)];
    self.navigationItem.leftBarButtonItem = backButton;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dismissaBtu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
