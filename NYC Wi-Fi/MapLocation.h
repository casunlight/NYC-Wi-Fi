//
//  MapLocation.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 8/31/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LocationInfo.h"
#import "LocationDetails.h"

@interface MapLocation : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_address;
    LocationInfo *_location;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) LocationInfo *location;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(LocationInfo *)location coordinate:(CLLocationCoordinate2D)coordinate;
//- (id)initWithName:(NSString *)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
