//
//  ViewController.h
//  finaSearchData
//
//  Created by Zhang Wei on 10/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"
#import "busStopInfo.h"

@interface ViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (nonatomic, retain) UIImageView *customImage;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong,nonatomic)NSString* busServiceName;
@property ( nonatomic)bool isMissedLastBus;
@end
