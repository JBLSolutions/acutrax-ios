#import "HomeView.h"
#import "tbl_CustomerList.h"
#import "TodaysStops.h"
#import "SPLAppDelegate.h"
#import "SyncView.h"
#import "LoginView.h"
#import "VerifyTag.h"   

@implementation HomeView
@synthesize btnTodaysStops;
@synthesize btnCustomerList;
@synthesize btnDownloadOrders;

LoginView *myLoginViewHV;

-(void)updateTime
{
    if([[SyncService getSyncService] isSyncing]  == YES)
    {
        [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
    }
    else
    {
        [activityMain stopAnimating];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.title = @"Home";
        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = myDelegate.managedObjectContext   ;
//        BOOL iPad = NO;
//#ifdef UI_USER_INTERFACE_IDIOM
//        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
//#endif
        
//        if(iPad == YES)
//        {
//            myLoginViewHV = [[LoginView alloc] initWithNibName:@"LoginView_iPad" bundle:nil];
//        }
//        else
//        {
//            myLoginViewHV = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
//        }
        myLoginViewHV = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        myLoginViewHV.delegate = self;
    }
    return  self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.navigationController.navigationBar.translucent = NO;
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [myDelegate addGradient:btnTodaysStops];
//    [myDelegate addGradient:btnCustomerList];
//    [myDelegate addGradient:btnDownloadOrders];
    self.managedObjectContext = myDelegate.managedObjectContext   ;
    [activityMain stopAnimating];
}

- (void)viewDidUnload
{
    [self setBtnTodaysStops:nil];
    [self setBtnCustomerList:nil];
    [self setBtnDownloadOrders:nil]; 
    [self setBtnVerifyTag:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (IBAction)btnCustomerList_Touch:(id)sender 
{
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
      
    tbl_CustomerList *newView;
    if(iPad == YES)
    {
        newView = [[tbl_CustomerList alloc] initWithNibName:@"tbl_CustomerList_iPad" bundle:nil];
    }
    else
    {
        newView = [[tbl_CustomerList alloc] initWithNibName:@"tbl_CustomerList" bundle:nil];
    }        
    [self.navigationController  pushViewController:newView animated:YES];
    
}

- (IBAction)btnTodaysStops_Touch:(id)sender 
{
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    TodaysStops *newView;
    if(iPad == YES)
    {
        newView = [[TodaysStops alloc] initWithNibName:@"TodaysStops_iPad" bundle:nil];
    }
    else
    {
        newView = [[TodaysStops alloc] initWithNibName:@"TodaysStops" bundle:nil];
    }        
    [self.navigationController  pushViewController:newView animated:YES];
}
- (IBAction)btnDownloadOrders_Touch:(id)sender
{    
//    BOOL iPad = NO;
//#ifdef UI_USER_INTERFACE_IDIOM
//    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
//#endif
    
    SyncView *newView;
//    if(iPad == YES)
//    {
//        newView = [[SyncView alloc] initWithNibName:@"SyncView_iPad" bundle:nil];
//    }
//    else
//    {
//        newView = [[SyncView alloc] initWithNibName:@"SyncView" bundle:nil];
//    }
    newView = [[SyncView alloc] initWithNibName:@"SyncView" bundle:nil];
    [self.navigationController  pushViewController:newView animated:YES];

}


//delegate callback
-(void)touchedOK:(LoginView *)controller
{
    [activityMain stopAnimating];
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView beginAnimations:@"animation" context:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(myDelegate.userID == 0)
    {
    myLoginViewHV.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentModalViewController:myLoginView animated:YES];
    [self presentViewController:myLoginViewHV animated:YES completion:nil];
//    BOOL iPad = NO;
//#ifdef UI_USER_INTERFACE_IDIOM
//    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
//#endif
    
//    if(iPad == YES)
//    {
//        myLoginViewHV.view.frame = CGRectMake(-114,-200,768,1024);
//    }
//    else
//    {
//        myLoginViewHV.view.frame = CGRectMake(0, 30, 320, 600);
//    }
    }
}
- (IBAction)btnVerifyTag_Touch:(id)sender
{
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    VerifyTag *newView;
    if(iPad == YES)
    {
        newView = [[VerifyTag alloc] initWithNibName:@"VerifyTad_iPad" bundle:nil];
    }
    else
    {
        newView = [[VerifyTag alloc] initWithNibName:@"VerifyTag" bundle:nil];
    }
    [self.navigationController  pushViewController:newView animated:YES];
}
@end
