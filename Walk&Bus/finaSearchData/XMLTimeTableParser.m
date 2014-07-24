//
//  XMLTimeTableParser.m
//  finaSearchData
//
//  Created by Wei Zhang on 25/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import "XMLTimeTableParser.h"

@implementation XMLTimeTableParser
@synthesize busRoute = _busRoute;
@synthesize routeTime=_routeTime;

NSMutableString	*currentNodeContent;
NSString        *journeyStartTime;
NSString        *departureTime;
NSXMLParser		*parser;
NSString  *fromStop;
NSString  *toStop;
busRoutesInfo	*currentTweet;
bool            isStatus;
bool            isFromBusStop;
bool            isToBusStop;
bool            isRight;
int             hour=7;
int             min=3;
int             sec=0;
NSString        *startTime;
int             leftTime;


//load XML File
-(id) loadXMLByURL:(NSString *)path
{
	_busRoute		= [[NSMutableArray alloc]init];
	NSData	*data   = [[NSData alloc] initWithContentsOfFile:path];
	parser			= [[NSXMLParser alloc] initWithData:data];
    
	parser.delegate = self;
	[parser parse];
	return self;
}



//set the start date
-(id)setStartTime:(NSString *)startTimes{
    startTime=startTimes;
    return self;
}


//get the number
-(int) getNumber:(NSString *)originalNumber{
    
    NSMutableString *strippedString=[NSMutableString stringWithCapacity:originalNumber.length];
    NSScanner *scanner =[NSScanner scannerWithString:originalNumber];
    NSCharacterSet *numbers=[NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd]==NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }else{
            [scanner setScanLocation:([scanner scanLocation]+1)];
        }
    }
    return [strippedString intValue];
    
}

//give the min, hour, second a value
-(void) giveTheValueOfTime:(int)tempTime{
    
    hour=tempTime/10000;
    
    min=tempTime/100-hour*100;
}



//parse the XML Files
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    int temp=[self getNumber:startTime];
    [self giveTheValueOfTime:temp];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementname isEqualToString:@"JourneyPatternTimingLink"]){

        currentTweet = [[busRoutesInfo alloc]init];
        isStatus = YES;


    }
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
    if ([elementname isEqualToString:@"From"]) {
        //currentTweet = [[busRoutesInfo alloc]init];

        isFromBusStop=YES;
        isToBusStop=NO;
    }
    if ([elementname isEqualToString:@"To"]) {
       // currentTweet = [[busRoutesInfo alloc]init];

        isToBusStop=YES;
        isFromBusStop=NO;
    }
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    int runInt = 0;
    departureTime=[[NSString alloc]initWithFormat:@"%02d:%02d:%02d",hour,min,sec];

    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:MM:ss"];
    if (isRight) {
        if (isStatus)
        {
            
            
            if (isFromBusStop)
            {
                if ([elementname isEqualToString:@"StopPointRef"]) {
                    fromStop=currentNodeContent;
                    //NSLog(@"%@",fromStop);

                }
                
            }
            if (isToBusStop) {
                if ([elementname isEqualToString:@"StopPointRef"]) {
                    toStop=currentNodeContent;
                    
                }
                
            }
            
            if ([elementname isEqualToString:@"RunTime"])
            {
                //currentTweet.dateCreated = currentNodeContent;
                
                NSString *runTime=[[NSString alloc]init];
                runTime=currentNodeContent;
                NSCharacterSet *nonDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
                runInt=[[runTime stringByTrimmingCharactersInSet:nonDigits]intValue];
                min=min+runInt;
                
                if (min>=60) {
                    min=min-60;
                    hour=hour+1;
                }
                _routeTime=_routeTime+runInt;
                currentTweet.departureTime=departureTime;
                
                //NSLog(@"%@",departureTime);
                
            }
        }
        if ([elementname isEqualToString:@"JourneyPatternTimingLink"])
        {
            
            
            currentTweet.fromStopPoint=fromStop;
            currentTweet.toStopPoint=toStop;
            [self.busRoute addObject:currentTweet];
            currentTweet = nil;
            currentNodeContent = nil;
            
        }

    }

    
                
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    
    
}


@end
