#import "tbl_CustomerList.h"
//#import "SQLSTUDIOMyService.h"
#import "SPLAppDelegate.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "tbl_CustomerView.h"
#import <CoreLocation/CoreLocation.h>
#import "ZBarSDK.h"
#import "LineaSDK.h"
#import "ZBarSDK.h"
#import "Linea+Connect.h"
#import "PRAVAuthorizationHelper.h"
#import "PRLocationSettingsHelper.h"

@interface tbl_CustomerList() <CLLocationManagerDelegate>
@property (nonatomic, strong) PRAVAuthorizationHelper *cameraAuthHelper;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation tbl_CustomerList

@synthesize tblData;
@synthesize rawData;
@synthesize sbMain;
@synthesize rawDataDisplay;
@synthesize searchTimer;


bool IsSearching;
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == (kCLAuthorizationStatusAuthorizedWhenInUse) || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
    else {
        [PRLocationSettingsHelper showSettingsDialogIn:self];
    }
}
-(void)searchTimerDidFinish:(NSTimer *) timer
{
    searchTimer = [[NSTimer alloc]init];
    

    IsSearching = YES;
    if([sbMain.text length] ==0)
    {
        [rawDataDisplay removeAllObjects];
        [rawDataDisplay addObjectsFromArray:rawData];
    }
    else
    {
        [rawDataDisplay removeAllObjects];
        
        for(SQLSTUDIOADVANCEDtbl_Customer_Result *myPOI in rawData)
        {
            NSRange r = [[NSString stringWithFormat:@"%@ %@ %@ %@",myPOI.Customer_Name, myPOI.Phone, myPOI.CityState, myPOI.Account_Number] rangeOfString:sbMain.text options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound)
            {
                [rawDataDisplay addObject:myPOI];
            }
            NSLog(@"CN: %@",myPOI.Customer_Name);
            
        }
    }
    IsSearching = NO;
    [tblData reloadData];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [linea disconnectMe:self];
    
}
-(void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    linea=[Linea sharedDevice];
    [linea connectMe:self];
    
    [activityMain startAnimating];
    [rawData removeAllObjects];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    rawData= [myDelegate ListAllCustomers];
    [tblData reloadData];
    NSLog(@"sbMain.text: %@",sbMain.text);
	if([sbMain.text isEqualToString:@""])
    {
         [rawDataDisplay addObjectsFromArray:rawData];
    }
    else
    {
        IsSearching = YES;
        if([sbMain.text length] ==0)
        {
            [rawDataDisplay removeAllObjects];
            [rawDataDisplay addObjectsFromArray:rawData];
        }
        else
        {
            [rawDataDisplay removeAllObjects];
            
            for(SQLSTUDIOADVANCEDtbl_Customer_Result *myPOI in rawData)
            {
                NSRange r = [[NSString stringWithFormat:@"%@",myPOI.Customer_Name] rangeOfString:sbMain.text options:NSCaseInsensitiveSearch];
                if(r.location != NSNotFound)
                {
                    [rawDataDisplay addObject:myPOI];
                }
            }
        }
        IsSearching = NO;
        [tblData reloadData];
    }
    [tblData reloadData];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Customers";
        rawData = [[NSMutableArray alloc] init];
        rawDataDisplay = [[NSMutableArray alloc] init];
        
        
      
        
        // create a standard save button
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                       target:self
                                       action:@selector(searchOption:)];
        saveButton.style = UIBarButtonItemStylePlain;
      
        
//        // place the toolbar into the navigation bar
  
        self.navigationItem.rightBarButtonItem = saveButton;
    }
    return self;
}
-(void) searchOption:(id)sender
{
    [self.cameraAuthHelper authorizeIfRequired:^{
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        ZBarImageScanner *scanner = reader.scanner;
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        [self presentViewController:reader animated:YES completion:nil];
    } viaViewController:self];
}
//visual based barcode delegate
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    

        id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
//        self.tbTankID.text = symbol.data;
    
    NSString *foo =     [symbol.data stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* foo2 = [foo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    self.sbMain.text = foo2;
    
    
        [reader dismissViewControllerAnimated:YES completion:nil];
   
    [searchTimer invalidate];
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(searchTimerDidFinish:)
                                                 userInfo:nil
                                                  repeats:NO];
    
}

- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.cameraAuthHelper = [[PRAVAuthorizationHelper alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)dealloc
{
    [rawData removeAllObjects];
    [rawDataDisplay removeAllObjects];
}

- (void)viewDidUnload
{
    tblData = nil;
    rawData = nil;
    [self setSbMain:nil];
    [super viewDidUnload];
    [self setRawData:nil];
    [self setRawDataDisplay:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//search delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [sbMain resignFirstResponder];
    self.navigationItem.rightBarButtonItem=nil;
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [searchTimer invalidate];
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(searchTimerDidFinish:)
                                                 userInfo:nil
                                                  repeats:NO]; 
    

}

-(void)doneEditing
{
    [sbMain resignFirstResponder];
    self.navigationItem.rightBarButtonItem=nil;
}


//table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(IsSearching == NO)
    {
        NSLog(@"count: %lu",(unsigned long)[rawDataDisplay count]);
        return [rawDataDisplay count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        CGRect frame;
        frame.origin.x = 10;
        frame.origin.y = 5;
        frame.size.height = 20;
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
        
        if(iPad == YES)
        {
            frame.size.width = 580;            
        }
        else
        {
            frame.size.width = 300;            
        }    
        UILabel *labelName = [[UILabel alloc]initWithFrame:frame];
        labelName.tag = 1;
        [cell.contentView addSubview:labelName];
        labelName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        labelName.textColor = [UIColor blackColor];
        labelName.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails = [[UILabel alloc]initWithFrame:frame];
        lblDetails.tag = 2;
        [cell.contentView addSubview:lblDetails];
        lblDetails.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails.textColor = [UIColor blackColor];
        lblDetails.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails2 = [[UILabel alloc]initWithFrame:frame];
        lblDetails2.tag = 3;
        [cell.contentView addSubview:lblDetails2];
        lblDetails2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails2.textColor = [UIColor blackColor];
        lblDetails2.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails3 = [[UILabel alloc]initWithFrame:frame];
        lblDetails3.tag = 4;
        [cell.contentView addSubview:lblDetails3];
        lblDetails3.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails3.textColor = [UIColor blackColor];
        lblDetails3.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails4 = [[UILabel alloc]initWithFrame:frame];
        lblDetails4.tag = 5;
        [cell.contentView addSubview:lblDetails4];
        lblDetails4.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails4.textColor = [UIColor blackColor];
        lblDetails4.backgroundColor = [UIColor clearColor];
        
    }
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *detailLabel = (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *detailLabel2 = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *detailLabel3 = (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *detailLabel4 = (UILabel*)[cell.contentView viewWithTag:5];
    
    SQLSTUDIOADVANCEDtbl_Customer_Result *myGSO = [rawDataDisplay objectAtIndex:indexPath.row];
    nameLabel.text = myGSO.Customer_Name;

    detailLabel.text = [NSString stringWithFormat:@"Phone : %@", myGSO.Phone];
    
    detailLabel2.text = [NSString stringWithFormat:@"Location : %@", myGSO.CityState];
    detailLabel3.text = [NSString stringWithFormat:@"Account : %@", myGSO.Account_Number];
    
    
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[myGSO.Latitude doubleValue] longitude:[myGSO.Longitude doubleValue ]];
    
    NSLog(@"cellForRowAtIndexPath tbl_CustomerList.m");
    CLLocation *locationX = [self.locationManager location];

    CLLocation *locB = [[CLLocation alloc] initWithLatitude:locationX.coordinate.longitude  longitude:locationX.coordinate.latitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    distance = distance *  0.000621371192;
    
    //Distance in Meters
    
    //1 meter == 100 centimeter
    
    //1 meter == 3.280 feet
    
    //1 meter == 10.76 square feet
    
        detailLabel4.text = [NSString stringWithFormat:@"%f miles", distance];
    
    
    

    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    UIImage *myaccimage = [UIImage imageNamed:@"disclosure_indicator_blue.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myaccimage];
    [cell setAccessoryView:imageView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rowgradient.png"]];
    cell.backgroundView = tempImageView;
    UIImage *cachedImage = [UIImage imageNamed:@"web_icon.png"];
    cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView setImage:cachedImage];
    return cell;
       
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    SQLSTUDIOADVANCEDtbl_Customer_Result *myGSO = [rawDataDisplay objectAtIndex:indexPath.row];
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif     
    tbl_CustomerView *newView;
    if(iPad == YES)
    {
        newView = [[tbl_CustomerView alloc] initWithNibName:@"tbl_CustomerView_iPad" bundle:nil  Customer_ID:myGSO.Customer_ID]; 
    }
    else
    {
        newView = [[tbl_CustomerView alloc] initWithNibName:@"tbl_CustomerView" bundle:nil Customer_ID:myGSO.Customer_ID];
    }        
    [self.navigationController  pushViewController:newView animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQLSTUDIOADVANCEDtbl_Customer_Result *myGSO = [rawDataDisplay objectAtIndex:indexPath.row];
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif      
    tbl_CustomerView *newView;
    if(iPad == YES)
    {
        newView = [[tbl_CustomerView alloc] initWithNibName:@"tbl_CustomerView_iPad" bundle:nil Customer_ID:myGSO.Customer_ID];
    }
    else
    {
        newView = [[tbl_CustomerView alloc] initWithNibName:@"tbl_CustomerView" bundle:nil Customer_ID:myGSO.Customer_ID];
    }        
    [self.navigationController  pushViewController:newView animated:YES];
}


//laserbased barcode and magstrip
-(void)barcodeData:(NSString *)barcode type:(int)type
{
NSString *foo =     [barcode stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* foo2 = [foo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.sbMain.text = foo2;
    
    [searchTimer invalidate];
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(searchTimerDidFinish:)
                                                 userInfo:nil
                                                  repeats:NO];

}



-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    self.sbMain.text = track1;
    NSLog(@"...%@%@%@...", track1, track2, track3);
}


-(void)connectionState:(int)state {
	//switch (state) {
            NSLog(@"state: %i",state);
//		case CONN_DISCONNECTED:
//		case CONN_CONNECTING:
//			break;
		//case CONN_CONNECTED:
            NSLog(@"");
            SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
            //            [linea setMSCardDataMode:MS_PROCESSED_CARD_DATA error:nil];
            //            [linea msStartScan];
            //            [linea stopScan];
            int beepData[]={100,100,2000,100,3000,100,4000,100,5000,100};
            
//            [linea msStopScan];
            //[linea startScan];
            
            [linea setScanButtonMode:BUTTON_ENABLED error:nil];
            if(myDelegate.playBeep == YES)
            {
                [linea setScanBeep:YES volume:5 beepData:beepData length:sizeof(beepData) error:nil];
            }
            else
            {
                [linea setScanBeep:NO volume:0 beepData:nil length:0 error:nil];
            }
            
            //break;
	//}
}

@end
