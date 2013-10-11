//
//  CheckIntersect.h
//  CoordinateIntersect
//
//  Created by j on 10/11/13.
//  Copyright (c) 2013 j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CheckIntersect : NSObject

-(BOOL) checkIntersectsLocationSegment:(CLLocationCoordinate2D)loc1 and:(CLLocationCoordinate2D)loc2 withSegement:(CLLocationCoordinate2D)loc3 and:(CLLocationCoordinate2D)loc4;

@end
