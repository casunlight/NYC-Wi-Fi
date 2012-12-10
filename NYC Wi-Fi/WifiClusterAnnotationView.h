//
//  WifiClusterAnnotationView.h
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 12/6/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WifiClusterAnnotationView : MKAnnotationView {
    UILabel *label;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (void) setClusterText:(NSString *)text;


@end
