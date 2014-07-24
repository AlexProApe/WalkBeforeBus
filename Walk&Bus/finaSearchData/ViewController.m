//
//  ViewController.m
//  finaSearchData
//
//  Created by Zhang Wei on 10/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//
#import "ViewController.h"
#import "XMLParser.h"
#import "selectedViewController.h"
#import "XMLTimeTableParser.h"
#import "startTimeXML.h"
#import "XMLBusRouteTime.h"//;
@interface ViewController(){
    NSMutableArray *filteredStrings;
    NSMutableArray *totalStrings;
    NSMutableArray *totalLongitude;
    NSMutableArray *totalLatitude;
    NSMutableArray *selectedLandMark;
    NSMutableArray *stopReferenceNo;
    NSMutableArray *departureTime;
    NSMutableArray *fromStopRef;
    NSMutableArray *toStopRef;
    NSMutableArray *depatureStop;
    busStopInfo *busStopSelected;
    busRoutesInfo *routeInfo;
    BOOL isFiltered;
    NSDictionary *dicLandMark;
    NSDictionary *dicLatitude;
    NSDictionary *dicLongtitude;
    NSDictionary *dicFromStopRefNo;
    NSDictionary *dicToStopRefNo;
    NSDictionary *dicDepartureTime;
    NSDictionary *dicStopName;
    NSDictionary *dicNOLatitude;
    NSDictionary *dicNOLongitude;
    NSMutableDictionary *dicStopRef;
    NSDictionary *dictest;
    BOOL isMissed;
    
}

@property (nonatomic)CLLocationCoordinate2D stopLocation;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@end



@implementation ViewController
@synthesize customImage = _customImage;
@synthesize tweetsTableView;
@synthesize mySearchBar;
@synthesize isMissedLastBus;
XMLParser *xmlParser;
XMLTimeTableParser *timeTableParser;
startTimeXML *startTime;
XMLBusRouteTime *xmlRoute;
UIImage	 *twitterLogo;
CGRect dateFrame;
UILabel *dateLabel;
CGRect contentFrame;
UILabel *contentLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered) {
        return [filteredStrings count];
    }
    
    else{
        return [fromStopRef count];}
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";

    busRoutesInfo *currentRoute=[[timeTableParser busRoute]objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UIImage	 *twitterLogo = [UIImage imageNamed:@"bus.png"];
        
        CGRect imageFrame = CGRectMake(2, 8, 40, 40);
        self.customImage = [[UIImageView alloc] initWithFrame:imageFrame];
        self.customImage.image = twitterLogo;
        [cell.contentView addSubview:self.customImage];
        
        CGRect contentFrame = CGRectMake(45, 2, 265, 30);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentFrame];
        contentLabel.tag = 0011;
        contentLabel.numberOfLines = 2;
        contentLabel.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:contentLabel];
        
        CGRect dateFrame = CGRectMake(45, 40, 265, 10);
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
        dateLabel.tag = 0012;
        dateLabel.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:dateLabel];
    }
	if (!isFiltered) {
        UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:0011];
        NSString  *getContent=[dicStopRef objectForKey:[currentRoute fromStopPoint]];
        
        contentLabel.text = getContent;
        
        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:0012];
        NSString *getLandMark=[dicLandMark objectForKey:getContent];

        NSString *str=[[NSString alloc]initWithFormat:@"Landmark: %@", getLandMark];
        dateLabel.text = str;
        //NSLog(@"%@",gettest);
    }else
    {
        UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:0011];
        contentLabel.text = [filteredStrings objectAtIndex: indexPath.row];
        UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:0012];
        NSObject *getLandMark= [dicLandMark objectForKey:[filteredStrings objectAtIndex:indexPath.row]];

        NSString *str=[[NSString alloc]initWithFormat:@"Landmark: %@",getLandMark];
        dateLabel.text = str;
    }
	
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedViewController *stopMap =[[selectedViewController alloc]init];
    //stopMap.longitude=[]
    NSString *tempRefNo=[dictest objectForKey:[filteredStrings objectAtIndex:indexPath.row]];
    int routeTime=xmlRoute.routeTime;

    
    if (filteredStrings ==nil) {
        stopMap.latitude=[dicLatitude objectForKey:[depatureStop objectAtIndex:indexPath.row]];
        stopMap.longitude=[dicLongtitude objectForKey:[depatureStop objectAtIndex:indexPath.row]];
        stopMap.busStopName=[depatureStop objectAtIndex:indexPath.row];
        stopMap.nextBusStopName=[dicStopRef objectForKey:[toStopRef objectAtIndex:indexPath.row] ];
        
        stopMap.nextlatitude=[dicNOLatitude objectForKey:[toStopRef objectAtIndex:indexPath.row]];
        stopMap.nextlongitude=[dicNOLongitude objectForKey:[toStopRef objectAtIndex: indexPath.row]];
        if (isMissed==YES) {
            stopMap.displayDipartureTime=@"Sorry";
            stopMap.nextStopDipartureTime=@"Sorry";
        }
        else{
            stopMap.displayDipartureTime=[dicDepartureTime objectForKey:[fromStopRef objectAtIndex:indexPath.row]];
            stopMap.nextStopDipartureTime=[dicDepartureTime objectForKey:[toStopRef objectAtIndex:indexPath.row]];
        }
            
        //NSLog(@"%@",stopMap.displayDipartureTime);
        stopMap.routeTime=routeTime;
        
    }else{
        stopMap.latitude=[dicLatitude objectForKey:[filteredStrings objectAtIndex:indexPath.row]];
        stopMap.longitude=[dicLongtitude objectForKey:[filteredStrings objectAtIndex:indexPath.row]];
        stopMap.busStopName=[filteredStrings objectAtIndex:indexPath.row];
        stopMap.nextlatitude=[dicNOLatitude objectForKey:tempRefNo];
        stopMap.nextlongitude=[dicNOLongitude objectForKey:tempRefNo];
        if (isMissed==YES) {
            stopMap.displayDipartureTime=@"Sorry";
        }
        else{
            stopMap.displayDipartureTime=[dicDepartureTime objectForKey:tempRefNo];
            stopMap.nextStopDipartureTime=[dicDepartureTime objectForKey:[toStopRef objectAtIndex:indexPath.row]];
            
        }
        stopMap.routeTime=routeTime;
    }
    
    
    
    [self.navigationController pushViewController:stopMap animated:YES];
 }



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length==0) {
        isFiltered=NO;
    }else{
        
        isFiltered=YES;
        filteredStrings=[[NSMutableArray alloc]init];

        
        for (NSString *str in depatureStop) {
            NSRange stringRange =[str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (stringRange.location !=NSNotFound) {
                [filteredStrings addObject:str];
            }
        }
            
        
        
        
    }
    [self.tweetsTableView reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];

    [tweetsTableView resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated{
    
        

    


}

#pragma mark -
#pragma mark Table view delegate



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *fileName=self.title;
    self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self.view setBackgroundColor:COLOR(234,237,250)];
    tweetsTableView=[[UITableView alloc]init];
    self.mySearchBar=[[UISearchBar alloc]init];

    self.mySearchBar.delegate=self;
    self.tweetsTableView.delegate=self;
    self.tweetsTableView.dataSource=self;
    self.mySearchBar.frame=CGRectMake(0, 0, 320, 44);
    self.tweetsTableView.frame=CGRectMake(0, 45, 320, 504);
    [self.view addSubview:self.mySearchBar];
    [self.view addSubview:tweetsTableView];
    isMissedLastBus=NO;
    //[self.view addSubview:launchView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stop" ofType:@"xml"] ;
    NSString *busRoute = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"] ;
    xmlParser = [[XMLParser alloc] loadXMLByURL:path];
    xmlRoute=[[XMLBusRouteTime alloc]loadXMLByURL:busRoute];
    int tempTime=xmlRoute.routeTime;
    startTime =[[[startTimeXML alloc]getRouteTime:tempTime]loadXMLByURL:busRoute];
    NSString *tempStartTime=startTime.trueStartTime;
    if ([tempStartTime isEqualToString:@"Sorry"]) {
        isMissed = YES;
        isMissedLastBus=YES;
    }
    timeTableParser=[[[XMLTimeTableParser alloc]setStartTime:tempStartTime]loadXMLByURL:busRoute];
    
    twitterLogo = [UIImage imageNamed:@"twitter-logo.png"];
    
    
    totalStrings=[[NSMutableArray alloc]init];
    selectedLandMark=[[NSMutableArray alloc]init];
    totalLatitude=[[NSMutableArray alloc]init];
    totalLongitude=[[NSMutableArray alloc]init];
    fromStopRef=[[NSMutableArray alloc]init];
    toStopRef=[[NSMutableArray alloc]init];
    departureTime=[[NSMutableArray alloc]init];
    stopReferenceNo=[[NSMutableArray alloc]init];
    depatureStop=[[NSMutableArray alloc]init];
    busStopSelected=[[busStopInfo alloc]init];
    routeInfo=[[busRoutesInfo alloc]init];
    
    for (int j=0; j<[[timeTableParser busRoute]count]; j++) {
        routeInfo=[[timeTableParser busRoute]objectAtIndex:j];
        
        
        NSString *temp=@"Sorry";
        if ([routeInfo departureTime]==nil) {
            [departureTime addObject:temp];
        }else{
            [departureTime addObject:[routeInfo departureTime]];
        }
        if ([routeInfo fromStopPoint]==nil) {
            [fromStopRef addObject:temp];
        }else{
            [fromStopRef addObject:[routeInfo fromStopPoint]];
        }
        if ([routeInfo toStopPoint]==nil) {
            [toStopRef addObject:temp];
        }else{
            [toStopRef addObject:[routeInfo toStopPoint]];
        }
        
         //NSLog(@"%@",[departureTime objectAtIndex:j]);
    }
    
    for (int i = 0; i<[[xmlParser bus] count]; i++) {
        busStopSelected=[[xmlParser bus] objectAtIndex:i];
        [totalStrings addObject:[busStopSelected content]];
        [totalLatitude addObject:[busStopSelected latitude]];
        [totalLongitude addObject:[busStopSelected longtitude]];
        [stopReferenceNo addObject:[busStopSelected stopRefNo]];
        NSString *temp=@"Blank";
        if ([busStopSelected landMark]==nil) {
            [selectedLandMark addObject:temp];
        }else{
            [selectedLandMark addObject:[busStopSelected landMark]];
        }
        // NSLog(@"%@",[stopReferenceNo objectAtIndex:i]);
        
    }
    dicStopRef=[NSDictionary dictionaryWithObjects:totalStrings forKeys:stopReferenceNo];
    dicLandMark=[NSDictionary dictionaryWithObjects:selectedLandMark forKeys:totalStrings];
    dicLatitude=[NSDictionary dictionaryWithObjects:totalLatitude forKeys:totalStrings];
    dicLongtitude=[NSDictionary dictionaryWithObjects:totalLongitude forKeys:totalStrings];
    
    dicDepartureTime=[NSDictionary dictionaryWithObjects:departureTime forKeys:fromStopRef];
    dictest=[NSDictionary dictionaryWithObjects:stopReferenceNo forKeys:totalStrings];
    dicNOLatitude=[NSDictionary dictionaryWithObjects:totalLatitude forKeys:stopReferenceNo];
    dicNOLongitude=[NSDictionary dictionaryWithObjects:totalLongitude forKeys:stopReferenceNo];
    // NSLog(@"%@",[dicStopRef objectForKey:@"410000015078"]);
    
    self.tweetsTableView.allowsSelection = YES;
    UIBarButtonItem *myUIButtonItem = [[UIBarButtonItem alloc]init];
    myUIButtonItem.title=@"Back";
    self.navigationItem.backBarButtonItem=myUIButtonItem;
    for (int k=0; k<[[timeTableParser busRoute]count]; k++) {
        NSString *test=[dicStopRef objectForKey:[fromStopRef objectAtIndex:k]];
        if (test==nil) {
            test=@"sorry";
            [depatureStop addObject:test];
        }
        else{
        [depatureStop addObject:test];
        }
    }

}
- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    return YES;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([mySearchBar isFirstResponder] && [touch view] != self.mySearchBar)
    {
        [mySearchBar resignFirstResponder];
        
    }
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    
    return NO;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)viewDidUnload
{
    [self setTweetsTableView:nil];
    [self setTweetsTableView:nil];
    //[self setStationSearch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
