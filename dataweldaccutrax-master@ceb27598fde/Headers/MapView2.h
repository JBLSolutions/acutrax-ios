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

@interface MapView2 : CoreView
{
    IBOutlet MKMapView *mvMain;
}
@property (strong, nonatomic) IBOutlet MKMapView *mvMain;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomer:(int)Customer_ID;
@end
