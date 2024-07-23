//
//  MapView.m
//  JailBookings
//
//  Created by Johnathan Rossitter on 5/25/12.
//  Copyright (c) 2012 Rossitter Consulting L.L.C. All rights reserved.
//

#import "MapView.h"
#import "SPLAppDelegate.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "tbl_CustomerView.h"
#import "PRLocationSettingsHelper.h"

#define METERS_PER_MILE 1609.344
int selectedLocation_OLD;
int selectedX_OLD;
bool locationUseAuthorized;
@interface MapView () <CLLocationManagerDelegate>
@end
@implementation MapView
@synthesize mvMain;
/* synthesized via MapView.h */
@synthesize locationManager;
bool allowTouch = YES;


-(void)showDetails:(id)sender
{

    tbl_CustomerView *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad)
    {
        web = [[tbl_CustomerView alloc] initWithNibName:@"tbl_CustomerView_iPad" bundle:nil Customer_ID:selectedLocation_OLD];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else
    {
        web = [[tbl_CustomerView alloc] initWithNibName:@"tbl_CustomerView" bundle:nil Customer_ID:selectedLocation_OLD];
        [self.navigationController  pushViewController:web animated:YES];    
    }

}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MyAnnotation *mA = (MyAnnotation*)view.annotation;
    BOOL test = [mA isKindOfClass:[MyAnnotation class]];
    if(test == YES)
    {
        selectedLocation_OLD = mA.locationID;
    }
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{

    MKPinAnnotationView *pinAnnotation = nil;
    if(annotation != mvMain.userLocation) 
    {
        static NSString *defaultPinID = @"myPin";
        pinAnnotation = (MKPinAnnotationView *)[mvMain dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinAnnotation == nil )
            pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinAnnotation.canShowCallout = YES;
        MyAnnotation *ma = (MyAnnotation*)annotation;
        switch (ma.locationType) {
            case 2000:
            {
                pinAnnotation.image = [UIImage imageNamed:@"Livelocation.png"];            
            }
                break;
            default:
                pinAnnotation.image = [UIImage imageNamed:@"location.png"];
                
                break;
        }

        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [infoButton addTarget:self
                       action:@selector(showDetails:)
             forControlEvents:UIControlEventTouchUpInside];
        
        pinAnnotation.rightCalloutAccessoryView = infoButton;
        
    }
    
    return pinAnnotation;
}


-(void)gumball
{
    if (!locationUseAuthorized) {
        return;
    }
    
    NSLog(@"gumBall MapView.m");
    
    locationManager = [[CLLocationManager alloc] init];



    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];

    

    
    [activityMain startAnimating];
    [mvMain removeAnnotations:mvMain.annotations];
    SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray *myData = [delegate ListCustomerLocationsForMap:coordinate.longitude :coordinate.latitude];
    for(SQLSTUDIOADVANCEDCustomer_Location *myPOI in myData)
    {
        double longitude = [myPOI.Longitude doubleValue];
        double latitude = [myPOI.Latitude doubleValue];
        
        MyAnnotation *annotation =[[MyAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(longitude,latitude);
        annotation.title = [NSString stringWithFormat:@"%@",myPOI.Customer_Name];
        
//        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//        CLLocationDistance distance = [newLocation distanceFromLocation:mvMain.userLocation.location];
//        double distanceMiles = (distance / 1609.344);
        
        /* Removed the location manager variable below */
//      CLLocationManager  *locationManager;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;

        [locationManager startUpdatingLocation];
        [locationManager requestWhenInUseAuthorization];
        CLLocation *location = [locationManager location];
        
        // Configure the new event with information from the location
        CLLocationCoordinate2D coordinate = [location coordinate];
//        
//        double longitude = [myGSO.Longitude doubleValue];
//        double latitude = [myGSO.Latitude doubleValue];
        
        
        
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:coordinate.latitude  longitude:coordinate.longitude];
        
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:longitude longitude:latitude];
        
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        distance = distance * 0.000621371192;
        
        
        
        
        annotation.subtitle = [NSString stringWithFormat:@"%f miles",distance];
        //annotation.pinColor = MKPinAnnotationColorPurple;
        annotation.locationID = myPOI.Customer_ID;
        if([delegate CustomerHasOrder:myPOI.Customer_ID] == YES)
        {
            annotation.locationType = 2000;
        }
        else
        {
            annotation.locationType = 1000;
        }

        annotation.imgURL = @"";
        
        
       // [newLocation release];
        
        [mvMain addAnnotation:annotation];
    }
    mvMain.showsUserLocation= YES;
    [myData removeAllObjects];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        selectedX_OLD = 0;
        allowTouch = YES;
        self.title = @"Customer Map";
        NSLog(@"initWithCoder MapView.m");
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomer:(int)Customer_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {

        
        selectedX_OLD = Customer_ID;
        
        allowTouch = NO;
        self.title = @"Customer Map";
    }
    return self;
}

-(void)gumballSingleMissing:(int)Missing_ID
{
    [activityMain startAnimating];
//    [mvMain removeAnnotations:mvMain.annotations];
//    
//    
//    SQLSTUDIOMyService *service = [[SQLSTUDIOMyService alloc] init];
//    service.logging = NO;
//    
//    [service Get_tbl_Missing_Child:self action:@selector(handleListSingleMissing:) Child_ID:Missing_ID];
//    [service release];
    
    mvMain.showsUserLocation= YES;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

        [self gumball];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        locationUseAuthorized = true;
        CLLocationCoordinate2D zoomLocation;
        [locationManager startUpdatingLocation];
        
        CLLocation *location = [locationManager location];
        
        // Configure the new event with information from the location
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        zoomLocation.latitude = coordinate.latitude;
        zoomLocation.longitude = coordinate.longitude;
        
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 30*METERS_PER_MILE, 30*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mvMain regionThatFits:viewRegion];
        [mvMain setRegion:adjustedRegion animated:YES];
    }
    else {
        locationUseAuthorized = false;
        [PRLocationSettingsHelper showSettingsDialogIn:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.navigationController.navigationBar.translucent = NO;
    /* Removed the location manager variable below */
    //      CLLocationManager  *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
}

- (void)viewDidUnload
{
    [self setMvMain:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
