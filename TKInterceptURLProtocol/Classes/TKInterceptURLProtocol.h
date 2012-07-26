//
//  TKInterceptURLProtocol.h
//
//  Created by Claus Broch on 10/09/11.
//  Copyright 2011 Infinite Loop. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted
//  provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice, this list of conditions 
//    and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice, this list of 
//    conditions and the following disclaimer in the documentation and/or other materials provided 
//    with the distribution.
//  - Neither the name of Infinite Loop nor the names of its contributors may be used to endorse or 
//    promote products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR 
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY 
//  WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TKInterceptURLProtocolDelegate.h"


/** TKInterceptURLProtocol is a class that intercept network requests and return custom responses
 *
 * With this class, two approaches are possible to defined the response to return:
 *
 * - set predefined response data, headers, status code and error to return with _setResponseData:_, _setHeaders:_, _setStatusCode:_, _setError:_
 * - set a TKInterceptURLProtocolDelegate delegate and let him return the corresponding response data, headers, status code and error
 *
 * It is possible to combine the two approaches. For instance, you can set a delegate and predefined headers. If the delegate does not respond to _headersForClient:request:_ or it returns _nil_, TKInterceptURLProtocol will look for the headers predefined with _setHeaders:_
 *
 * _Supported_ methods are used to define which HTTP methods, schemes, base URLs the _TKInterceptURLProtocol_ should answer to. This is done with the _setSupportedMethods:_, _setSupportedSchemes:_, _setSupportedBaseURL:_ methods. Similarily to the methods for predefining response data, the delegate can play an equivalent role with _shouldInitWithRequest:_. 
 *
 * To use, you first need to register the _TKInterceptURLProtocol_ with _NSURLProtocol_:
 * 		[NSURLProtocol registerClass:[TKInterceptURLProtocol class]];
 *
 */

@interface TKInterceptURLProtocol : NSURLProtocol


/** @name Delegate */

/** Set a delegate.
 */
+ (void)setDelegate:(id<TKInterceptURLProtocolDelegate>)delegate;


/** @name Predefined response data */

/** Set the response data to return.
 */
+ (void)setResponseData:(NSData*)data;

/** Set the headers to return.
 */
+ (void)setHeaders:(NSDictionary*)headers;

/** Set a status code to return.
 */
+ (void)setStatusCode:(NSInteger)statusCode;

/** Set an error to return.
 */
+ (void)setError:(NSError*)error;

/** @name Supported requests */

/** Set supported HTTP methods. Only requests with a matching method will get an answer from _TKInterceptURLProtocol_.
 */
+ (void)setSupportedMethods:(NSArray*)methods;

/** Set supported URL schemes. Only requests with a matching schemes will get an answer from _TKInterceptURLProtocol_.
 */
+ (void)setSupportedSchemes:(NSArray*)schemes;

/** Set supported HTTP base URL. Only requests with a matching base URL will get an answer from _TKInterceptURLProtocol_.
 */
+ (void)setSupportedBaseURL:(NSURL*)baseURL;


/** @name Network quality */

//TODO check threading

/** Set a delay in the response returned. This can be used to simulate network latency
 */
+ (void)setResponseDelay:(CGFloat)responseDelay;


@end
