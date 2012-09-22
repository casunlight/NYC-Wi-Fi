//
//  LocationDetails.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 9/22/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationInfo;

@interface LocationDetails : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * import;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) LocationInfo *info;

@end
