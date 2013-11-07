//
//  NSString+JavaScript.h
//  BushidoCore
//
//  Created by Seth Kingsley on 2/3/12.
//  Copyright © 2012 Bushido Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JSBase.h>

@interface NSString (JavaScript)

+ stringWithJSString:(JSStringRef)JSString;
+ stringWithJSValue:(JSValueRef)JSValue inContext:(JSContextRef)context;
+ (NSString *)JSONStringFromValue:(JSValueRef)JSValue inContext:(JSContextRef)context;
+ (NSString *)stringFromJSException:(JSValueRef)exception inContext:(JSContextRef)context;
- initWithJSString:(JSStringRef)JSString;
- initWithJSValue:(JSValueRef)JSValue inContext:(JSContextRef)context;
- (JSStringRef)createJSString;

@end
