//
//  NSError+CFStreamError.m
//  BushidoCore
//
//  Created by Seth Kingsley on 3/26/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "NSError+CFStreamError.h"
#import <netdb.h>

@implementation NSError (CFStreamError)

// This code taken from public domain code at http://code.google.com/p/cocoaasyncsocket/
+ errorWithCFStreamError:(CFStreamError)streamError
{
	if (streamError.domain == 0 && streamError.error == 0) return nil;

	// Can't use switch; these constants aren't int literals.
	NSString *domain = @"CFStreamError (unlisted domain)";
	NSString *message = nil;

	if (streamError.domain == kCFStreamErrorDomainPOSIX)
		domain = NSPOSIXErrorDomain;
	else if (streamError.domain == kCFStreamErrorDomainMacOSStatus)
		domain = NSOSStatusErrorDomain;
	else if (streamError.domain == kCFStreamErrorDomainMach)
		domain = NSMachErrorDomain;
	else if (streamError.domain == kCFStreamErrorDomainNetDB)
	{
		domain = @"kCFStreamErrorDomainNetDB";
		message = [NSString stringWithCString:gai_strerror(streamError.error) encoding:NSASCIIStringEncoding];
	}
	else if (streamError.domain == kCFStreamErrorDomainNetServices)
		domain = @"kCFStreamErrorDomainNetServices";
	else if (streamError.domain == kCFStreamErrorDomainSOCKS)
		domain = @"kCFStreamErrorDomainSOCKS";
	else if (streamError.domain == kCFStreamErrorDomainSystemConfiguration)
		domain = @"kCFStreamErrorDomainSystemConfiguration";
	else if (streamError.domain == kCFStreamErrorDomainSSL)
		domain = @"kCFStreamErrorDomainSSL";

	NSDictionary *info = nil;
	if (message != nil)
		info = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
	return [NSError errorWithDomain:domain code:streamError.error userInfo:info];
}

@end
