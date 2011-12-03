//
//  BCURLFormatter.m
//  HTTPFlow
//
//  Created by Seth Kingsley on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//	Based on URLFormatter from http://www.cocoadev.com/index.pl?URLFormatter
//

#import "BCURLFormatter.h"

@implementation BCURLFormatter

// given a string that may be a http URL, try to massage it into an RFC-compliant http URL string
- (NSString *)autoCompletedHTTPStringFromString:(NSString *)URLString
{	
	NSArray *stringParts = [URLString componentsSeparatedByString:@"/"];
	NSString *host = [stringParts objectAtIndex:0];

	if ([host rangeOfString:@"."].location == NSNotFound)
	{ 
		host = [NSString stringWithFormat:@"www.%@.com", host];
		URLString = [host stringByAppendingString:@"/"];
		
		NSArray *pathStrings = [stringParts subarrayWithRange:NSMakeRange(1, [stringParts count] - 1)];
		NSString *filePath = @"";
		if ([pathStrings count])
			filePath = [pathStrings componentsJoinedByString:@"/"];

		URLString = [URLString stringByAppendingString:filePath];
	}

	// see if the newly reconstructed string is a well formed URL
	URLString = [@"http://" stringByAppendingString:URLString];
	URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	return [[NSURL URLWithString:URLString] absoluteString];
}

// given a string that may be a mailto: URL, try to massage it into an RFC-compliant mailto URL string */
- (NSString *)autoCompletedMailToStringFromString:(NSString *)URLString
{
	if (NSNotFound != [URLString rangeOfString:@"/"].location)
		return nil; // there's a slash, it's probably not a mailto URL
	
	NSArray *stringParts = [URLString componentsSeparatedByString:@"@"];
	if ([stringParts count] != 2)
	{	
		stringParts = [URLString componentsSeparatedByString:@" at "];
		if ([stringParts count] != 2)
			return nil; // too few or too many @ symbols
	}
	
	// assume that the front part is an address
	NSString *userAddress = [stringParts objectAtIndex:0];
	
	NSString *mailhost = [stringParts objectAtIndex:1];
	if ([mailhost rangeOfString:@"."].location == NSNotFound)
	{
		// assume a .com address
		mailhost = [NSString stringWithFormat:@"%@.com", mailhost];
	}
	
	// reconstruct the string
	NSString *newAddress = [NSString stringWithFormat:@"mailto:%@@%@", userAddress, mailhost];
	
	// and see if the newly reconstructed string is a well formed URL
	return [[NSURL URLWithString:newAddress] absoluteString];
}


// given a string that may be an URL of some sort, try to massage it into an RFC-compliant http URL string
- (NSURL *)autoCompletedURLFromString:(NSString *)URLString
{
    NSURL *theURL = [NSURL URLWithString:URLString];
	
    if (![[theURL scheme] length])
    {
		// first try just correcting percent escapes
		NSString *newURLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		theURL = [NSURL URLWithString:newURLString];
		
		if (![[theURL scheme] length])
		{	// it still didn;t accept it, try auto-completing
			newURLString = [self autoCompletedMailToStringFromString:URLString];
			if (!newURLString)
				newURLString = [self autoCompletedHTTPStringFromString:URLString];
			
			theURL = [NSURL URLWithString:newURLString];
		}
    }
	
	return theURL;
}

// This method just returns the string - it's here for compatibility with Cocoa Bindings
- (NSString *)editingStringForObjectValue:(id)inObject
{
	return [inObject description];
}

- (NSString *)stringForObjectValue:(id)inObject
{
	NSURL *theURL;
	
    if (![inObject isKindOfClass:[NSURL class]])
	{
		// try to massage an NSURL from a string
		NSString *URLString = [inObject description];
		theURL = [NSURL URLWithString:URLString];
		if (!theURL)
			return nil;
	}
	else
	{	// it is an NSURL
		theURL = inObject;
	}

	return [theURL absoluteString];
}


- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)errorDescription
{
	// Don't attempt to format an empty string.
	if ([string isEqualToString:@""])
	{
		*obj = nil;
		return YES;
	}
	
	NSURL *outURL = [self autoCompletedURLFromString:string];
	*obj = outURL;
	
	if (!outURL)
	{
		*errorDescription = [NSString stringWithFormat:@"Couldn't make  %@ into a well-formed URL", string];
		return NO;
	}

	return YES;
}

@end
