//
//  CTWebViewController.h
//  RSS
//
//  Created by Forest on 10/10/13.
//  Copyright (c) 2013 Forest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTWebViewController : UIViewController <UIWebViewDelegate>

- (void)loadSite:(NSString*)site;

@end
