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
@synthesize nodes = _nodes;

/* - (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
} */

- (id)initWithLocation:(LocationInfo *)initLocation coordinate:(CLLocationCoordinate2D)initCoordinate {
    if ((self = [super init])) {
        _name = [initLocation.name copy];
        _address = [initLocation.address copy];
        _coordinate = initCoordinate;
        _location = initLocation;
    }
    return self;
}

- (id)initWithNodes:(NSArray *)initNodes coordinate:(CLLocationCoordinate2D)initCoordinate {
    if ((self = [super init])) {
        _nodes = initNodes;
        _coordinate = initCoordinate;
    }
    return self;
}

/* - (CLLocationCoordinate2D)getCoordinate {
    return _coordinate;
} */

- (NSUInteger) nodeCount
{
    if (_nodes)
        return _nodes.count;
    return 0;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"_";
    return _name;
}

- (NSString *)subtitle {
    if ([_name isKindOfClass:[NSNull class]])
        return @" ";
    return _address;
}

@end