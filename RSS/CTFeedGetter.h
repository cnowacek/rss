//
//  CTFeedGetter.h
//  RSS
//
//  Created by Forest on 10/10/13.
//  Copyright (c) 2013 Forest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTFeedGetter : NSObject

+(NSArray*)getFeed:(NSString*)url;

@end
