//
//  TodaysStops.m
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TodaysStops.h"
#import "SPLAppDelegate.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import <CoreLocation/CoreLocation.h>
#import "OrderView.h"
#import "tbl_CustomerView.h"

@interface TodaysStops ()

@end

@implementation TodaysStops
@synthesize tblData;
@synthesize rawData;
@synthesize sbMain;
@synthesize rawDataDisplay;
@synthesize searchTimer;

bool IsSearchingTS;

-(void)searchTimerDidFinish:(NSTimer *) timer
{
    searchTimer = [[NSTimer alloc]init];
    
    IsSearchingTS = YES;
    if([sbMain.text length] ==0)
    {
        [rawDataDisplay removeAllObjects];
        [rawDataDisplay addObjectsFromArray:rawData];
    }
    else
    {
        [rawDataDisplay removeAllObjects];
        
        for(SQLSTUDIOADVANCEDTodaysStop *myPOI in rawData)
        {
            NSRange r = [[NSString stringWithFormat:@"%@ %@",myPOI.Customer_Name, myPOI.Zip] rangeOfString:sbMain.text options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound)
            {
                [rawDataDisplay addObject:myPOI];
            }
        }
    }
    IsSearchingTS = NO;
    [tblData reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
            self.title = @"Today's Stops";
        rawData = [[NSMutableArray alloc] init];
        rawDataDisplay = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



//search delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [sbMain resignFirstResponder];
    self.navigationItem.rightBarButtonItem=nil;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {  
    searchBar.showsScopeBar = YES;  
    [searchBar sizeToFit];  
    
    [searchBar setShowsCancelButton:YES animated:YES];  
    
    
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    if(iPad == YES)
    {
        searchBar.frame = CGRectMake(0, 64, 768, 44);
    }
    else
    {
        searchBar.frame = CGRectMake(0, 64, 320, 44);
    }
    
    return YES;  
}  

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {  
    searchBar.showsScopeBar = NO;  
    [searchBar sizeToFit];  
    
    [searchBar setShowsCancelButton:NO animated:YES];  
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    if(iPad == YES)
    {
        sbMain.frame =  CGRectMake(0, 64, 768, 44);
    }
    else
    {
        sbMain.frame =  CGRectMake(0, 64, 320, 44);
    }
    
    
    
    return YES;  
}

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



-(void)dealloc
{
    [rawData removeAllObjects];
    

}

- (void)viewDidUnload
{
    tblData = nil;
    rawData = nil;
    [self setRawData:nil];
    [self setSbMain:nil];
    [self setRawDataDisplay:nil];
    [super viewDidUnload];
}



-(void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [activityMain startAnimating];
    [rawData removeAllObjects];
    [rawDataDisplay removeAllObjects];
    [tblData reloadData];
    SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    rawData = [delegate ListTodaysStops];
    
    
    if([sbMain.text isEqualToString:@""])
    {
        [rawDataDisplay addObjectsFromArray:rawData];
    }
    else
    {
        IsSearchingTS = YES;
        if([sbMain.text length] ==0)
        {
            [rawDataDisplay removeAllObjects];
            [rawDataDisplay addObjectsFromArray:rawData];
        }
        else
        {
            [rawDataDisplay removeAllObjects];
            
            for(SQLSTUDIOADVANCEDTodaysStop *myPOI in rawData)
            {
                NSRange r = [[NSString stringWithFormat:@"%@",myPOI.Customer_Name] rangeOfString:sbMain.text options:NSCaseInsensitiveSearch];
                if(r.location != NSNotFound)
                {
                    [rawDataDisplay addObject:myPOI];
                }
            }
        }
        IsSearchingTS = NO;
        [tblData reloadData];
    }
    [tblData reloadData];
}




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
    if(IsSearchingTS == NO)
    {
        int count = (int)[rawDataDisplay count];
        if(count == 0)
        {
            return  1;
        }
        else
        {
            return [rawDataDisplay count];
        }
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([rawDataDisplay count] ==0)
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
            
            frame.origin.y += 20;
            UILabel *lblDetails2 = [[UILabel alloc]initWithFrame:frame];
            lblDetails2.tag = 3;
            [cell.contentView addSubview:lblDetails2];
            lblDetails2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            lblDetails2.backgroundColor = [UIColor clearColor];
            lblDetails2.textColor = [UIColor blackColor];
            
            
            
        }
        UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
 

        nameLabel.text = @"No Stops Listed";


        
        
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
    else
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
        
        frame.origin.y += 20;
        UILabel *lblDetails2 = [[UILabel alloc]initWithFrame:frame];
        lblDetails2.tag = 3;
        [cell.contentView addSubview:lblDetails2];
        lblDetails2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails2.backgroundColor = [UIColor clearColor];
        lblDetails2.textColor = [UIColor blackColor];
        

        
        
    }
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *detailLabel = (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *detailLabel2 = (UILabel*)[cell.contentView viewWithTag:3];

    
    SQLSTUDIOADVANCEDTodaysStop *myGSO = [rawDataDisplay objectAtIndex:indexPath.row];
    nameLabel.text = myGSO.Customer_Name;

    
    
    NSLog(@"cellForRowAtIndexPath TodaysStops.m");
    CLLocationManager  *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    //[locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; 
    locationManager.distanceFilter = kCLDistanceFilterNone; 
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    
    CLLocation *location = [locationManager location];
    

        
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    double longitude = [myGSO.Longitude doubleValue];
    double latitude = [myGSO.Latitude doubleValue];

    
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:coordinate.latitude  longitude:coordinate.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:longitude longitude:latitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    distance = distance * 0.000621371192;
    
    
    
    
    
    detailLabel.text = [NSString stringWithFormat:@"%@ - %.2f miles", myGSO.Zip, distance];
    
    detailLabel2.text = [NSString stringWithFormat:@"(%i) Ships (%i) Returns", myGSO.Ship, myGSO.Return];
   
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
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if([rawDataDisplay count] >0)
    {
    SQLSTUDIOADVANCEDTodaysStop *myGSO = [rawDataDisplay objectAtIndex:indexPath.row];
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
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([rawDataDisplay count] >0)
    {
    SQLSTUDIOADVANCEDTodaysStop *myGSO = [rawDataDisplay objectAtIndex:indexPath.row];
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
}

@end
