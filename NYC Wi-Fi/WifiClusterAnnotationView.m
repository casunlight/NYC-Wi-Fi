//
//  WifiClusterAnnotationView.m
//  NYC Wi-Fi
//
//  Created by Kevin Wolkober on 12/6/12.
//  Copyright (c) 2012 Kevin Wolkober. All rights reserved.
//

#import "WifiClusterAnnotationView.h"

@implementation WifiClusterAnnotationView

@synthesize coordinate;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [self addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:11];
        label.textAlignment = UITextAlignmentCenter;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0,-1);
    }
    return self;
}

- (void) setClusterText:(NSString *)text
{
    label.text = text;
}

@end
