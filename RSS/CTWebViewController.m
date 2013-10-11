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
        [self.view addSubview:self.webView];
    }
    
    return self;
}

- (void)loadSite:(NSString*)site {
    NSURL *url = [NSURL URLWithString:site];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(self.webView.loading)
        return;
    
    CTAppDelegate *appDelegate = (CTAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController pushViewController:self animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
