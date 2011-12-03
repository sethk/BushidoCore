//
//  BCStringDataTransformer.m
//  HTTPFlow
//
//  Created by Seth Kingsley on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BCStringDataTransformer.h"
#import "BCMacros.h"

@implementation BCStringDataTransformer

+ (Class)transformedValueClass
{
	return [NSAttributedString class];
}

- (id)transformedValue:(id)value
{
	if (value)
	{
		NSString *text = AUTORELEASE([[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding]);
		if (!text)
			text = AUTORELEASE([[NSString alloc] initWithData:value encoding:NSASCIIStringEncoding]);
		NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSFont userFixedPitchFontOfSize:11.0]
															   forKey:NSFontAttributeName];
		return AUTORELEASE([[NSAttributedString alloc] initWithString:text attributes:attributes]);
	}
	else
		return @"";
}

@end
