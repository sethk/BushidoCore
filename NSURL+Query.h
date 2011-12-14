//
//  NSURL+Query.h
//  BushidoKit
//
//  Created by Seth Kingsley on 7/9/11.
//  Copyright 2011 Bushido Coding, Inc. All rights reserved.
//

@interface NSURL (Query)

- (NSString *)valueForQueryKey:(NSString *)queryKey;
- (NSDictionary *)queryValues;
- (NSURL *)URLByAddingQueryValues:(NSDictionary *)addQueryValues;
- (NSURL *)URLByDeletingQuery;
- (NSString *)abbreviatedDescription;

@end
