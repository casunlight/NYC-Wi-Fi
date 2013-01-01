//
//  SearchMapPin.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 12/31/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SearchMapPin : NSObject <MKAnnotation> {
    NSString *address;
    CLLocationCoordinate2D coordinate;
}

@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithAddress:(NSString *)anAddress coordinate:(CLLocationCoordinate2D)aCoordinate;
//- (CLLocationCoordinate2D)getCoordinate;

@end
