//
//  JSONParserForDataEntenties.h
//  Shop
//
//  Created by Matrix Soft on 03.12.12.
//  Copyright (c) 2012 Matrix Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParserForDataEntenties : NSObject

+ (NSDictionary *)parseJSONDataWithData:(NSData *)data;

@end
