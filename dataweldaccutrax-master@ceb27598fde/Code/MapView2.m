#import "MapView2.h"
#import "SPLAppDelegate.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "tbl_CustomerView.h"

#define METERS_PER_MILE 1609.344
int selectedLocationMV;
int selectedX;
@implementation MapView2
@synthesize mvMain;
bool allowTouch2 = NO;


-(void)viewDidAppear:(BOOL)animated
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [super viewDidAppear:animated];
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad == YES)
    {
        
    }
    else
    {
        if(screenBounds.size.height == 568)
        {
            [mvMain setFrame:CGRectMake(0, 0, 320, 420)];
        }
        else
        {
            [lblNetworkStatus setFrame:CGRectMake(0, 0, 320, 341)];
        }
        
    }
    if(selectedX ==0)
    {
        //[self gumball];
    }
}

-(void)showDetails:(id)sender
{
   
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MyAnnotation *mA = (MyAnnotation*)view.annotation;
    BOOL test = [mA isKindOfClass:[MyAnnotation class]];
    if(test == YES)
    {
        selectedLocationMV = mA.locationID;
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

-(void)gumballSingle:(int)Customer_ID
{
    NSLog(@"gumballSingle MapView2.m");
    [activityMain startAnimating];
    
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    SQLSTUDIOADVANCEDtbl_Customer_Result *myPOI = [myDelegate GetCustomer:Customer_ID];
    double longitude = [myPOI.Latitude doubleValue];
    double latitude = [myPOI.Longitude doubleValue];
    
    MyAnnotation *annotation =[[MyAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = [NSString stringWithFormat:@"%@",myPOI.Customer_Name];
    
//    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    CLLocationDistance distance = [newLocation distanceFromLocation:mvMain.userLocation.location];
//    double distanceMiles = (distance / 1609.344);

    
    CLLocationManager  *locationManager;
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
    
    
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:coordinate.longitude  longitude:coordinate.latitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:longitude longitude:latitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    distance = distance * 0.000621371192;
    
    
    
    annotation.subtitle = [NSString stringWithFormat:@"%f miles",distance];
    annotation.locationID = myPOI.Customer_ID;
    annotation.locationType = 999;
    annotation.imgURL = @"";
    
    
   // [newLocation release];
    
    [mvMain addAnnotation:annotation];
    
    [activityMain stopAnimating];
    
    mvMain.showsUserLocation= YES;
}




//-(void)handleList:(id)result
//{
//    
//    if([result isKindOfClass:[NSError class]]) 
//    {
//        NSError *MyError = (NSError*) result;
//        if(MyError.code == 410)
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network" message:@"Your Network Connection is not Present" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
//            [alert show];
//            [alert release];
//        }
//		return;
//	}
//    
//
//    SQLSTUDIOADVANCEDCustomer_Location *myPOI = (SQLSTUDIOADVANCEDCustomer_Location*)result;
//        double longitude = [myPOI.Longitude doubleValue];
//        double latitude = [myPOI.Latitude doubleValue];
//        
//        MyAnnotation *annotation =[[MyAnnotation alloc] init];
//        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
//        annotation.title = [NSString stringWithFormat:@"%@",myPOI.Customer_Name];
//        
//        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//        CLLocationDistance distance = [newLocation distanceFromLocation:mvMain.userLocation.location];
//        double distanceMiles = (distance / 1609.344);
//        
//        annotation.subtitle = [NSString stringWithFormat:@"%f miles",distanceMiles];
//        //annotation.pinColor = MKPinAnnotationColorPurple;
//        annotation.locationID = myPOI.Customer_ID;
//        annotation.locationType = 999;
//        annotation.imgURL = @"";
//
//        
//        [newLocation release];
//        
//        [mvMain addAnnotation:annotation];
//        [annotation release];
//
//    [activityMain stopAnimating];
//}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andCustomer:(int)Customer_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        selectedX = Customer_ID;
        allowTouch2 = NO;
        self.title = @"Map";
        CLLocationCoordinate2D zoomLocation;
        
        
        NSLog(@"initWithNibName MapView2.m");
        CLLocationManager  *locationManager;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; 
        locationManager.distanceFilter = kCLDistanceFilterNone;

        [locationManager startUpdatingLocation];
        [locationManager requestWhenInUseAuthorization];

        
        CLLocation *location = [locationManager location];
        
        // Configure the new event with information from the location
        CLLocationCoordinate2D coordinate = [location coordinate];
        
        zoomLocation.latitude = coordinate.latitude;
        zoomLocation.longitude = coordinate.longitude;
        
        //      zoomLocation.latitude = 32.513236;
        //        zoomLocation.longitude = -93.749428;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 30*METERS_PER_MILE, 30*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [mvMain regionThatFits:viewRegion];                
        [mvMain setRegion:adjustedRegion animated:YES]; 
        [self gumballSingle:Customer_ID];
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
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
