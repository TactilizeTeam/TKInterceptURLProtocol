//
//  TKInterceptURLProtocolTests.m
//  TactilizeKit
//
//  Created by Arnaud Coomans on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


//TODO urls should use example.com (ietf domain for example purposes)

#import "TKInterceptURLProtocolTests.h"

@implementation TKInterceptURLProtocolTests

- (void)setUp {
	[super setUp];
	
	[NSURLProtocol registerClass:[TKInterceptURLProtocol class]];

	[TKInterceptURLProtocol setDelegate:nil];
	
	[TKInterceptURLProtocol setStatusCode:200];
	[TKInterceptURLProtocol setHeaders:nil];
	[TKInterceptURLProtocol setResponseData:nil];
	[TKInterceptURLProtocol setError:nil];
	
	[TKInterceptURLProtocol setSupportedMethods:nil];
	[TKInterceptURLProtocol setSupportedSchemes:nil];
	[TKInterceptURLProtocol setSupportedBaseURL:nil];
	
	[TKInterceptURLProtocol setResponseDelay:0];
}

- (void)testCanInitWithGETHTTPRequestWithSupportedSchemesAndMethodsNotSet {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TKInterceptURLProtocol setSupportedMethods:nil];
	[TKInterceptURLProtocol setSupportedSchemes:nil];
	
	STAssertTrue([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithGETHTTPRequestWithSupportedSchemesAndMethodsEmpty {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TKInterceptURLProtocol setSupportedMethods:[NSArray array]];
	[TKInterceptURLProtocol setSupportedSchemes:[NSArray array]];
	
	STAssertFalse([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithGETHTTPRequestWithSupportedHTTPSchemesAndGETMethods{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TKInterceptURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"GET"]];
	[TKInterceptURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"http"]];
	
	STAssertTrue([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithPOSTHTTPSRequestWithSupportedHTTPSSchemesAndPOSTMethods{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://example.com"]];
	request.HTTPMethod = @"POST";
	
	[TKInterceptURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"POST"]];
	[TKInterceptURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"https"]];
	
	STAssertTrue([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithPOSTHTTPRequestWithSupportedHTTPSchemesAndGETMethods{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"POST";
	
	[TKInterceptURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"GET"]];
	[TKInterceptURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"http"]];
	
	STAssertFalse([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithGETHTTPRequestWithSupportedHTTPSSchemesAndGETMethods{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	request.HTTPMethod = @"GET";
	
	[TKInterceptURLProtocol setSupportedMethods:[NSArray arrayWithObject:@"GET"]];
	[TKInterceptURLProtocol setSupportedSchemes:[NSArray arrayWithObject:@"https"]];
	
	STAssertFalse([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol does not support a GET HTTP request");
}

- (void)testCanInitWithRequestWithSupportedBaseURL {
	
	NSMutableURLRequest *goodRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testCanInitWithRequestWithSupportedBaseURL"]];
	NSMutableURLRequest *badRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.org"]];
	
	[TKInterceptURLProtocol setSupportedBaseURL:[NSURL URLWithString:@"http://example.com"]];
	
	STAssertTrue([TKInterceptURLProtocol canInitWithRequest:goodRequest], @"TKInterceptURLProtocol does not support a request with base url");
	STAssertFalse([TKInterceptURLProtocol canInitWithRequest:badRequest], @"TKInterceptURLProtocol does not support a request with base url");
}


- (void)testStartLoadingWithoutDelegate {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
	
	id requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
				 [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil], @"array", 
				 @"hello", @"string",
				 nil];
				 
	NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
	[TKInterceptURLProtocol setResponseData:requestData];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	STAssertNotNil(responseObject, @"no canned response from http request");
	STAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");	
}

- (void)testStartLoadingWithDelegate {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testStartLoadingWithDelegate"]];
	
	[TKInterceptURLProtocol setDelegate:self];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	STAssertNotNil(responseObject, @"no canned response from http request");
	STAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
	STAssertTrue([[responseObject objectForKey:@"testName"] isEqual:@"testStartLoadingWithDelegate"], @"wrong canned response");
}

- (void)testAgainStartLoadingWithDelegate {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testAgainStartLoadingWithDelegate"]];
	
	[TKInterceptURLProtocol setDelegate:self];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	STAssertNotNil(responseObject, @"no canned response from http request");
	STAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
	STAssertTrue([[responseObject objectForKey:@"testName"] isEqual:@"testAgainStartLoadingWithDelegate"], @"wrong canned response");
}

- (void)testStartLoadingWithDelegatePlainJSONResponse {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testStartLoadingWithDelegatePlainJSONResponse"]];
	
	[TKInterceptURLProtocol setDelegate:self];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	STAssertNotNil(responseObject, @"no canned response from http request");
	STAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
	STAssertTrue([[responseObject objectForKey:@"testName"] isEqual:@"testStartLoadingWithDelegatePlainJSONResponse"], @"wrong canned response");
}

- (void)testCanInitWithRequestWithDelegateShouldInitWithRequest {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequest"]];
	
	[TKInterceptURLProtocol setDelegate:self];
	
	STAssertTrue([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol delegate returned shouldInitWithRequest NO");
}

- (void)testCanInitWithRequestWithDelegateShouldInitWithRequestNO {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequestNO"]];
	
	[TKInterceptURLProtocol setDelegate:self];
	
	STAssertFalse([TKInterceptURLProtocol canInitWithRequest:request], @"TKInterceptURLProtocol delegate returned shouldInitWithRequest YES");
}


- (void)testSetResponseDelay {
	
	NSDate *date = [NSDate date];
	
	[TKInterceptURLProtocol setResponseDelay:3];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/testSetResponseDelay"]];
	
	id requestObject = [NSDictionary dictionaryWithObjectsAndKeys:
						@"hello", @"string",
						nil];
	NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
	[TKInterceptURLProtocol setResponseData:requestData];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	STAssertNotNil(responseObject, @"no canned response from http request");
	STAssertTrue([responseObject isKindOfClass:[NSDictionary class]], @"canned response has wrong format (not dictionary)");
	STAssertTrue([[responseObject objectForKey:@"string"] isKindOfClass:[NSString class]], @"canned response has wrong format (no string value)");

	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] < 5, @"request was not delayed");
	STAssertTrue([[NSDate date] timeIntervalSinceDate:date] > 2, @"request was delayed for too long");
}







#pragma mark - TKInterceptURLProtocolDelegate

- (NSData*)responseDataForClient:(id<NSURLProtocolClient>)client request:(NSURLRequest*)request {
	
	NSData *requestData = nil;
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testStartLoadingWithDelegate"]) {
		id requestObject = [NSDictionary dictionaryWithObjectsAndKeys:@"testStartLoadingWithDelegate", @"testName", nil];
		requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
	
	}
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testAgainStartLoadingWithDelegate"]) {
		id requestObject = [NSDictionary dictionaryWithObjectsAndKeys:@"testAgainStartLoadingWithDelegate", @"testName", nil];
		requestData = [NSJSONSerialization dataWithJSONObject:requestObject options:0 error:nil];
			
	}
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testStartLoadingWithDelegatePlainJSONResponse"]) {
		requestData = [@"{\"testName\":\"testStartLoadingWithDelegatePlainJSONResponse\"}" dataUsingEncoding:NSUnicodeStringEncoding];
	}
	
	return requestData;
}


- (BOOL)shouldInitWithRequest:(NSURLRequest*)request {
	if ([request.URL.absoluteString isEqual:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequest"]) {
		return YES;
	}
	
	if ([request.URL.absoluteString isEqual:@"http://example.com/testCanInitWithRequestWithDelegateShouldInitWithRequestNO"]) {
		return NO;
	}
	
	return YES;
}


@end
