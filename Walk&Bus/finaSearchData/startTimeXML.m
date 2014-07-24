//
//  startTimeXML.m
//  ParsingXMLTutorial
//
//  Created by Wei Zhang on 22/06/2013.
//
//

#import "startTimeXML.h"
#import <Foundation/Foundation.h>


@implementation startTimeXML
@synthesize time=_time;
@synthesize trueStartTime=_trueStartTime;
@synthesize routeTime=_routeTime;

NSMutableString *currentNodeContent;
busDepartureTime *currentTweet;
NSXMLParser *parser;
bool isTime;
bool greaterStartDate;
BOOL shorterEndDate;
bool isWeekdays=NO;
bool isSaturday=NO;
int mins=0;
int seconds=0;
int hours=0;
int endTempDateInt=0;
int tempLargerTime=999999;
NSString *tempClosestTime;
NSString *genueStartTime;



-(id) loadXMLByURL:(NSString *)path{
    
    NSData	*data   = [[NSData alloc] initWithContentsOfFile:path];
	parser			= [[NSXMLParser alloc] initWithData:data];
    
	parser.delegate = self;
	[parser parse];
	return self;
}


//get the route time

-(id)getRouteTime:(int)tempTime{
    _routeTime=tempTime;
    
    return self;
}


//get day of week
-(NSString *)getDayofWeek{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

//remove all the digits but number
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

//get the closest journey time
-(NSString *)closestJourneyTime:(NSString *)time{
    int temp=[self getNumber:time];
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:MM:ss"];
    NSString *date=[formatter stringFromDate:[NSDate date]];
    
    //give it a test
    //int currentTime=[self getNumber:date];
    int currentTime=103000;
    NSString *tempCalculatedTime=[self calculateTheTime:temp];
    int calculatedTime=[tempCalculatedTime intValue];
    //NSLog(@"%d",calculatedTime);
    if (temp>=currentTime) {
        if (temp<=tempLargerTime) {
            tempClosestTime=time;
            tempLargerTime=temp;
        }
    }
    
    else {
        
        if (currentTime<calculatedTime) {
            genueStartTime=time;
        }
    }
    
    
    
    
    return nil;
}

//calculate the time
-(NSString *)calculateTheTime:(int)time{
    mins=0;
    seconds=0;
    hours=0;
    hours=time/10000;
    mins=time/100-hours*100;
    mins=mins+_routeTime;
    if (mins>60) {
        hours=hours+1;
        mins=mins-60;
    }
    NSString *calculatedTime=[[NSString alloc]initWithFormat:@"%02d%02d%02d",hours,mins,seconds];
    
    return calculatedTime;
}


//parse the xml file get the closet start name;

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"VehicleJourneys"]) {
        currentTweet =[busDepartureTime alloc];
        isTime=YES;
    }
    if ([elementName isEqualToString:@"ServicedOrganisations"]||[elementName isEqualToString:@"OperatingPeriod"]) {
        isTime=NO;
    }
}



-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    
    NSString *currentDayofWeek=[self getDayofWeek];
    
    if (isTime) {
        
        NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date=[formatter stringFromDate:[NSDate date]];
        int currentDate=[self getNumber:date];
        
        
        if ([elementName isEqualToString:@"StartDate"]) {
            NSString *temp=currentNodeContent;
            int parsedTime=[self getNumber:temp];
            if (parsedTime<=currentDate) {
                greaterStartDate=YES;
            }else{
                greaterStartDate=NO;
            }
            
        }
        
        if (greaterStartDate==YES) {
            if ([elementName isEqualToString:@"EndDate"]) {
                
                NSString *endTempDateString=currentNodeContent;
                endTempDateInt=[self getNumber:endTempDateString];
                if (endTempDateInt>= currentDate) {
                    shorterEndDate=YES;
                    
                }else{
                    shorterEndDate=NO;
                }
                
            }
        }
        
        
        
        if (shorterEndDate == YES) {
            if ([currentDayofWeek isEqualToString:@"Saturday"]) {
                if ([elementName isEqualToString:@"MondayToSaturday"]) {
                    isSaturday=YES;
                    isWeekdays=NO;
                    
                }
            }else{
                if ([elementName isEqualToString:@"MondayToFriday"]) {
                    isSaturday=NO;
                    isWeekdays=YES;
                    
                }
                
            }
            
        }
        
        if (isSaturday==YES) {
            if ([elementName isEqualToString:@"DepartureTime"]) {
                NSString *journeyDeparture=currentNodeContent;
                [self closestJourneyTime:journeyDeparture];
                
            }
        }
        
        if (isWeekdays==YES) {
            if ([elementName isEqualToString:@"DepartureTime"]) {
                NSString *journeyDeparture=currentNodeContent;
                [self closestJourneyTime:journeyDeparture];
                
            }
        }
    }
}

//return the start time
-(void )returnStartTime{
    if (genueStartTime!=NULL) {
        _trueStartTime=genueStartTime;
        
    }
    else if(tempClosestTime!=NULL&&genueStartTime==NULL){
        _trueStartTime=tempClosestTime;
        
    }
    else{
        _trueStartTime=@"Sorry";
    }
  
    NSLog(@"%@",self.trueStartTime);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self returnStartTime];

}


@end
