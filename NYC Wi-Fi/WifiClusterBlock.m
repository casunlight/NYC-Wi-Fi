#import "WifiClusterMap.h"

@implementation WifiClusterBlock

@synthesize blockRect;

- (void) addAnnotation:(id<MKAnnotation>)annotation
{
    if( !annotationsCollection )
    {
        annotationsCollection = [[WifiAnnotationsCollection alloc] init];
    }
    
    [annotationsCollection addObject:annotation];
}
- (id<MKAnnotation>) getAnnotationForIndex:(NSInteger)index
{
    return [annotationsCollection objectAtIndex:index];
}

- (id<MKAnnotation>) getClusteredAnnotation
{
    if( [self count] == 1 )
    {
        return [self getAnnotationForIndex:0];
    } else if ( [self count] > 1 )
    {
        
        double x = [annotationsCollection xSum] / [annotationsCollection count];
        double y = [annotationsCollection ySum] / [annotationsCollection count];
        
        CLLocationCoordinate2D location = MKCoordinateForMapPoint(MKMapPointMake(x, y));
        /* #if !__has_feature(objc_arc)
        MapLocation *pin = [[[MapLocation alloc] init] autorelease];
#else
        MapLocation *pin = [[MapLocation alloc] init];
#endif
        pin.coordinate = location;
        pin.nodes = [annotationsCollection collection]; */
        NSLog(@"WifiClusterBlock point: %f", location.latitude);
        MapLocation *pin = [[MapLocation alloc] initWithNodes:[annotationsCollection collection] coordinate:location];
        return pin;

    }
    return nil;
}

- (NSInteger) count
{
    return [annotationsCollection count];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%i annotations",[self count]];
}

#if !__has_feature(objc_arc)
- (void) dealloc
{
    [annotationsCollection release], annotationsCollection = nil;
    [super dealloc];
}
#endif

@end
