//
//  NSURL+Query.m
//  BushidoKit
//
//  Created by Seth Kingsley on 7/9/11.
//  Copyright 2011 Bushido Coding, Inc. All rights reserved.
//

#import "NSURL+Query.h"
#import "NSString+URLEscapes.h"

@implementation NSURL (Query)

- (NSString *)valueForQueryKey:(NSString *)queryKey
{
	NSString *query = [self query];
	NSRange keyRange = [query rangeOfString:queryKey];
	if (keyRange.location != NSNotFound)
	{
		NSUInteger maxRange = NSMaxRange(keyRange);
		if (keyRange.location == 0 || [query characterAtIndex:keyRange.location - 1] == '&')
		{
			NSUInteger queryLength = [query length];
			if (maxRange < queryLength)
			{
				if ([query characterAtIndex:maxRange] == '=')
				{
					NSRange valueRange;
					valueRange.location = maxRange + 1;
					valueRange.length = queryLength - valueRange.location;
					NSUInteger delimiterIndex = [query rangeOfString:@"&" options:0 range:valueRange].location;
					if (delimiterIndex != NSNotFound)
						valueRange.length = delimiterIndex - valueRange.location;
					NSString *value = [query substringWithRange:valueRange];
					return [value stringByReplacingURLEscapes];
				}
				else
					return @"";
			}
		}
	}
	return nil;
}

- (NSDictionary *)queryValues
{
	NSMutableDictionary *queryValues = [NSMutableDictionary dictionary];
	for (NSString *pairString in [[self query] componentsSeparatedByString:@"&"])
	{
		NSArray *pair = [pairString componentsSeparatedByString:@"="];
		NSString *property;
		NSObject *value;
		switch ([pair count])
		{
			default:
				property = [[pair objectAtIndex:0] stringByReplacingURLEscapes];
				value = [[pair objectAtIndex:1] stringByReplacingURLEscapes];
				break;

			case 1:
				property = [pairString stringByReplacingURLEscapes];
				value = [NSNull null];
				break;
		}
		[queryValues setObject:value forKey:property];
	}
	return queryValues;
}

- (NSURL *)URLByAddingQueryValues:(NSDictionary *)addQueryValues
{
	NSString *URLString = [NSString stringWithString:[self relativeString]];
	NSUInteger baseLength = [URLString rangeOfString:@"?"].location;
	if (baseLength != NSNotFound)
		URLString = [URLString substringToIndex:baseLength];
	NSMutableString *queryString = [NSMutableString stringWithString:@"?"];
	BOOL firstProperty = YES;
	NSDictionary *queryValues = [self queryValues];
	[queryValues setValuesForKeysWithDictionary:addQueryValues];
	for (NSString *key in queryValues)
	{
		NSString *value = [queryValues objectForKey:key];
		if (!firstProperty)
			[queryString appendString:@"&"];
		else
			firstProperty = NO;
		if (![value isEqual:[NSNull null]])
			[queryString appendFormat:@"%@=%@",
					[key stringByAddingURLEscapes], [(NSString *)value stringByAddingURLEscapes]];
		else
			[queryString appendString:[key stringByAddingURLEscapes]];
	}
	URLString = [URLString stringByAppendingString:queryString];
	return [NSURL URLWithString:URLString relativeToURL:[self baseURL]];
}

- (NSURL *)URLByDeletingQuery
{
	NSString *URLString = [self relativeString];
	NSRange queryRange = [URLString rangeOfString:@"?"];
	if (queryRange.location != NSNotFound)
	{
		URLString = [URLString substringToIndex:queryRange.location];
		return [NSURL URLWithString:URLString relativeToURL:[self baseURL]];
	}
	else
		return self;
}

- (NSString *)abbreviatedDescription
{
	NSString *URLString = [self absoluteString];
	NSUInteger baseLength = [URLString rangeOfString:@"?"].location;
	if (baseLength != NSNotFound)
	{
		NSMutableString *shortURLString = [NSMutableString stringWithString:[URLString substringToIndex:baseLength]];
		NSString *query = [URLString substringFromIndex:baseLength];
		NSArray *keysAndValues = [query componentsSeparatedByString:@"&"];
		BOOL firstKeyAndValue = YES;
		for (NSString *keyAndValue in keysAndValues)
		{
			if (firstKeyAndValue)
				firstKeyAndValue = NO;
			else
				[shortURLString appendString:@"&"];

			NSArray *pair = [keyAndValue componentsSeparatedByString:@"="];
			switch ([pair count])
			{
				case 2:
				{
					NSString *key = [pair objectAtIndex:0];
					NSString *value = [pair objectAtIndex:1];
					if ([value length])
						value = @"{…}";
					[shortURLString appendFormat:@"%@=%@", key, value];
					break;
				}

				case 1:
					[shortURLString appendString:keyAndValue];
					break;

				case 0:
					break;

				default:
					NSAssert1([pair count] <= 2, @"Invalid keyPair in URL: %@", keyAndValue);
					break;
			}
		}
		return shortURLString;
	}
	else
		return URLString;
}

@end

#ifdef UNIT_TESTS
#import <SenTestingKit/SenTestingKit.h>

@interface NSURLAdditionsTests : SenTestCase @end
@implementation NSURLAdditionsTests

- (void)testExtractValues
{
	NSURL *testURL = [NSURL URLWithString:@"http://www.example.tld/path?foo=first&bar=second&bing&baz=third"];
	STAssertEqualObjects([testURL valueForQueryKey:@"foo"], @"first", nil);
	STAssertEqualObjects([testURL valueForQueryKey:@"bar"], @"second", nil);
	STAssertEqualObjects([testURL valueForQueryKey:@"bing"], @"", nil);
	STAssertEqualObjects([testURL valueForQueryKey:@"baz"], @"third", nil);
	STAssertNil([testURL valueForQueryKey:@"farble"], nil);
}

- (void)testBoundaryExtraction
{
	NSURL *testURL = [NSURL URLWithString:@"http://www.example.tld/path?foo=first&bar="];
	STAssertEqualObjects([testURL valueForQueryKey:@"bar"], @"", nil);
}

- (void)testQueryValues
{
	NSURL *testURL = [NSURL URLWithString:@"http://www.example.tld/path?foo=first&bar=second&bing&baz=third"];
	STAssertEqualObjects([testURL queryValues], ([NSDictionary dictionaryWithObjectsAndKeys:@"first", @"foo",
												 @"second", @"bar",
												 [NSNull null], @"bing",
												 @"third", @"baz",
												 nil]),
						 nil);
}

- (void)testEmptyQuery
{
	NSURL *testURL = [NSURL URLWithString:@"http://www.example.tld/path"];
	STAssertNil([testURL valueForQueryKey:@"foo"], nil);
	STAssertEqualObjects([testURL queryValues], [NSDictionary dictionary], nil);
}

- (void)testAddedQueryValues
{
	NSURL *testURL = [NSURL URLWithString:@"http://www.example.tld/path?foo=first&bar=second&baz=third&other=1"];
	NSURL *newURL = [testURL URLByAddingQueryValues:[NSDictionary dictionaryWithObjectsAndKeys:
																   @"primary", @"foo",
																   @"secondary", @"bar",
																   @"", @"bing",
																   @"tertiary", @"baz",
																   @"test", @"new",
																   nil]];
	STAssertEqualObjects([newURL queryValues], ([NSDictionary dictionaryWithObjectsAndKeys:@"primary", @"foo",
														 @"secondary", @"bar",
														 @"tertiary", @"baz",
														 @"", @"bing",
														 @"test", @"new",
														 @"1", @"other",
														 nil]),
						 nil);
}

- (void)testEscapedSpaces
{
	NSURL *testURL = [NSURL URLWithString:@"http://www.example.tld/callback?fail&error=Sorry%2C+there+was+a+problem."];
	STAssertEqualObjects([testURL valueForQueryKey:@"error"], @"Sorry, there was a problem.", nil);
	STAssertEqualObjects([@"Sorry, there was a problem." stringByAddingURLEscapes], @"Sorry%2C+there+was+a+problem.",
						 nil);
}

- (void)testAbbreviatedDescription
{
	NSURL *testURL = [NSURL URLWithString:@"https://open.login.yahoo.com/openid/op/start?z=BQvIc_UPzI8F6JGzMBUT5JpaCblBN18Yz7o1EziIi1pE9yZPnY7xJb40jKirq6OwLm.WuQge3EyHPGK.w.yg_k7f2rBdwSjnSzyn2.p2MVXd7zSgaTkvp.eLv2sa786u1B5tWByX7RNRhn_o6k.tbcemITjMbQChBaIC0CgVr2wHl8fWOqs7Ln5LQVqdeawemb0nH3Qb0H0Iwl06YvwLHRzgD2AgSz1WfweiSjqWrHWRa3ZIAASCfAGwZgdpNkoKuuBLG8.Fce6fkH.rVXV91HOZsWo8vuLVuetzp9zreg7jbHYHPQStGjwq.s4OHaLRr4iVWbVgLUgIr8I5oSrJhuYKsEIDOcbGDGSQPPqyUXlkDWNnl6JI6L7oGkg6ath4Lp15ytdXEVqx5PWK19xvw3drtx95tsUjgBsLO8quPHidZ5uT2iYmS4Xa_X4MaVpbNq_FAD6UD1X5SD.ZoH4TyH3GqZRi_DtD2cSFadFgpVhs.dLB2DiBzu6t4X3RfNePuy01pQeopBI5FvRyLqFxE4tVN1pf0Sjyrb2Y_lpMpUbLjeKQ8pYIVHARrDQKZvteEeYZwjjhoh7e85rOR9SbGliZlH9na_xAiQZ1tRHEJnfGuz2yS5qXmfvodHjw0aYkI_cIah5cNGyHrzIGfNKJ5C7OJsZE8CNmmZs3tF_MWUK4UZ3BdworY6Z0oyi9UC_lLeD116Jjvfz7CaVAI7uq&.scrumb=I8cKqSvev8w"];
	STAssertEqualObjects([testURL abbreviatedDescription],
			@"https://open.login.yahoo.com/openid/op/start?z={…}&.scrumb={…}",
			nil);
}

@end
#endif // UNIT_TESTS
