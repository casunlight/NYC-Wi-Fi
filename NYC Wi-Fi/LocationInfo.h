//
//  LocationInfo.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/22/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationDetails;

@interface LocationInfo : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * fee_type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) LocationDetails *details;

@end
