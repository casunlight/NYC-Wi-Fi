#import "WifiAnnotationsCollection.h"


@implementation WifiAnnotationsCollection

@synthesize xSum,ySum;
@synthesize collection;


- (id) init
{
    self = [super init];
    if( self )
    {
        collection = [[NSMutableArray alloc] init];
        xSum = 0;
        ySum = 0;
    }
    return self;
}

- (void) addObject:(id<MKAnnotation>)annotation;
{
    [collection addObject:annotation];
    MKMapPoint mapPoint = MKMapPointForCoordinate( [annotation coordinate] );
    xSum += mapPoint.x;
    ySum += mapPoint.y;
}
- (id) objectAtIndex:(NSUInteger)index
{
    return [collection objectAtIndex:index];
}
- (NSUInteger) count
{
    return [collection count];
}

#if !__has_feature(objc_arc)
-(void)dealloc
{
    [collection release], collection = nil;
    [super dealloc];
}
#endif
@end
