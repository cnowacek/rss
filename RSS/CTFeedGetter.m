//
//  CTFeedGetter.m
//  RSS
//
//  Created by Forest on 10/10/13.
//  Copyright (c) 2013 Forest. All rights reserved.
//

#import "CTFeedGetter.h"

@implementation CTFeedGetter

+(NSArray*)getFeed:(NSString*)str_url {
    NSURL *url = [NSURL URLWithString:str_url];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    
    return @[];
}

@end
