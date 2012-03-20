//
//  NSString+Quoted.h
//  BushidoCore
//
//  Created by Seth Kingsley on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface NSString (Quoted)

- (NSString *)stringByTrimmingWhitesapce;
- (NSString *)unquotedString;
- (NSArray *)componentsSeparatedByStringOutsideQuotes:(NSString *)separator;
- (NSString *)stringByTruncatingToLength:(NSUInteger)length;

@end

