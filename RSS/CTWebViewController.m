//
//  CTWebViewController.m
//  RSS
//
//  Created by Forest on 10/10/13.
//  Copyright (c) 2013 Forest. All rights reserved.
//

#import "CTAppDelegate.h"
#import "CTWebViewController.h"

@interface CTWebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation CTWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        self.webView = [[UIWebView alloc] init];
        [self.webView setDelegate:self];
        [self.view addSubview:self.webView];
    }
    
    return self;
}

- (void)dealloc {
    _webView.delegate = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)loadSite:(NSString*)site {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:site];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(self.webView.loading)
        return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
