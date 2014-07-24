//
//  XMLBusRouteTime.m
//  finaSearchData
//
//  Created by Wei Zhang on 26/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import "XMLBusRouteTime.h"

@implementation XMLBusRouteTime
@synthesize routeTime=_routeTime;

NSMutableString	*currentNodeContent;
NSXMLParser		*parser;
busRoutesInfo	*currentTweet;
bool            isStatus;
bool            isRight;

-(id) loadXMLByURL:(NSString *)path
{
	NSData	*data   = [[NSData alloc] initWithContentsOfFile:path];
	parser			= [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	[parser parse];
	return self;
}



- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementname isEqualToString:@"JourneyPatternSection"]) {
        NSString *id=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"id"]];
        if ([id isEqualToString:@"JPS_0"]) {
            isRight=NO;
        }
    }
    if ([elementname isEqualToString:@"JourneyPatternSection"]) {
        
        NSString *id=[NSString stringWithFormat:@"%@",[attributeDict objectForKey:@"id"]];
        if ([id isEqualToString:@"JPS_1"]) {
            
            isRight=YES;
        }
    }

    
	if ([elementname isEqualToString:@"JourneyPatternTimingLink"]){
        
        
        currentTweet = [busRoutesInfo alloc];
        isStatus = YES;
    }
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    int runInt = 0;
    if (isRight) {
        if (isStatus)
        {
            
            
            if ([elementname isEqualToString:@"RunTime"])
            {
                //currentTweet.dateCreated = currentNodeContent;
                
                NSString *runTime=[[NSString alloc]init];
                runTime=currentNodeContent;
                NSCharacterSet *nonDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
                runInt=[[runTime stringByTrimmingCharactersInSet:nonDigits]intValue];
                
                _routeTime=_routeTime+runInt;
               // NSLog(@"%d",_routeTime);
                
            }
        }
    }
    

    
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    
}


@end
