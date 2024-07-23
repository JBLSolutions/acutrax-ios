#import "tbl_CustomerView.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "SPLAppDelegate.h"
#import "MyPicker.h"
#import "MapView2.h"
#import "OrderView.h"
#import "NewOrder.h"

@implementation tbl_CustomerView
@synthesize rawData;
@synthesize btnSave;
@synthesize myPicker;
@synthesize txtCustomer_ID;
@synthesize txtAccount_Number;
@synthesize txtCustomer_Name;
@synthesize txtCustomer_Address;
@synthesize txtCustomer_Address_2;
@synthesize txtCityState;
@synthesize txtZip;
@synthesize txtZip_4;
@synthesize txtPhone;
@synthesize txtCode;
@synthesize txtCountry;
@synthesize txtCompany_Letter;
@synthesize txtPassword;
@synthesize txtLongitude;
@synthesize txtLatitude;
@synthesize txtssImage_Logo;
@synthesize lblName;
@synthesize lblAddress;
//@synthesize lblAddress2;
@synthesize lblAddress3;
@synthesize lblAccount;
@synthesize tbPhone;
@synthesize imhLogo;
@synthesize btnMap;
@synthesize btnOrders;
@synthesize tblData;
@synthesize btnDirections;

NSMutableArray *selectedObject;
NSString *dLong;
NSString *dLat;

int selectedLocation;

-(void)touchedOK:(MyPicker *)controller   
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSave_Touch:(id)sender 
{    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    //SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    service.logging = NO;
    if(selectedObject.count >0)
    {
        //TODO: WRITE UPDATE CODE


    }
    else
    {
        //TODO: WRITE CREATE CODE
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pcOrders_Touch:(id)sender {
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedObject = [[NSMutableArray alloc] init];
        self.title = @"tbl_Customer";
        myPicker = [[MyPicker alloc] init];
        myPicker = [[MyPicker alloc] initWithNibName:@"MyPicker" bundle:nil];
        myPicker.delegate = self;

    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Customer_ID:(int)Customer_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedLocation = Customer_ID;
        selectedObject = [[NSMutableArray alloc] init];
        rawData = [[NSMutableArray alloc] init];
        self.title = @"Customer";
        myPicker = [[MyPicker alloc] init];
        myPicker = [[MyPicker alloc] initWithNibName:@"MyPicker" bundle:nil];
        myPicker.delegate = self;
    }
    return self;
}

- (IBAction)btnOrders_Touch:(id)sender
{
    NewOrder *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad)
    {
        web = [[NewOrder alloc] initWithNibName:@"NewOrder_iPad" bundle:nil Customer_ID:selectedLocation];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else
    {
        web = [[NewOrder alloc] initWithNibName:@"NewOrder" bundle:nil Customer_ID:selectedLocation];
        [self.navigationController  pushViewController:web animated:YES];
    }
}

- (IBAction)btnMap_Touch:(id)sender 
{
    MapView2 *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad)
    {
        web = [[MapView2 alloc] initWithNibName:@"MapView2_iPad" bundle:nil andCustomer:selectedLocation];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else
    {
        web = [[MapView2 alloc] initWithNibName:@"MapView2" bundle:nil andCustomer:selectedLocation];
        [self.navigationController  pushViewController:web animated:YES];    
    }

}

-(void)doneWithKeyboard
{
   [txtCustomer_ID resignFirstResponder];
   [txtAccount_Number resignFirstResponder];
   [txtCustomer_Name resignFirstResponder];
   [txtCustomer_Address resignFirstResponder];
   [txtCustomer_Address_2 resignFirstResponder];
   [txtCityState resignFirstResponder];
   [txtZip resignFirstResponder];
   [txtZip_4 resignFirstResponder];
   [txtPhone resignFirstResponder];
   [txtCode resignFirstResponder];
   [txtCountry resignFirstResponder];
   [txtCompany_Letter resignFirstResponder];
   [txtPassword resignFirstResponder];
   [txtLongitude resignFirstResponder];
   [txtLatitude resignFirstResponder];
   [txtssImage_Logo resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)setupScreen:(SPLAppDelegate *)myDelegate
{
  SQLSTUDIOADVANCEDtbl_Customer_Result *myResult = [myDelegate GetCustomer:selectedLocation];
    self.txtCustomer_ID.text = [NSString stringWithFormat:@"%i", myResult.Customer_ID];
    self.txtAccount_Number.text = myResult.Account_Number;
    self.txtCustomer_Name.text = myResult.Customer_Name;
    self.txtCustomer_Address.text = myResult.Customer_Address;
    self.txtCustomer_Address_2.text = myResult.Customer_Address_2;
    self.txtCityState.text = myResult.CityState;
    self.txtZip.text = myResult.Zip;
    self.txtZip_4.text = myResult.Zip_4;
    self.txtPhone.text = myResult.Phone;
    [self.btnPhone setTitle:myResult.Phone forState:UIControlStateNormal];
    self.btnPhone.titleLabel.text = myResult.Phone;
    self.txtCode.text = [NSString stringWithFormat:@"%i", myResult.Code];
    self.txtCountry.text = [NSString stringWithFormat:@"%i", myResult.Country];
    self.txtCompany_Letter.text = myResult.Company_Letter;
    self.txtPassword.text = myResult.Password;
    dLong = [[myResult.Longitude stringValue] copy];
    dLat = [[myResult.Latitude stringValue] copy];
    
    self.txtssImage_Logo.text = myResult.ssImage_Logo;
    
    self.lblName.text = myResult.Customer_Name;
    self.lblAddress.text = myResult.Customer_Address;
    //self.lblAddress2.text = myResult.Customer_Address_2;
    self.lblAddress3.text = [NSString stringWithFormat:@"%@, %@", myResult.CityState, myResult.Zip];
    self.lblAccount.text = myResult.Account_Number;
    self.tbPhone.text = myResult.Phone;
    [selectedObject addObject:myResult];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityMain startAnimating];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate addGradient:btnMap];
    [myDelegate addGradient:btnOrders];
    [myDelegate addGradient:btnSave];
    [myDelegate addGradient:btnDirections];
    
    [self setupScreen:myDelegate];
}

- (void)viewDidUnload
{
    [self setLblName:nil];
    [self setLblAddress:nil];
    //[self setLblAddress2:nil];
    [self setLblAddress3:nil];
    [self setLblAccount:nil];
    [self setTbPhone:nil];
    [self setImhLogo:nil];
    [self setBtnMap:nil];
    [self setBtnOrders:nil];
    [self setTblData:nil];
    [self setBtnDirections:nil];
    [super viewDidUnload];
   [self setTxtCustomer_ID:nil];
   [self setTxtAccount_Number:nil];
   [self setTxtCustomer_Name:nil];
   [self setTxtCustomer_Address:nil];
   [self setTxtCustomer_Address_2:nil];
   [self setTxtCityState:nil];
   [self setTxtZip:nil];
   [self setTxtZip_4:nil];
   [self setTxtPhone:nil];
   [self setTxtCode:nil];
   [self setTxtCountry:nil];
   [self setTxtCompany_Letter:nil];
   [self setTxtPassword:nil];
   [self setTxtLongitude:nil];
   [self setTxtLatitude:nil];
   [self setTxtssImage_Logo:nil];
   [self setBtnSave:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc {
    [rawData removeAllObjects];
    [selectedObject removeAllObjects];
    //[selectedObject release];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SQLSTUDIOADVANCEDtbl_Orders_Result *myOrder = (SQLSTUDIOADVANCEDtbl_Orders_Result*)[rawData objectAtIndex:component];
    OrderView *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad)
    {

        web = [[OrderView alloc] initWithNibName:@"OrderView_iPad"
                                          bundle:nil
                                         orderID:myOrder.Order_ID
                                      customerID:selectedLocation
                                          poName:@""];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else
    {
        web = [[OrderView alloc] initWithNibName:@"OrderView"     bundle:nil  orderID:myOrder.Order_ID customerID:selectedLocation poName:@""];
        [self.navigationController  pushViewController:web animated:YES];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (rawData.count == 0)
    {
        return 1;
    }
    else
    {
        return  rawData.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    SQLSTUDIOADVANCEDtbl_Orders_Result   *myOrder = (SQLSTUDIOADVANCEDtbl_Orders_Result*)[rawData objectAtIndex:row];
    return myOrder.Order_Number;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = 300;
    return sectionWidth;
}













- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (rawData.count == 0)
//    {
//        return 1;
//    }
//    else
//    {
        return  rawData.count;
//    }
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
        labelName.backgroundColor = [UIColor clearColor];
        labelName.textColor = [UIColor blackColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails = [[UILabel alloc]initWithFrame:frame];
        lblDetails.tag = 2;
        [cell.contentView addSubview:lblDetails];
        lblDetails.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails.backgroundColor = [UIColor clearColor];
        lblDetails.textColor = [UIColor blackColor];
        
    }
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *detailLabel = (UILabel*)[cell.contentView viewWithTag:2];

    
    
    //SQLSTUDIOADVANCEDTodaysStop *myGSO = [rawDataDisplay objectAtIndex:indexPath.row];
    SQLSTUDIOADVANCEDtbl_Orders_Result   *myGSO = (SQLSTUDIOADVANCEDtbl_Orders_Result*)[rawData objectAtIndex:indexPath.row];
    nameLabel.text = [NSString stringWithFormat:@"Order Number: %@", myGSO.Order_Number];
    
    
    
    detailLabel.text = [NSString stringWithFormat:@"PO: %@",myGSO.PO_Number];

    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *myaccimage = [UIImage imageNamed:@"disclosure_indicator_blue.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myaccimage];
    [cell setAccessoryView:imageView];
    
    
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
    SQLSTUDIOADVANCEDtbl_Orders_Result *myOrder = (SQLSTUDIOADVANCEDtbl_Orders_Result*)[rawData objectAtIndex:indexPath.row];
    OrderView *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad)
    {
        web = [[OrderView alloc] initWithNibName:@"OrderView_iPad" bundle:nil orderID:myOrder.Order_ID customerID:selectedLocation poName:myOrder.Order_Number];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else
    {
        web = [[OrderView alloc] initWithNibName:@"OrderView" bundle:nil  orderID:myOrder.Order_ID customerID:selectedLocation poName:myOrder.Order_Number];
        [self.navigationController  pushViewController:web animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQLSTUDIOADVANCEDtbl_Orders_Result *myOrder = (SQLSTUDIOADVANCEDtbl_Orders_Result*)[rawData objectAtIndex:indexPath.row];
    OrderView *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad)
    {
        web = [[OrderView alloc] initWithNibName:@"OrderView_iPad" bundle:nil orderID:myOrder.Order_ID customerID:selectedLocation poName:myOrder.Order_Number];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else
    {
        web = [[OrderView alloc] initWithNibName:@"OrderView" bundle:nil  orderID:myOrder.Order_ID customerID:selectedLocation poName:myOrder.Order_Number];
        [self.navigationController  pushViewController:web animated:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    rawData = [myDelegate ListOrdersOfCustomer:selectedLocation];
    [tblData reloadData];
}
- (IBAction)btnDirections_Touch:(id)sender
{
    NSLog(@"btnDirections_Touch tbl_CustomerView.m");
    CLLocationManager  *locationManager;
    UIApplication *app = [UIApplication sharedApplication];
    
    locationManager = [[CLLocationManager alloc] init];
    //[locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];

    CLLocationCoordinate2D coordinate = [location coordinate];
    NSString *sLat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *sLong = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *theURL = [NSString stringWithFormat:@"https://maps.google.com/?saddr=%@,%@&daddr=%@,%@",sLat,sLong,dLong,dLat];
    NSString *theUrlCopy = [theURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [app openURL:[NSURL URLWithString: [NSString stringWithString:theUrlCopy]]];
    
}
- (IBAction)btnPhone_Touch:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",theButton.titleLabel.text]]];
}
@end
