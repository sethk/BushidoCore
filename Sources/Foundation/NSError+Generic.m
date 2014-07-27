//
//  NSError+Generic.m
//  BushidoCore
//
//  Created by Seth Kingsley on 1/25/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "NSError+Generic.h"

@implementation NSError (Generic)

+ genericErrorWithTitle:(NSString *)title format:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *message = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	return [self errorWithDomain:@"Generic Error Domain" code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																   title, NSLocalizedDescriptionKey,
																   message, NSLocalizedRecoverySuggestionErrorKey,
																   nil]];
}

@end
