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
    NSString *name;
    NSString *address;
    LocationInfo *location;
    CLLocationCoordinate2D coordinate;
    NSArray *nodes;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) LocationInfo *location;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSArray *nodes;

- (id)initWithLocation:(LocationInfo *)locationInfo coordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithNodes:(NSArray *)initNodes coordinate:(CLLocationCoordinate2D)initCoordinate;
//- (id)initWithName:(NSString *)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
//- (CLLocationCoordinate2D)getCoordinate;
- (NSUInteger) nodeCount;

@end
