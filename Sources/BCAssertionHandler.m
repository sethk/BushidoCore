//
//  BCAssertionHandler.m
//  DealSteal
//
//  Created by Seth Kingsley on 2/4/14.
//
//

#import "BCAssertionHandler.h"

@implementation BCAssertionHandler

+ (void)install
{
	[[[NSThread currentThread] threadDictionary] setObject:[self new]
													forKey:NSAssertionHandlerKey];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (void)handleFailureInFunction:(NSString *)functionName
						   file:(NSString *)fileName
					 lineNumber:(NSInteger)line
					description:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *description = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	NSLog(@"*** Assertion failure '%@' in %@(), %@:%lu", description, functionName, fileName, (u_long)line);
	[NSException raise:NSInternalInconsistencyException format:@"%@", description];
}

- (void)handleFailureInMethod:(SEL)selector
					   object:(id)object
						 file:(NSString *)fileName
				   lineNumber:(NSInteger)line
				  description:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *description = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	NSLog(@"*** Assertion failure '%@' in -[%@ %@], %@:%lu",
		  description,
		  NSStringFromClass([object class]),
		  NSStringFromSelector(selector),
		  fileName,
		  (u_long)line);
	[NSException raise:NSInternalInconsistencyException format:@"%@", description];
}

@end
