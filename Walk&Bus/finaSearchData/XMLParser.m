//
//  XMLParser.m
//  finaSearchData
//
//  Created by Zhang Wei on 10/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

@implementation XMLParser
@synthesize bus = _bus;


NSMutableString	*currentNodeContent;
NSXMLParser		*parser;
busStopInfo		*currentTweet;
bool            isStatus;

-(id) loadXMLByURL:(NSString *)path
{
	_bus			= [[NSMutableArray alloc] init];
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
	if ([elementname isEqualToString:@"StopPoint"])
	{
		currentTweet = [[busStopInfo alloc]init];
        isStatus = YES;
	}
	if ([elementname isEqualToString:@"StopClassification"])
	{
        isStatus = NO;
	}
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isStatus)
    {
        if ([elementname isEqualToString:@"Landmark"])
        {
            currentTweet.landMark = currentNodeContent;
        }
        if ([elementname isEqualToString:@"CommonName"])
        {
            currentTweet.content = currentNodeContent;
        }
        if ([elementname isEqualToString:@"Longitude"]) {
            currentTweet.longtitude=currentNodeContent;
        }
        if ([elementname isEqualToString:@"Latitude"]) {
            currentTweet.latitude=currentNodeContent;
            
        }
        if ([elementname isEqualToString:@"AtcoCode"]) {
            currentTweet.stopRefNo=currentNodeContent;
            
        }
    }
	if ([elementname isEqualToString:@"StopPoint"])
	{
		[self.bus addObject:currentTweet];
		currentTweet = nil;
		currentNodeContent = nil;
	}
    
    
    
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
}
@end

