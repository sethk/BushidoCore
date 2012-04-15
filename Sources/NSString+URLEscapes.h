//
//  NSString+URLEscapes.h
//  BushidoCore
//
//  Created by Seth Kingsley on 7/16/11.
//  Copyright 2011 Bushido Coding, Inc. All rights reserved.
//

@interface NSString (URLEscapes)

- (NSString *)stringByAddingURLEscapes;
- (NSString *)stringByReplacingURLEscapes;

@end
