//
//  NSString+Quoted.m
//  BushidoCore
//
//  Created by Seth Kingsley on 4/11/11.
//  Copyright © 2011 Bushido Coding. All rights reserved.
//

#import "NSString+Quoted.h"
#import <wctype.h>
#import <vis.h>

@implementation NSString (Quoted)

- (NSString *)stringByTrimmingWhitesapce
{
	NSUInteger length = self.length, leadingSpace, trailingSpace;

	for (leadingSpace = 0; leadingSpace < length && iswblank([self characterAtIndex:leadingSpace]); ++leadingSpace)
		;
	for (trailingSpace = 0;
			leadingSpace + trailingSpace < length && iswblank([self characterAtIndex:(length - 1) - trailingSpace]);
			++trailingSpace)
		;

	if (!leadingSpace && !trailingSpace)
		return self;
	else
		return [self substringWithRange:NSMakeRange(leadingSpace, length - (leadingSpace + trailingSpace))];
}

- (NSString *)unquotedString
{
	NSUInteger length = self.length;

	if (length >= 2 && [self characterAtIndex:0] == '"' && [self characterAtIndex:length - 1] == '"')
		return [self substringWithRange:NSMakeRange(1, length - 2)];
	else
		return self;
}

- (NSArray *)componentsSeparatedByStringOutsideQuotes:(NSString *)separator
{
	const NSUInteger separatorLength = [separator length];
	NSParameterAssert([separator length]);
	const NSUInteger length = [self length];
	NSMutableArray *components = [NSMutableArray array];
	NSRange currentRange = NSMakeRange(0, NSNotFound);
	if (separatorLength < length)
	{
		BOOL inQuotes = NO;
		unichar firstMatchChar = [separator characterAtIndex:0];
		NSUInteger charIndex = 0;
		while (charIndex < length)
		{
			unichar ch = [self characterAtIndex:charIndex];
			if (ch == '"')
			{
				inQuotes = !inQuotes;
				++charIndex;
			}
			else if (!inQuotes &&
					 charIndex <= length - separatorLength &&
					 ch == firstMatchChar &&
					 [self rangeOfString:separator
								 options:0
								   range:NSMakeRange(charIndex, separatorLength)].location != NSNotFound)
			{
				currentRange.length = charIndex - currentRange.location;
				[components addObject:[self substringWithRange:currentRange]];
				charIndex+= separatorLength;
				currentRange.location = charIndex;
			}
			else
				++charIndex;
		}
	}
	currentRange.length = length - currentRange.location;
	[components addObject:[self substringWithRange:currentRange]];
	return components;
}

- (NSString *)stringByTruncatingToLength:(NSUInteger)length
{
	if ([self length] <= length)
		return self;
	else
		return [NSString stringWithFormat:@"%.*…", length, self];
}

@end

// Fix linker bug with loading categories from static libs:
// http://blog.binaryfinery.com/universal-static-library-problem-in-iphone-sd
@interface String_Quoted_Link_Helper @end
@implementation String_Quoted_Link_Helper -init {return self;} @end
