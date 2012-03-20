//
//  BCSettings.m
//  BushidoCore
//
//  Created by Seth Kingsley on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BCSettings.h"
#import <sys/utsname.h>

#if TARGET_OS_IPHONE
@implementation UIDevice (BCSettings)

- (NSString *)modelIdentifier
{
	NSString *model = self.model;

	if ([model isEqualToString:@"iPod Touch"] ||
			[model isEqualToString:@"iPod touch"] ||
			[model isEqualToString:@"iPod"])
	{
		struct utsname u;

		uname(&u);
		if (!strcmp(u.machine, "iPod2,1"))
			return @"iPodTouch2";
		else if (!strcmp(u.machine, "iPod4,1"))
			return @"iPodTouch4";
	}
	else if ([model isEqualToString:@"iPhone Simulator"])
		return @"iPhoneSimulator";
	else if ([model isEqualToString:@"iPhone"])
	{
		struct utsname u;

		uname(&u);
		if (!strcmp(u.machine, "iPhone1,1"))
			return @"iPhone2.5G";
		else if (!strcmp(u.machine, "iPhone1,2"))
			return @"iPhone3G";
		else if (!strcmp(u.machine, "iPhone2,1"))
			return @"iPhone3GS";
		else if (!strcmp(u.machine, "iPhone3,1"))
			return @"iPhone4";
        else if (!strcmp(u.machine, "iPhone3,2"))
            return @"iPhone4S";
	}

	return @"Unknown";
}

@end
#endif // TARGET_OS_IPHONE

@implementation BCSettings

- initWithPListPrefix:(NSString *)plistPrefix
{
	if ((self = [super init]))
	{
#if TARGET_OS_IPHONE
		NSString *modelIdentifier = [[UIDevice currentDevice] modelIdentifier];
#else
		NSString *modelIdentifier = @"Unknown";
#endif // TARGET_OS_IPHONE
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *settingsPath = [bundle pathForResource:plistPrefix ofType:@"plist"];
		NSAssert1(settingsPath, @"%@ missing from bundle", [plistPrefix stringByAppendingPathExtension:@"plist"]);

		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:settingsPath];
		NSString *deviceSettingsPath;

		NSAssert1(settings, @"Could not load %@", settingsPath);
		deviceSettingsPath =
				[bundle pathForResource:[NSString stringWithFormat:@"%@-%@", plistPrefix, modelIdentifier]
								 ofType:@"plist"];
		if ([[NSFileManager defaultManager] fileExistsAtPath:deviceSettingsPath])
			[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:deviceSettingsPath]];

		[[NSUserDefaults standardUserDefaults] registerDefaults:settings];
	}

	return self;
}

- (BOOL)boolForKey:(NSString *)key
{
	char *envstr;

	if ((envstr = getenv(key.UTF8String)))
		return (!strcasecmp(envstr, "YES") || !strcasecmp(envstr, "true") || atoi(envstr));
	else
		return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (double)doubleForKey:(NSString *)key
{
	char *envstr;

	if ((envstr = getenv(key.UTF8String)))
		return atof(envstr);
	else
		return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

- (NSInteger)integerForKey:(NSString *)key
{
	char *envstr;

	if ((envstr = getenv(key.UTF8String)))
		return atoi(envstr);
	else
		return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (NSString *)stringForKey:(NSString *)key
{
	char *envstr;

	if ((envstr = getenv(key.UTF8String)))
		return [NSString stringWithUTF8String:envstr];
	else
		return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

double BCDebugCoefficient = 1.0;

@end
