//
//  ViewController.m
//  CoordinateIntersect
//
//  Created by j on 10/11/13.
//  Copyright (c) 2013 j. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "LineView.h"
#import "CheckIntersect.h"

#define BUTTON_DIA (70.0f)
#define MIN_DELTA 0.005f

typedef enum {
    
    START,
    LINE_1
    
} STATE;


@interface ViewController () <MKMapViewDelegate>

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIButton *stateButton;

@property (nonatomic, retain) LineView *lineView;
@property (nonatomic, retain) UIButton *lineButtonA;
@property (nonatomic, retain) UIButton *lineButtonB;

@property (nonatomic, assign) STATE currentState;

@property (nonatomic, assign) CLLocationCoordinate2D pointACoord;
@property (nonatomic, assign) CLLocationCoordinate2D pointBCoord;
@property (nonatomic, assign) CLLocationCoordinate2D pointCCoord;
@property (nonatomic, assign) CLLocationCoordinate2D pointDCoord;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.stateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.stateButton.frame = CGRectMake( (self.view.frame.size.width - 200)/2 , 20, 200, 40 );
    [self.stateButton setTitle:@"set line/press here" forState:UIControlStateNormal];
    [self.stateButton addTarget:self action:@selector(stateButtonHit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stateButton];
    
    self.currentState = START;
    [self layDownLine];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom

-(void) layDownLine
{
    if (self.lineView == nil)
        self.lineView = [[LineView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.lineView];
    
    if (self.lineButtonA == nil)
        self.lineButtonA = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lineButtonA.frame = CGRectMake( (self.view.frame.size.width - BUTTON_DIA)/2 - 70,
                                        (self.view.frame.size.height - BUTTON_DIA)/2,
                                        BUTTON_DIA, BUTTON_DIA);
    [self.lineButtonA addTarget:self action:@selector(imageTouch1:withEvent:) forControlEvents:UIControlEventTouchDown];
    [self.lineButtonA addTarget:self action:@selector(imageMoved1:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.lineButtonA setImage:[UIImage imageNamed:@"line-btn"] forState:UIControlStateNormal];
    [self.view addSubview:self.lineButtonA];
    
    self.lineButtonB = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lineButtonB.frame = CGRectMake( (self.view.frame.size.width - BUTTON_DIA)/2 + 70,
                                        (self.view.frame.size.height - BUTTON_DIA)/2,
                                        BUTTON_DIA, BUTTON_DIA);
    [self.lineButtonB addTarget:self action:@selector(imageTouch2:withEvent:) forControlEvents:UIControlEventTouchDown];
    [self.lineButtonB addTarget:self action:@selector(imageMoved2:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.lineButtonB setImage:[UIImage imageNamed:@"line-btn"] forState:UIControlStateNormal];
    [self.view addSubview:self.lineButtonB];
    
    self.lineView.pointA = self.lineButtonA.center;
    self.lineView.pointB = self.lineButtonB.center;
    [self.lineView setNeedsDisplay];
}

-(void) pegLine
{
    //onvert button center to coords
    
    CLLocationCoordinate2D one;
    CLLocationCoordinate2D two;
    
    if (self.currentState == START)
    {
        self.pointACoord = [self.mapView convertPoint:self.lineButtonA.center toCoordinateFromView:self.view];
        self.pointBCoord = [self.mapView convertPoint:self.lineButtonB.center toCoordinateFromView:self.view];
        
        one = self.pointACoord;
        two = self.pointBCoord;
    }
    else
    {
        self.pointCCoord = [self.mapView convertPoint:self.lineButtonA.center toCoordinateFromView:self.view];
        self.pointDCoord = [self.mapView convertPoint:self.lineButtonB.center toCoordinateFromView:self.view];
        
        one = self.pointCCoord;
        two = self.pointDCoord;
    }
    
    // replace line line
    [self.lineView removeFromSuperview];
    CLLocationCoordinate2D coords[2] = {one, two};
    
    MKPolyline *route = [MKPolyline polylineWithCoordinates:coords count:2];
    [self.mapView addOverlay:route];
    
    // replace button with pin
    [self.lineButtonA removeFromSuperview];
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = one;
    [self.mapView addAnnotation:point1];
    
    [self.lineButtonB removeFromSuperview];
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = two;
    [self.mapView addAnnotation:point2];

}

-(void) checkIntersect
{
    CheckIntersect *ci = [[CheckIntersect alloc] init];
    
    NSString *message = nil;
    
    if ( [ci checkIntersectsLocationSegment:self.pointACoord and:self.pointBCoord withSegement:self.pointCCoord and:self.pointDCoord] )
        message = @"LINES INTERSECT";
    else
        message = @"LINES DO NOT INTERSECT";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OK" message:message delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil];
    
    [alert show];
    
    
}

-(void) cleanUpMap
{
    for (id annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    for (id overlay in self.mapView.overlays) {
        [self.mapView removeOverlay:overlay];
    }
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self cleanUpMap];
    self.currentState = START;
    [self performSelector:@selector(layDownLine) withObject:nil afterDelay:0.5];
    
}


#pragma mark - buttons

-(void) stateButtonHit:(id)sender
{
    switch (self.currentState) {
            
        case START:
        {
            [self pegLine];
            self.currentState = LINE_1;
            [self performSelector:@selector(layDownLine) withObject:nil afterDelay:0.5];
            
        }   break;
            
        case LINE_1:
        {
            [self pegLine];
            [self performSelector:@selector(checkIntersect) withObject:nil afterDelay:0.5];
            
        }   break;
            
        default:
            break;
    }

    [self pegLine];
    
    
}

- (void) imageTouch1:(id) sender withEvent:(UIEvent *) event
{
    
}

- (void) imageMoved1:(id) sender withEvent:(UIEvent *) event     //start
{
    UIView *view = sender;
    CGPoint point = [[[event touchesForView:view] anyObject] locationInView:self.view];
    view.center = point;
    
    self.lineView.pointA = point;
    [self.lineView setNeedsDisplay];
}

- (void) imageTouch2:(id) sender withEvent:(UIEvent *) event
{
    
}

- (void) imageMoved2:(id) sender withEvent:(UIEvent *) event     // stop
{
    UIView *view = sender;
    CGPoint point = [[[event touchesForView:view] anyObject] locationInView:self.view];
    view.center = point;
    
    self.lineView.pointB = point;
    [self.lineView setNeedsDisplay];
}


#pragma mark - map del

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor redColor];
        
        
        return routeRenderer;
    }
    else return nil;
}



@end
