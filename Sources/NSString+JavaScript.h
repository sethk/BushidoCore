//
//  NSString+JavaScript.h
//  BushidoKit
//
//  Created by Seth Kingsley on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JSBase.h>

@interface NSString (JavaScript)

+ stringWithJSString:(JSStringRef)JSString;
+ stringWithJSValue:(JSValueRef)JSValue inContext:(JSContextRef)context;
+ (NSString *)JSONStringFromValue:(JSValueRef)JSValue inContext:(JSContextRef)context;
- initWithJSString:(JSStringRef)JSString;
- initWithJSValue:(JSValueRef)JSValue inContext:(JSContextRef)context;
- (JSStringRef)createJSString;

@end
