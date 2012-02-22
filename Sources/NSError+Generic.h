//
//  NSError+Generic.h
//  DocBrowser
//
//  Created by Seth Kingsley on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Generic)

+ genericErrorWithTitle:(NSString *)title format:(NSString *)format, ...;

@end
