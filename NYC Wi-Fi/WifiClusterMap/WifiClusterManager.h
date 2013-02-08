//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WifiClusterBlock.h"
#import "MapLocation.h"

@interface WifiClusterManager : NSObject {
    
}

+ (NSArray *) clusterForMapView:(MKMapView *)mapView forAnnotations:(NSArray *)pins ;
+ (NSArray *) clusterAnnotationsForMapView:(MKMapView *)mapView forAnnotations:(NSArray *)pins blocks:(NSUInteger)blocks minClusterLevel:(NSUInteger)minClusterLevel;

+ (BOOL) clusterAlreadyExistsForMapView:(MKMapView *)mapView andBlockCluster:(WifiClusterBlock *)cluster;
- (NSInteger)getGlobalTileNumberFromMapView:(MKMapView *)mapView forLocalTileNumber:(NSInteger)tileNumber;
+ (MKPolygon *)polygonForMapRect:(MKMapRect)mapRect;

@end
