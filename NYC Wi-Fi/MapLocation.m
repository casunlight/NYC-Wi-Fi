//
//  MapLocation.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 8/31/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize location = _location;

/* - (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
} */

- (id)initWithLocation:(LocationInfo *)location coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [location.name copy];
        _address = [location.address copy];
        _coordinate = coordinate;
        _location = location;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

@end