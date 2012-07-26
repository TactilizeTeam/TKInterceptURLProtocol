//
//  TKInterceptURLProtocolDelegate.h
//  TKTestKit
//
//  Created by Arnaud Coomans on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKInterceptURLProtocolDelegate <NSObject>

- (NSData*)responseDataForClient:(id<NSURLProtocolClient>)client request:(NSURLRequest*)request;
@optional
- (BOOL)shouldInitWithRequest:(NSURLRequest*)request;
- (NSInteger)statusCodeForClient:(id<NSURLProtocolClient>)client request:(NSURLRequest*)request;
- (NSDictionary*)headersForClient:(id<NSURLProtocolClient>)client request:(NSURLRequest*)request;

@end
