//
//  XMLParser.h
//  finaSearchData
//
//  Created by Zhang Wei on 10/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "busStopInfo.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *bus;

-(id) loadXMLByURL:(NSString *)urlString;

@end
