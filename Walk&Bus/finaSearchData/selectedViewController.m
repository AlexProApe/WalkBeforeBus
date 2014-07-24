//
//  selectedViewController.m
//  finaSearchData
//
//  Created by Zhang Wei on 12/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.

//in order to demonstrate it well, use a fix time and timer
//

#import "selectedViewController.h"
#import "Annotation.h"
#import "scrollNumberView.h"
#import "MDDirectionService.h"
#import <unistd.h>
static const CGFloat kKBPanelMargin = 68.0f;

static const BOOL kKBViewControllerDebug = FALSE;

@interface selectedViewController (){
    //UIAlertView *alert;
    NSInteger hour;
    NSInteger min;
    NSInteger sec;
    int count;
    Annotation *myAnnotation;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D destinationLocation;
    BOOL isSuggested;
    BOOL isUsual;
    BOOL alreadyRoute;
    BOOL isDisplayed;
    BOOL alreadyShows;
    BOOL nextStationSuggested;
    BOOL alreadyPressed;
    int alteredTime;
    int terminalTime;
    BOOL _useAnimations;
    BOOL _useColorsRotate;
    NSArray * _colors;
    NSArray * _colorsBorder;
    NSInteger _colorIndex;
    BOOL walkingTimeIsChanged;
    int timerCount;
    BOOL isMissed;


}
@property (nonatomic, strong) KBPopupBubbleView   * bubble;
@end
#define TAG_NONEPROCEED 3
#define kAllFullSuperviewMask    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
#define TAG_DISSMISS 1
#define TAG_DEV 2
#define TAG_SUGESTION 4

@implementation selectedViewController
@synthesize mapView=_mapView;
@synthesize scrollNumber;
@synthesize scrollNumberViewSec;
@synthesize routeLineView;
@synthesize routeLine;
@synthesize locationManager;
@synthesize pic;
@synthesize popUpBubble;
@synthesize alert;
//system class template
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [self performSelectorOnMainThread:@selector(stopTimer) withObject:nil waitUntilDone:YES];
    
}
-(void)viewDidUnload{
    [self setMapView:nil];
    [self setScrollNumber:nil];
    [super viewDidUnload];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (self.interfaceOrientation !=UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //setup Scolling Number View
    isMissed=NO;
    alreadyRoute=NO;
    alteredTime=0;
    terminalTime=0;
    CGRect tmp = {{0, 0}, {100, 100}};
    scrollNumberViewSec=[[scrollNumberView alloc]init];
    scrollNumber=[[scrollNumberView alloc]init];
    UIImage *image1=[UIImage imageNamed:@"money_bg 2.png"];
    pic=[[UIImageView alloc]initWithImage:image1];
    scrollNumberViewSec.frame=CGRectMake(174, 20, 72, 30);
    scrollNumber.frame=CGRectMake(64, 20, 72, 30);
    pic.frame=CGRectMake(137, 20, 36, 30);
    
    self.scrollNumber.numberSize = 2;
    self.scrollNumberViewSec.numberSize=2;
    
    UIImage *image = [[UIImage imageNamed:@"bj_numbg"]  stretchableImageWithLeftCapWidth:10 topCapHeight:14];
    self.scrollNumber.backgroundView = [[UIImageView alloc] initWithImage:image] ;
    self.scrollNumberViewSec.backgroundView = [[UIImageView alloc] initWithImage:image] ;
    UIView *digitBackView = [[UIView alloc] initWithFrame:tmp] ;
    digitBackView.backgroundColor = [UIColor clearColor];
    digitBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    digitBackView.autoresizesSubviews = YES;
    image = [[UIImage imageNamed:@"money_bg"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image] ;
    bgImageView.frame = tmp;
    bgImageView.autoresizingMask = kAllFullSuperviewMask;
    [digitBackView addSubview:bgImageView];
    image = [[UIImage imageNamed:@"money_bg_mask"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImageView *bgMaskImageView = [[UIImageView alloc] initWithImage:image] ;
    bgMaskImageView.autoresizingMask = kAllFullSuperviewMask;
    bgMaskImageView.frame = tmp;
    [digitBackView addSubview:bgMaskImageView];
    
    self.scrollNumber.digitBackgroundView = digitBackView;
    self.scrollNumber.digitColor = [UIColor whiteColor];
    self.scrollNumber.digitFont = [UIFont systemFontOfSize:17.0];
    [self.scrollNumber didConfigFinish];
    self.scrollNumberViewSec.digitBackgroundView=digitBackView;
    self.scrollNumberViewSec.digitColor=[UIColor whiteColor];
    self.scrollNumberViewSec.digitFont=[UIFont systemFontOfSize:17.0];
    [self.scrollNumberViewSec didConfigFinish];
    
    
    //end Setup
    
    
    
    
    CLLocationCoordinate2D center;
    center.latitude=[self.latitude doubleValue];
    center.longitude=[self.longitude doubleValue];
    //annotation related code
    
    CLLocationCoordinate2D wimbLocation;
    wimbLocation.latitude=[self.latitude doubleValue];
    wimbLocation.longitude=[self.longitude doubleValue];
    
    myAnnotation=[[Annotation alloc]init];
    myAnnotation.coordinate =wimbLocation;
    myAnnotation.title=self.busStopName;
    myAnnotation.subtitle=@"Your Destination";
    
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startTimer) userInfo: nil repeats:YES];
    ViewController *verify= [[ViewController alloc]init];
    if ([self.displayDipartureTime isEqualToString:@"Sorry"]||verify.isMissedLastBus==YES) {
        
        alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sorry You Have Missed The Last Bus" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil];
        [alert show];
        alert.tag=TAG_DISSMISS;
        
    }
    
    // self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Route" style:UIBarButtonItemStylePlain  target:self action:@selector(drawTestLine)];
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Route" style:UIBarButtonItemStylePlain  target:self action:@selector(drawARoute)];
    UIBarButtonItem *routeButton=[[UIBarButtonItem alloc]initWithTitle:@"Route" style:UIBarButtonItemStylePlain target:self action:@selector(drawARoute)];
    UIBarButtonItem *turnByTurn=[[UIBarButtonItem alloc]initWithTitle:@"Turn by Turn" style:UIBarButtonItemStylePlain target:self action:@selector(drawTestLine)];
    self.navigationItem.rightBarButtonItems=@[turnByTurn,/* fixedSpaceBarButtonItem, */routeButton];
    
    hour=10;
    min=30;
    sec=0;
    
    //initialize a google map
    mapViewOnScreen=[[UIView alloc]init];
    mapViewOnScreen.frame=CGRectMake(0, 20, 320, 548);
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:center zoom:15];
    _mapView =[GMSMapView mapWithFrame:mapViewOnScreen.bounds camera:camera];
    _mapView.myLocationEnabled=YES;
    mapViewOnScreen=_mapView;
    [self.view addSubview:_mapView];
    [self.view addSubview:scrollNumberViewSec];
    [self.view addSubview:scrollNumber];
    [self.view addSubview:pic];
    [self.view addSubview:alert];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    [self getCurrentLocation];
    
    
    //NSLog(@"%f",[self getCurrentLocation].latitude);
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    [self deliverToTheDirectionService:center stopName:self.busStopName];
    
    
    
    //popBubble

    _useAnimations = TRUE;
    _useColorsRotate = TRUE;
    _colors = [NSArray arrayWithObjects:
               [UIColor colorWithRed:0.95f green:0.0f blue:0.0f alpha:1.0f],
               [UIColor colorWithRed:0.0f green:0.95f blue:0.0f alpha:1.0f],
               [UIColor colorWithRed:0.0f green:0.0f blue:0.95f alpha:1.0f],
               [UIColor colorWithRed:0.95f green:0.0f blue:0.95f alpha:1.0f],
               [UIColor colorWithRed:0.0f green:0.95f blue:0.95f alpha:1.0f],
               [UIColor colorWithRed:0.9f green:0.9f blue:0.0f alpha:1.0f],
               nil];
    _colorsBorder = [NSArray arrayWithObjects:
                     [UIColor colorWithRed:0.55f green:0.0f blue:0.0f alpha:1.0f],
                     [UIColor colorWithRed:0.0f green:0.55f blue:0.0f alpha:1.0f],
                     [UIColor colorWithRed:0.0f green:0.0f blue:0.55f alpha:1.0f],
                     [UIColor colorWithRed:0.55f green:0.0f blue:0.55f alpha:1.0f],
                     [UIColor colorWithRed:0.0f green:0.55f blue:0.55f alpha:1.0f],
                     [UIColor colorWithRed:0.55f green:0.55f blue:0.0f alpha:1.0f],
                     nil];
    _colorIndex = _colors.count - 1;

    //
 
    CGPoint show=CGPointMake(155, 115);
    NSString *texts=[[NSString alloc]initWithFormat:@"time until next bus show up"];
    [self drawBubble:show position:@"top" pointer:@"left" text:texts color:@"red"];
    timerCount=0;
    
    
    
    
}
//end








//bubble display
- (void)drawBubble:(CGPoint)center position:(NSString*)side pointer:(NSString *)pointer text:(NSString *)texts color:(NSString*)color {
    // Hide the bubble if its there
    if ( self.bubble != nil ) {
        [self.bubble hide:_useAnimations];
        self.bubble = nil;
    }
    // Display the new view
    self.bubble = [[KBPopupBubbleView alloc] initWithCenter:center];
    [self configure:self.bubble side:side pointer:pointer text:texts color:color];
    [self.bubble showInView:self.view animated:_useAnimations];
    
    }

- (void)configure:(KBPopupBubbleView *)bubble side:(NSString *  )side pointer:(NSString *)pointer text:(NSString *)text color:(NSString *)color {
    // Text
    bubble.label.text = text;
    bubble.label.textColor = [UIColor whiteColor];
    bubble.label.font = [UIFont boldSystemFontOfSize:13.0f];
    bubble.delegate = self;
    
    // Shadows
    
    bubble.useDropShadow = YES;
    
    // Corners
    bubble.useRoundedCorners = YES;
    
    // Borders
    bubble.useBorders = YES;
    
    // Draggable
    bubble.draggable = NO;
    
    // Side
    
    if ([side isEqualToString:@"top"]) {
        [bubble setSide:kKBPopupPointerSideTop];
    }
    else if ([side isEqualToString:@"bottom"]){
        [bubble setSide:kKBPopupPointerSideBottom];
    }
    else if ([side isEqualToString:@"left"]){
        [bubble setSide:kKBPopupPointerSideLeft];
    }
    else if ([side isEqualToString:@"right"]){
        [bubble setSide:kKBPopupPointerSideRight];
    }
        
    // Position
    if ([pointer isEqualToString:@"left"]) {
        [bubble setPosition:kKBPopupPointerPositionLeft];
    }
    else if([pointer isEqualToString:@"middle"]){
        [bubble setPosition:kKBPopupPointerPositionMiddle];

    }
    else if ([pointer isEqualToString:@"right"]){
        [bubble setPosition:kKBPopupPointerPositionRight];
    }
    
    // Color
    if ( _useColorsRotate ) {
        _colorIndex++;
        if ( _colorIndex >= _colors.count ) {
            _colorIndex = 0;
        }
        
    }
    if ([color isEqualToString:@"green"]) {
        bubble.drawableColor = [_colors objectAtIndex:1];
        bubble.borderColor = [_colorsBorder objectAtIndex:1];
    }else if([color isEqualToString:@"red"]){
        bubble.drawableColor=[_colors objectAtIndex:0];
        bubble.borderColor=[_colorsBorder objectAtIndex:0];
    }else if ([color isEqualToString:@"blue"]){
        bubble.drawableColor=[_colors objectAtIndex:2];
        bubble.borderColor=[_colorsBorder objectAtIndex:2];
    }
    
    
    // Demonstrate how a completion block works
    // (IMPORTANT: Use a weak reference here, otherwise you end up with a retain cycle and dealloc never gets called!)
    KB_WEAK_REF typeof(bubble) _weakBubble = bubble;
    void (^completion)(void) = ^{
        [_weakBubble setPosition:0.0f animated:YES];
    };
    [bubble setCompletionBlock:completion
               forAnimationKey:kKBPopupAnimationPopIn];
}


#pragma mark -
#pragma mark Protocol Delegate
- (CGFloat)margin {
    return kKBPanelMargin;
}

- (void)setAnimate:(BOOL)value {
    _useAnimations = value;
}

- (void)setShadow:(BOOL)value {
    [_bubble setUseDropShadow:value];
}

- (void)setCorners:(BOOL)value {
    [_bubble setUseRoundedCorners:value];
}

- (void)setBorders:(BOOL)value {
    [_bubble setUseBorders:value];
}

- (void)setDraggable:(BOOL)value {
    [_bubble setDraggable:value];
}

- (void)setColors:(BOOL)value {
    _useColorsRotate = value;
}

- (void)setSide:(NSUInteger)side {
    [_bubble setSide:side];
}

- (void)setPosition:(CGFloat)position {
    [_bubble setPosition:position];
}

- (void)setPosition:(CGFloat)position animated:(BOOL)animated {
    [_bubble setPosition:position animated:animated];
}
//end

 







//regular method

//set current Time
-(NSString *)setCurrentTime{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    //give it a test
    // NSString *date=[formatter stringFromDate:[NSDate date]];
    
    
    NSString *date=[[NSString alloc]initWithFormat:@"%02d:%02d:%02d",hour,min,sec];
    sec++;
    if (sec>=60) {
        min++;
        sec=sec-60;
    }
    if (min>=60) {
        hour++;
        min=min-60;
    }
    
    return date;
    
    
}
//remove digit but number
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



//Convert NSString to NSdate;
-(NSDate *)convertNSStringtoNSDate:(NSString *)string{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *dateFromString=[[NSDate alloc]init];
    dateFromString=[dateFormatter dateFromString:string];
    return dateFromString;
}
//the position of view in selectedmapview.





//return Current location coordinator
-(CLLocationCoordinate2D)getCurrentLocation{
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];

    return coordinate;
    
}


//SET UP AN ALERT
-(void)change{
    isUsual=YES;
    isSuggested=NO;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alert.tag==TAG_DEV) {
        if (buttonIndex==0) {
            isSuggested=YES;
            isUsual=NO;
            
            [self drawASuggestRoute];
        }
        else if (buttonIndex==1){
            [self change];
        }
    }
    else if(alert.tag==TAG_DISSMISS){
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (alert.tag==TAG_SUGESTION){
        if (buttonIndex == 0) {
            [self drawARoute];
            [self drawASuggestRoute];
        }
    }
    
    
}


//end









//timer Part!
-(void)startTimer{
    NSDate *compareTime=[[NSDate alloc]init];
    
        if (timerCount==60&&alreadyRoute==YES) {
            timerCount=0;
            CGPoint tests=CGPointMake(213, 439);
            if (terminalTime >0){
                terminalTime=terminalTime-1;
                NSString *walkingTimeDisplay=[[NSString alloc]initWithFormat:@"You will arrival in %d mins",terminalTime ];
                [self drawBubble:tests position:@"right" pointer:@"left" text:walkingTimeDisplay color:@"green"];
            }
            else if (terminalTime <=0){
                NSString *walkingTimeDisplay=[[NSString alloc]initWithFormat:@"You will arrival less than one minite",terminalTime ];
                [self drawBubble:tests position:@"right" pointer:@"left" text:walkingTimeDisplay color:@"red"];
            }

            
        }else{
            ++timerCount;
        }

    
    
    
    
    if (isSuggested==NO&&isUsual==NO) {
    compareTime=[self convertNSStringtoNSDate:self.displayDipartureTime];
    }
    
    else if (isSuggested==YES&&isUsual==NO) {
        int hourses=[self getNumber:self.nextStopDipartureTime]/10000;
        int minses= [self  getNumber: self.nextStopDipartureTime]/100-hour*100;
        minses=minses+self.routeTime;
        if (min>=60) {
            min=min-60;
            hour=hour+1;
        }
        NSString *alteredTimes=[[NSString alloc]initWithFormat:@"%02d:%02d:00",hourses,minses ];
        compareTime=[self convertNSStringtoNSDate:alteredTimes];

    }
    else {
        int hourses=[self getNumber:self.displayDipartureTime]/10000;
        int minses= [self  getNumber: self.displayDipartureTime]/100-hour*100;
        minses=minses+self.routeTime;
        if (min>=60) {
            min=min-60;
            hour=hour+1;
        }
        NSString *alteredTimes=[[NSString alloc]initWithFormat:@"%02d:%02d:00",hourses,minses ];
        compareTime=[self convertNSStringtoNSDate:alteredTimes];
        //NSLog(@"%@",alteredTimes);

    }
    if (compareTime ==NULL) {
        compareTime=[self convertNSStringtoNSDate:self.displayDipartureTime];
    }

    NSDate *startTime=[self convertNSStringtoNSDate:[self setCurrentTime]];
    NSTimeInterval timePlus=self.routeTime *60;
    NSTimeInterval timeDifference=[ compareTime timeIntervalSinceDate:startTime];
    NSTimeInterval timeLeft;
    NSInteger leftTime=0;
       if (timeDifference<0) {
        compareTime=[compareTime dateByAddingTimeInterval:timePlus];
        timeLeft=[compareTime timeIntervalSinceDate: startTime];
        if (timeLeft<0) {
            alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sorry! You Have Missed The Last Bus!" delegate:self cancelButtonTitle:@"Dissmiss" otherButtonTitles:nil];
            [alert show];
            alert.tag=TAG_DISSMISS;
            isMissed=YES;
            while ((!alert.hidden) && (alert.superview != nil))
            {
                [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
                
            }

            
        }else{
         leftTime=timeLeft;   
        }
      
        
    }
    else if(timeDifference==0){
        
        if (isMissed) {
            alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"It seems you have already missed 2 buses! You'd better hurry !" delegate:self cancelButtonTitle:@"Dismiss!" otherButtonTitles:nil];
            
            alert.tag=TAG_NONEPROCEED;
            [alert show];
        }
        else{
            if (isMissed==NO) {
                alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"You have already missed the bus, instead of waiting for the next bus it is been suggest to walk towards to the next station" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:@"No!", nil];
                
                [alert show];
                alert.tag=TAG_DEV;
                isMissed=YES;

            }
            
        }
    }
  else {
        timeLeft=[compareTime timeIntervalSinceDate:startTime];
        leftTime=timeLeft;
    }
    
    if (leftTime<terminalTime*60) {
        leftTime=leftTime+self.routeTime*60;

    }
    
    
    int mins=leftTime/60;
    int secs=leftTime-mins*60;

    NSString *displayTime=[[NSString alloc]initWithFormat:@"%02d",mins];
    NSString *displayTimesec=[[NSString alloc]initWithFormat:@"%02d",secs];
    int temp=[displayTime intValue];
    CLLocationCoordinate2D currentLocations=[self getCurrentLocation];
 
    if (isUsual==NO&&isSuggested==NO&&isDisplayed==YES&&alreadyShows==NO&&currentLocations.latitude==[self.latitude doubleValue]&&currentLocations.longitude ==[self.longitude doubleValue]) {
        if (temp>=terminalTime) {
        
           alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@" Instead of waiting for the next bus it is been suggest to walk towards to the next station" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:@"No!", nil];
            [alert show];
            alert.tag=TAG_SUGESTION;
            
            alreadyShows=YES;
        }
    }
    if (temp>=terminalTime+1&&timerCount==50&&alreadyRoute==YES){
        terminalTime=terminalTime-1;
        NSString *walkingTimeDisplay=[[NSString alloc]initWithFormat:@"You will arrival in %d mins",terminalTime ];
        CGPoint tests=CGPointMake(213, 439);
        [self drawBubble:tests position:@"right" pointer:@"left" text:walkingTimeDisplay color:@"blue"];
    }
    else if (temp>=terminalTime&&timerCount==60&&alreadyRoute==YES){
        terminalTime=terminalTime-1;
        NSString *walkingTimeDisplay=[[NSString alloc]initWithFormat:@"You will arrival in %d mins",terminalTime ];
        CGPoint tests=CGPointMake(213, 439);
        [self drawBubble:tests position:@"right" pointer:@"left" text:walkingTimeDisplay color:@"red"];
    }

    [self.scrollNumber setNumber:temp withAnimationType:scrollNumAnimationTypeFromLast animationTime:0.3];
    [self.scrollNumberViewSec setNumber:[displayTimesec intValue] withAnimationType:scrollNumAnimationTypeFromLast animationTime:0.3];
    
}


-(void)random{

}

-(void)stopTimer{
    
    if (timer) {
        [timer invalidate];
        //timer=nil;
    }

}










//routes part

- (void)deliverToTheDirectionService:
(CLLocationCoordinate2D)coordinate stopName:(NSString *)name{
    
    if ([waypointStrings_ count]==2) {
       [waypoints_ removeObjectAtIndex:1];
        [waypointStrings_ removeObjectAtIndex:1];
       
        
    }
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);
    
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title=name;
    marker.map = _mapView;
    [waypoints_ addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    [waypointStrings_ addObject:positionString];
    

    
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithTarget:coordinate zoom:15 ];
    [_mapView animateToCameraPosition:camera];
    [_mapView animateToViewingAngle:45];

    if([waypoints_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        MDDirectionService *mds=[[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query withSelector:selector withDelegate:self];

        
    }

    
}
- (void)addDirections:(NSDictionary *)json {
    NSDictionary *temp=[json objectForKey:@"routes"];
    NSDictionary *routes;
    if (temp==nil) {
        NSLog(@"sorry");
    }else{
        routes = [json objectForKey:@"routes"][0];}

    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    int walkingTime=0;
    
    NSDictionary *legs=[routes objectForKey:@"legs"][0];
    NSDictionary *steps=[legs objectForKey:@"steps"];
    for (NSDictionary *step in steps) {
        NSDictionary *dur=[step objectForKey:@"duration"];
        NSString *texts=[dur objectForKey:@"text"];
        int temp=[self getNumber:texts];
        
        if (isDisplayed==YES) {
            walkingTime=walkingTime+temp;
        }else{
            alteredTime=alteredTime+temp;
        }
        terminalTime=alteredTime+walkingTime;
        //NSLog(@"%@",texts);
    }


    NSString *walkingTimeDisplay=[[NSString alloc]initWithFormat:@"You will arrival in %d mins",terminalTime ];
    CGPoint tests=CGPointMake(213, 439);

    [self drawBubble:tests position:@"right" pointer:@"left" text:walkingTimeDisplay color:@"green"];

    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth=10.f;
    polyline.geodesic = YES;
    polyline.strokeColor = [UIColor blueColor];
    polyline.map = _mapView;
    isDisplayed=YES;
}

//using Maps App to display the route
-(void)drawTestLine{
    CLLocationCoordinate2D wimbLocation;
    wimbLocation.latitude=[self.latitude doubleValue];
    wimbLocation.longitude=[self.longitude doubleValue];
    
    myAnnotation=[[Annotation alloc]init];
    myAnnotation.coordinate =wimbLocation;
    CLLocationCoordinate2D userCoordinate ;
    userCoordinate.latitude=54.9603867292;
    userCoordinate.longitude=-1.6123780047;
   
    [self setPlaceMark:myAnnotation.coordinate :@"destination"];

}

-(void)drawARoute{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];

    

    [self deliverToTheDirectionService:coordinate stopName:@"Current Place"];
    alreadyPressed=YES;
    alreadyRoute=YES;

}

-(void)drawASuggestRoute{
    CLLocationCoordinate2D nextBusLocation;
    nextBusLocation.latitude=[self.nextlatitude doubleValue];
    nextBusLocation.longitude=[self.nextlongitude doubleValue];
    
    [self deliverToTheDirectionService:nextBusLocation stopName:self.nextBusStopName];
}
//use apple map application to show the route;
-(void)setPlaceMark:(CLLocationCoordinate2D )coordinator :(NSString *)name{
    MKPlacemark *placeMark=[[MKPlacemark alloc]initWithCoordinate:coordinator addressDictionary:nil];
    MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:placeMark];
    mapItem.name=name;
    NSDictionary *launchOptions=@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
    [mapItem openInMapsWithLaunchOptions:launchOptions];
}











#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



@end



