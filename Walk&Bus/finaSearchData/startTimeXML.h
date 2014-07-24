//
//  startTimeXML.h
//  ParsingXMLTutorial
//
//  Created by Wei Zhang on 22/06/2013.
//
//

#import <Foundation/Foundation.h>
#import "busDepartureTime.h"

@interface startTimeXML : NSObject<NSXMLParserDelegate>
@property (strong,readonly)NSMutableArray *time;
@property (strong,nonatomic)NSString *trueStartTime;
@property (nonatomic)int routeTime;

-(id)getRouteTime:(int)tempTime;

-(id) loadXMLByURL:(NSString *)urlString;

@end
