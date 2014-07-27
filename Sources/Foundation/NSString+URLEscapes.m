//
//  NSString+URLEscapes.m
//  BushidoCore
//
//  Created by Seth Kingsley on 7/16/11.
//  Copyright © 2011 Bushido Coding, Inc. All rights reserved.
//

#import "NSString+URLEscapes.h"
#import <CoreFoundation/CFURL.h>

#ifndef UNIT_TESTS

@implementation NSString (URLEscapes)

- (NSString *)stringByAddingURLEscapes
{
	return [(__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
			(__bridge CFStringRef)self,
			CFSTR(" "),
			CFSTR("!*'();:@&=+$,/?%#[]"),
			kCFStringEncodingUTF8) stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (NSString *)stringByReplacingURLEscapes
{
	return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL,
			(__bridge CFStringRef)[self stringByReplacingOccurrencesOfString:@"+" withString:@" "],
			CFSTR(""));
}

@end

#else // UNIT_TESTS
#import <SenTestingKit/SenTestingKit.h>

@interface NSStringURLEscapesTests : SenTestCase @end
@implementation NSStringURLEscapesTests

- (void)testURLEscapes
{
	STAssertEqualObjects([@"&=" stringByAddingURLEscapes], @"%26%3D", nil);
}

@end
#endif // !UNIT_TESTS
