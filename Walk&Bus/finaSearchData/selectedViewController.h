//
//  selectedViewController.h
//  finaSearchData
//
//  Created by Zhang Wei on 12/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "KBPopupBubbleView.h"
#import "ViewController.h"
@class scrollNumberView;
@interface selectedViewController : UIViewController<UIAlertViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,KBPopupBubbleViewDelegate>
{
    NSTimer *timer;
    IBOutlet UIView *mapViewOnScreen;
    CLLocationManager *locationManager;
}



@property (strong, nonatomic)NSString *longitude;
@property (strong, nonatomic)NSString *latitude;
@property (strong, nonatomic)NSString *nextlatitude;
@property (strong, nonatomic)NSString *nextlongitude;
@property (strong, nonatomic)NSString *nextBusStopName;
@property (strong, nonatomic)NSString *busStopName;
@property (nonatomic)int routeTime;
@property (strong, nonatomic)NSString *displayDipartureTime;
@property (strong,nonatomic)NSString *nextStopDipartureTime;
@property (strong, nonatomic) IBOutlet scrollNumberView *scrollNumber;
@property (strong, nonatomic) IBOutlet scrollNumberView *scrollNumberViewSec;
@property (strong, nonatomic) IBOutlet UIView *popUpBubble;

@property (strong, nonatomic) IBOutlet UIImageView *pic;

@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view
@property (nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic) GMSMapView *mapView;
@property (nonatomic,strong) UIAlertView *alert;
@end


