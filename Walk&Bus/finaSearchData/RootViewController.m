//
//  RootViewController.m
//  finaSearchData
//
//  Created by Zhang Wei on 12/06/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.

//

#import "RootViewController.h"
#import "MyLauncherItem.h"
#import "CustomBadge.h"
//#import "ItemViewController.h"
#import "ViewController.h"

@implementation RootViewController

-(void)loadView
{    
	[super loadView];
    self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self.view setBackgroundColor:COLOR(234,237,250)];
    self.title = @"Walk Before Bus";
    
    [[self appControllers] setObject:[ViewController class] forKey:@"ItemViewController"];
    
    //Add your view controllers here to be picked up by the launcher; remember to import them above
	//[[self appControllers] setObject:[MyCustomViewController class] forKey:@"MyCustomViewController"];
	//[[self appControllers] setObject:[MyOtherCustomViewController class] forKey:@"MyOtherCustomViewController"];
	
	if(![self hasSavedLauncherItems])
	{
		[self.launcherView setPages:[NSMutableArray arrayWithObjects: 
                                     [NSMutableArray arrayWithObjects: 
                                      [[MyLauncherItem alloc] initWithTitle:@"Route 64"
                                                                 iPhoneImage:@"BUSSTORY" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"64"
                                                                   deletable:YES
                                                                    busName:@"busName"    ],
                                      [[MyLauncherItem alloc] initWithTitle:@" Route 64A"
                                                                 iPhoneImage:@"57" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"64A" 
                                                                   deletable:YES
                                       busName:@"busName" ],
                                      [[MyLauncherItem alloc] initWithTitle:@"Route 80 "
                                                                 iPhoneImage:@"BUSSTORY" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"80"
                                                                   deletable:YES
                                       busName:@"busName" ],
                                      [[MyLauncherItem alloc] initWithTitle:@"Route 67 "
                                                                 iPhoneImage:@"BUSSTORY" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"67"
                                                                   deletable:YES
                                       busName:@"busName" ],
                                      [[MyLauncherItem alloc] initWithTitle:@"Route 73 "
                                                                 iPhoneImage:@"BUSSTORY" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"73"
                                                                   deletable:YES
                                       busName:@"busName" ],
                                      [[MyLauncherItem alloc] initWithTitle:@"Route 69 "
                                                                 iPhoneImage:@"BUSSTORY" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"69"
                                                                   deletable:YES
                                       
                                       busName:@"busName" ],
                                      [[MyLauncherItem alloc] initWithTitle:@"69B Route"
                                                                 iPhoneImage:@"sbus_icon" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"69B"
                                                                   deletable:YES
                                       busName:@"busName" ],
                                      nil], 
                                     [NSMutableArray arrayWithObjects: 
                                      [[MyLauncherItem alloc] initWithTitle:@" Route 35"
                                                                 iPhoneImage:@"sbus_icon" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"Item 8 View"
                                                                   deletable:YES
                                       busName:@"busName" ],
                                      [[MyLauncherItem alloc] initWithTitle:@" Route 45"
                                                                 iPhoneImage:@"sbus_icon" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"Item 9 View"
                                                                   deletable:YES
                                       busName:@"busName" ],
                                      [[MyLauncherItem alloc] initWithTitle:@" Route 32"
                                                                 iPhoneImage:@"sbus_icon" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"Item 10 View"
                                                                   deletable:NO
                                       busName:@"xz" ],
                                      nil],
                                     nil]];
        
        // Set number of immovable items below; only set it when you are setting the pages as the 
        // user may still be able to delete these items and setting this then will cause movable 
        // items to become immovable.
        // [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];
	}
    
    // Set badge text for a MyLauncherItem using it's setBadgeText: method
    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setBadgeText:@"4"];
    
    // Alternatively, you can import CustomBadge.h as above and setCustomBadge: as below.
    // This will allow you to change colors, set scale, and remove the shine and/or frame.
    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:1] setCustomBadge:[CustomBadge customBadgeWithString:@"2" withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:0.8 withShining:NO]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//If you don't want to support multiple orientations uncomment the line below
    //return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

@end
