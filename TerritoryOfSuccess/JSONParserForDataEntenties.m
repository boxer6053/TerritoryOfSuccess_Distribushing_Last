//
//  JSONParserForDataEntenties.m
//  Shop
//
//  Created by Matrix Soft on 03.12.12.
//  Copyright (c) 2012 Matrix Soft. All rights reserved.
//

#import "JSONParserForDataEntenties.h"

@implementation JSONParserForDataEntenties


//парсинг JSON файла
+ (NSDictionary *)parseJSONDataWithData:(NSData *)data
{
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return allDataDictionary;
}

@end
