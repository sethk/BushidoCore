//
//  NSURL+Query.h
//  BushidoCore
//
//  Created by Seth Kingsley on 7/9/11.
//  Copyright © 2011 Bushido Coding, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Query)

- (NSString *)valueForQueryKey:(NSString *)queryKey;
- (NSDictionary *)queryValues;
- (NSURL *)URLByAddingQueryValues:(NSDictionary *)addQueryValues;
- (NSURL *)URLByDeletingQuery;
- (NSString *)abbreviatedDescription;

@end
