//
//  MKMapView+Mine.m
//  Mine
//
//  Created by Zhi Li on 7/30/14.
//  Copyright (c) 2014 com.zhi.li. All rights reserved.
//

#import "MKMapView+Mine.h"

@implementation MKMapView (Mine)

- (void)removeAllAnnotationsButUserLocation
{
    id userLocation = [self userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self removeAnnotations:pins];
    pins = nil;
}

@end
