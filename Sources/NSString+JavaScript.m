//
//  NSString+JavaScript.m
//  BushidoKit
//
//  Created by Seth Kingsley on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+JavaScript.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation NSString (JavaScript)

+ stringWithJSString:(JSStringRef)JSString
{
	return AUTORELEASE([[self alloc] initWithJSString:JSString]);
}

+ stringWithJSValue:(JSValueRef)JSValue inContext:(JSContextRef)context
{
	return AUTORELEASE([[self alloc] initWithJSValue:JSValue inContext:context]);
}

+ (NSString *)JSONStringFromValue:(JSValueRef)JSValue inContext:(JSContextRef)context
{
	NSString *JSONString;
	JSValueRef exception;
	JSStringRef JSJSONString = JSValueCreateJSONString(context, JSValue, 0, &exception);
	if (JSJSONString)
	{
		JSONString = [self stringWithJSString:JSJSONString];
		JSStringRelease(JSJSONString);
	}
	else
		JSONString = [self stringWithFormat:@"«Error converting JSValue %p into JSON: %@»",
					  JSValue,
					  [self stringWithJSValue:exception inContext:context]];
	return JSONString;
}

- initWithJSString:(JSStringRef)JSString
{
	if (JSString)
		return [self initWithString:(__bridge_transfer NSString *)JSStringCopyCFString(NULL, JSString)];
	else
		return @"((JSStringRef)null)";
}

- initWithJSValue:(JSValueRef)JSValue inContext:(JSContextRef)context
{
	if (JSValue)
	{
		JSValueRef exception;
		JSStringRef JSString = JSValueToStringCopy(context, JSValue, &exception);
		if (JSString)
		{
			self = [self initWithJSString:JSString];
			JSStringRelease(JSString);
			return self;
		}
		else
		{
			return [self initWithFormat:@"«Error converting JSValue %p into JSString: %@»",
					JSValue,
					[NSString JSONStringFromValue:exception inContext:context]];
		}
	}
	else
		return @"((JSValueRef)null)";
}

- (JSStringRef)createJSString
{
	return JSStringCreateWithCFString((__bridge CFStringRef)self);
}

@end
