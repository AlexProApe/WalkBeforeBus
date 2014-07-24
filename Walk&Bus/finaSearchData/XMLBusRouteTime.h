//
//  XMLBusRouteTime.h
//  finaSearchData
//
//  Created by Wei Zhang on 26/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "busRoutesInfo.h"

@interface XMLBusRouteTime : NSObject<NSXMLParserDelegate>

@property (nonatomic) int routeTime;

-(id) loadXMLByURL:(NSString *)urlString;

@end
