//
//  XMLTimeTableParser.h
//  finaSearchData
//
//  Created by Wei Zhang on 25/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "busRoutesInfo.h"
@interface XMLTimeTableParser : NSObject<NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *busRoute;

@property (nonatomic) int routeTime;

-(id) setStartTime:(NSString *)startTimes;

-(id) loadXMLByURL:(NSString *)urlString;


@end
