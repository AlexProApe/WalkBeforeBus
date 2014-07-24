//
//  MDDirectionService.h
//  finaSearchData
//
//  Created by Wei Zhang on 08/07/2013.
//  Copyright (c) 2013 Zhang Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MDDirectionService : NSObject

- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;

@end
