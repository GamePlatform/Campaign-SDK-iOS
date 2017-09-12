//
//  CampaignViewController.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 11..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "CampaignViewController.h"
#import <WebKit/WebKit.h>

@interface CampaignViewController () <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate> {
    WKWebView *webView;
}

@end

@implementation CampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DLog(@"%@", _info);
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:.3f]];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    // Add a script handler for the "campaign" call. This is added to every frame
    // in the document (window.webkit.messageHandlers.NAME).
    [controller addScriptMessageHandler:self name:@"campaign"];
    [controller addScriptMessageHandler:self name:@"log"];
    [configuration setUserContentController:controller];
    
    webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@", _info[@"template"]] withExtension:@"html"];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    [components setQueryItems:@[[NSURLQueryItem queryItemWithName:@"os" value:@"iOS"],
                                [NSURLQueryItem queryItemWithName:@"img" value:_info[@"url"]]]];
    
    [webView loadRequest:[NSURLRequest requestWithURL:components.URL]];
    [webView setUIDelegate:self];
    
    [self.view addSubview:webView];
    [self setSizeWebView:CGSizeMake(200, 200)];
}

- (void)setFullWebView {
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)setSizeWebView:(CGSize)size {
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [webView addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                             toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:size.width]];
    [webView addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                             toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:size.height]];
    [webView setClipsToBounds:YES];
    [webView.layer setCornerRadius:10.f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"");
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // Check to make sure the name is correct
    if ([message.name isEqualToString:@"campaign"]) {
        // Log out the message received
        NSLog(@"message.body: %@", message.body);
        if ([message.body isKindOfClass:[NSDictionary class]] && [self respondsToSelector:NSSelectorFromString(message.body[@"func"])]) {
            [self performSelector:NSSelectorFromString(message.body[@"func"]) withObject:message.body[@"param"]];
        }
    }
    else if ([message.name isEqualToString:@"log"]) {
        // Log out the message received
        NSLog(@"Received event %@", message.body);
        [webView evaluateJavaScript:@"testEcho('received');" completionHandler:nil];
    }
}

#pragma mark - CallFromWebView

- (void)close:(NSNumber *)noMoreToSee {
    NSLog(@"%@", noMoreToSee);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
