//
//  SearchMapPin.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 12/31/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "SearchMapPin.h"

@implementation SearchMapPin
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithAddress:(NSString *)anAddress coordinate:(CLLocationCoordinate2D)aCoordinate {
    if ((self = [super init])) {
        _address = [anAddress copy];
        _coordinate = aCoordinate;
    }
    return self;
}

/* - (CLLocationCoordinate2D)getCoordinate {
 return _coordinate;
 } */

- (NSString *)title {
    if ([_address isKindOfClass:[NSNull class]])
        return @"_";
    return _address;
}

/* - (NSString *)subtitle {
    if ([_name isKindOfClass:[NSNull class]])
        return @" ";
    return _address;
} */

@end