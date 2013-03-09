//
//  BCDebugViewController.m
//  BushidoCore
//
//  Created by Seth Kingsley on 2/7/13.
//  Copyright © 2013 Bushido Coding. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "BCDebugViewController.h"

@implementation BCDebugViewController

static NSString * const kNetworkLogLevelDefaultsKey = @"BCDebug_LogLevel_RestKit_Network";
static NSString * const kObjectLogLevelDefaultsKey = @"BCDebug_LogLevel_RestKit_ObjectMapping";
static _RKlcl_level_t kLowLogLevel = RKLogLevelWarning;
static _RKlcl_level_t kHighLogLevel = RKLogLevelTrace;

- (id)_init
{
	if ((self = [super initWithNibName:nil bundle:nil]))
	{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults registerDefaults:@{kNetworkLogLevelDefaultsKey: @(RKLogLevelTrace),
									 kObjectLogLevelDefaultsKey: @(RKLogLevelTrace)}];
		[defaults addObserver:self
				   forKeyPath:kNetworkLogLevelDefaultsKey
					  options:NSKeyValueObservingOptionInitial
					  context:NULL];
		[defaults addObserver:self
				   forKeyPath:kObjectLogLevelDefaultsKey
					  options:NSKeyValueObservingOptionInitial
					  context:NULL];
	}

	return self;
}

+ sharedInstance
{
	static BCDebugViewController *sDebugViewController = nil;
	if (!sDebugViewController)
		sDebugViewController = [[BCDebugViewController alloc] _init];
	return sDebugViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(NSObject *)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (object == [NSUserDefaults standardUserDefaults])
	{
		if ([keyPath isEqualToString:kNetworkLogLevelDefaultsKey])
			RKLogConfigureByName("RestKit/Network*", [[object valueForKey:keyPath] unsignedIntegerValue])
		else if ([keyPath isEqualToString:kObjectLogLevelDefaultsKey])
			RKLogConfigureByName("RestKit/ObjectMapping", [[object valueForKey:keyPath] unsignedIntegerValue])
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[_networkTraceSwitch setOn:((_RKlcl_level_t)[defaults integerForKey:kNetworkLogLevelDefaultsKey] == kHighLogLevel)];
	[_objectTraceSwitch setOn:((_RKlcl_level_t)[defaults integerForKey:kObjectLogLevelDefaultsKey] == kHighLogLevel)];
}

- (IBAction)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:(NSInteger)(([_networkTraceSwitch isOn]) ? kHighLogLevel : kLowLogLevel)
				  forKey:kNetworkLogLevelDefaultsKey];
	[defaults setInteger:(NSInteger)(([_objectTraceSwitch isOn]) ? kHighLogLevel : kLowLogLevel)
				  forKey:kObjectLogLevelDefaultsKey];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
