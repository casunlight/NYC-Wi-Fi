#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WifiAnnotationsCollection.h"

@interface WifiClusterBlock : NSObject {
    WifiAnnotationsCollection *annotationsCollection;
    
    MKMapRect blockRect;
}

@property MKMapRect blockRect;

- (void) addAnnotation:(id<MKAnnotation>)annotation;
- (id<MKAnnotation>) getClusteredAnnotation;
- (id<MKAnnotation>) getAnnotationForIndex:(NSInteger)index;
- (NSInteger) count;

@end
