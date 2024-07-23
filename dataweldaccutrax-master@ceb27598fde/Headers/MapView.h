//
//  MapView.h
//  JailBookings
//
//  Created by Johnathan Rossitter on 5/25/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreView.h"
#import <MapKit/MapKit.h>
#import"MyAnnotation.h"

@interface MapView : CoreView
{
    IBOutlet MKMapView *mvMain;
}
@property (strong, nonatomic) IBOutlet MKMapView *mvMain;
/* Created a strong reference to a CLLocationManager object below and removed the local variables in MapView.m as per the requirement by Apple referenced here https://goo.gl/jVmYLP (see explanation for #2 on linked page) */
@property (nonatomic, strong) CLLocationManager *locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomer:(int)Customer_ID;
@end
