//
//  OrderView.m
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderView.h"
#import "SPLAppDelegate.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
//#import "SQLSTUDIOServices.h"
#import "MapView2.h"
#import "ShipTank.h"
#import "CloseOrder.h"

@implementation OrderView

@synthesize btnMap;
@synthesize lblCustomer;
@synthesize btnShipTank;
@synthesize btnReturnTank;
@synthesize tblData;
@synthesize rawData;
@synthesize btnCloseOrder;

int selectedCustomer;
int selectedOrder;
NSString *orderNumberOV;
NSString *poNameOV;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerID:(int)Customer_ID; {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Order Details";
        selectedCustomer = Customer_ID;
        rawData =[[NSMutableArray alloc] init];
    }
    return self;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil orderID:(int)Order_ID customerID:(int)Customer_ID poName:(NSString*)PO_Name; {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        orderNumberOV = [[myDelegate resolveOrderNumber:Order_ID] copy];
        self.title = @"Order Details";
        selectedOrder = Order_ID;
        selectedCustomer = Customer_ID;
        rawData =[[NSMutableArray alloc] init];
        poNameOV = PO_Name;
    }
    return self;
}

- (IBAction)btnNewOrder_Touch:(id)sender {
}

- (IBAction)btnMap_Touch:(id)sender {
    MapView2 *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad)
    {
        web = [[MapView2 alloc] initWithNibName:@"MapView2_iPad" bundle:nil andCustomer:selectedCustomer];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else
    {
        web = [[MapView2 alloc] initWithNibName:@"MapView2" bundle:nil andCustomer:selectedCustomer];
        [self.navigationController  pushViewController:web animated:YES];    
    }   
}

- (IBAction)btnShipTank_Touch:(id)sender {
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    ShipTank  *newView;

    if(iPad == YES) {
        newView = [[ShipTank alloc] initWithNibName:@"ShipTank_iPad" bundle:nil formMode:1 customerID:selectedCustomer orderID:selectedOrder poName:poNameOV];
    }
    else {
        newView = [[ShipTank alloc] initWithNibName:@"ShipTank" bundle:nil formMode:1 customerID:selectedCustomer orderID:selectedOrder poName:poNameOV];
    }        
    [self.navigationController  pushViewController:newView animated:YES];
}

- (IBAction)btnReturnTank_Touch:(id)sender  {
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    ShipTank  *newView;
    
    if(iPad == YES) {
        newView = [[ShipTank alloc] initWithNibName:@"ShipTank_iPad" bundle:nil formMode:2 customerID:selectedCustomer orderID:selectedOrder poName:poNameOV];
    }
    else {
        newView = [[ShipTank alloc] initWithNibName:@"ShipTank" bundle:nil formMode:2 customerID:selectedCustomer orderID:selectedOrder poName:poNameOV];
    }        
    [self.navigationController  pushViewController:newView animated:YES];
}

- (IBAction)btnCloseOrder_Touch:(id)sender {
    CloseOrder *web;
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad) {
        web = [[CloseOrder alloc] initWithNibName:@"CloseOrder_iPad" bundle:nil andOrderNumber:orderNumberOV];
        [self.navigationController  pushViewController:web animated:YES];
    }
    else {
        web = [[CloseOrder alloc] initWithNibName:@"CloseOrder" bundle:nil andOrderNumber:orderNumberOV];
        [self.navigationController  pushViewController:web animated:YES];    
    } 
}


- (void)viewDidLoad {
    [super viewDidLoad];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate addGradient:btnCloseOrder];
    [myDelegate addGradient:btnMap];
    [myDelegate addGradient:btnReturnTank];
    [myDelegate addGradient:btnShipTank];
    if([myDelegate isCustomerVendor:selectedCustomer] == YES) {
        [btnShipTank setTitle:@"Receive" forState:UIControlStateNormal];
    }
    else {
        [btnShipTank setTitle:@"Ship" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [self setLblCustomer:nil];
    [self setBtnMap:nil];
    
    tblData = nil;
    rawData = nil;
    [self setRawData:nil];
    [self setBtnShipTank:nil];
    [self setBtnReturnTank:nil];
    [self setBtnCloseOrder:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [rawData removeAllObjects];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [activityMain startAnimating];
    [rawData removeAllObjects];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    rawData = [myDelegate ListItemsOfOrder:selectedOrder];
    [tblData reloadData];
    
	SQLSTUDIOADVANCEDtbl_Customer_Result *myResult = [myDelegate GetCustomer:selectedCustomer];
    self.lblCustomer.text = myResult.Customer_Name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rawData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        
        if(iPad == YES) {
            frame.size.width = 580;            
        }
        else {
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
        lblDetails.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        lblDetails.backgroundColor = [UIColor clearColor];
        lblDetails.textColor = [UIColor blackColor];
    }
    
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *detailLabel2 = (UILabel*)[cell.contentView viewWithTag:2];
    
    SQLSTUDIOADVANCEDOrderDetail *myGSO = [rawData objectAtIndex:indexPath.row];

    nameLabel.text = myGSO.Cylinder_Type;
    NSLog(@"nameLabel.text = %@", myGSO.Cylinder_Type);

    if(myGSO.Order_Type == 1) {
        detailLabel2.text = [NSString stringWithFormat:@"To Ship :%i | Shipped : (%i) | Volume (%@)", myGSO.Count,myGSO.Order_Status_ID,myGSO.Order_Number  ];
        detailLabel2.textColor = [UIColor greenColor];
    }
    else {
        detailLabel2.text = [NSString stringWithFormat:@"To Return :%i | Returned : (%i)", myGSO.Count,myGSO.Order_Status_ID];
        detailLabel2.textColor = [UIColor orangeColor];
    }
    
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
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
