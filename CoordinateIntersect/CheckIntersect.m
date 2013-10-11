//
//  CheckIntersect.m
//  CoordinateIntersect
//
//  Created by j on 10/11/13.
//  Copyright (c) 2013 j. All rights reserved.
//

#import "CheckIntersect.h"

@implementation CheckIntersect


-(BOOL) checkIntersectsLocationSegment:(CLLocationCoordinate2D)loc1 and:(CLLocationCoordinate2D)loc2 withSegement:(CLLocationCoordinate2D)loc3 and:(CLLocationCoordinate2D)loc4
{
    if ( checkIntersect( loc1,
                        loc2,
                        loc3,
                        loc4 ) )
        return YES;
    return NO;
}

#pragma mark - private

BOOL checkIntersect(CLLocationCoordinate2D p1, CLLocationCoordinate2D p2, CLLocationCoordinate2D p3, CLLocationCoordinate2D p4)
{
    double d1 = direction(p3, p4, p1);
    double d2 = direction(p3, p4, p2);
    double d3 = direction(p1, p2, p3);
    double d4 = direction(p1, p2, p4);
    
    if ( (( (d1>0) & (d2<0) ) | ( (d1<0) & (d2>0) )) &
        (( (d3>0) & (d4<0) ) | ( (d3<0) & (d4>0) )) )
        return YES;
    else if ( (d1==0) & onSegment(p3, p4, p1) )
        return YES;
    else if ( (d2==0) & onSegment(p3, p4, p2) )
        return YES;
    else if ( (d3==0) & onSegment(p1, p2, p3) )
        return YES;
    else if ( (d4==0) & onSegment(p1, p2, p4) )
        return YES;
    
    return NO;
}

double direction(CLLocationCoordinate2D pi, CLLocationCoordinate2D pj, CLLocationCoordinate2D pk)
{
    double d = (pk.longitude  - pi.longitude)*(pj.latitude - pi.latitude) - (pj.longitude - pi.longitude)*(pk.latitude - pi.latitude);
    return d;
}

BOOL onSegment(CLLocationCoordinate2D pi, CLLocationCoordinate2D pj, CLLocationCoordinate2D pk)
{
    if ( ( MIN(pi.longitude, pj.longitude) <= pk.longitude <= MAX(pi.longitude, pj.longitude) ) &&
        ( MIN(pi.latitude, pj.latitude) <= pk.latitude <= MAX(pi.latitude, pj.latitude) ) )
        return YES;
    
    return NO;
}




@end
