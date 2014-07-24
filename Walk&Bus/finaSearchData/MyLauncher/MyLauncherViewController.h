//
//  MyLauncherViewController.h
//  finaSearchData
//
//  Created by Wei Zhang on 04/07/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLauncherView.h"
#import "MyLauncherItem.h"
#import "ViewController.h"
#import "MBProgressHUD.h"

@interface MyLauncherViewController : UIViewController <MyLauncherViewDelegate, UINavigationControllerDelegate> {
   

}

@property (nonatomic, strong) UINavigationController *launcherNavigationController;
@property (nonatomic, strong) MyLauncherView *launcherView;
@property (nonatomic, strong) NSMutableDictionary *appControllers;
@property (nonatomic,strong) ViewController *busService;
-(BOOL)hasSavedLauncherItems;
-(void)clearSavedLauncherItems;

-(void)launcherViewItemSelected:(MyLauncherItem*)item;
-(void)closeView;

@end
