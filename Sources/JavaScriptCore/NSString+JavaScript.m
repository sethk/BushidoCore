//
//  NSString+JavaScript.m
//  BushidoCore
//
//  Created by Seth Kingsley on 2/3/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import "NSString+JavaScript.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation NSString (JavaScript)

+ stringWithJSString:(JSStringRef)JSString
{
	return [[self alloc] initWithJSString:JSString];
}

+ stringWithJSValue:(JSValueRef)JSValue inContext:(JSContextRef)context
{
	return [[self alloc] initWithJSValue:JSValue inContext:context];
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

+ (NSString *)stringFromJSException:(JSValueRef)exception inContext:(JSContextRef)context
{
	NSString *stringValue = [self stringWithJSValue:exception inContext:context];
	if (JSValueIsObject(context, exception))
	{
		JSObjectRef object = JSValueToObject(context, exception, NULL);
		JSStringRef sourceURLPropertyName = [@"sourceURL" createJSString];
		JSValueRef sourceURLValue = JSObjectGetProperty(context, object, sourceURLPropertyName, NULL);
		JSStringRelease(sourceURLPropertyName);
		JSStringRef linePropertyName = [@"line" createJSString];
		JSValueRef lineValue = JSObjectGetProperty(context, object, linePropertyName, NULL);
		JSStringRelease(linePropertyName);
		stringValue = [NSString stringWithFormat:@"%@:%@: %@",
					   (sourceURLValue) ? [self stringWithJSValue:sourceURLValue inContext:context] : @"(unknown)",
					   (lineValue) ? [self stringWithJSValue:lineValue inContext:context] : @"???",
					   stringValue];
		if (sourceURLValue)
			JSValueUnprotect(context, sourceURLValue);
		if (lineValue)
			JSValueUnprotect(context, lineValue);
	}
	return stringValue;
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
