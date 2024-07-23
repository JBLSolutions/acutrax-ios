//
//  Options.m
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Options.h"
#import "LoginView.h"
#import "SPLAppDelegate.h"
#import "LineaProOptions.h"


@implementation Options

//members
@synthesize pcCloseOrder;
@synthesize btnLineaPro;
@synthesize btnLogin;
@synthesize btnLogOut;
@synthesize lblLoginAs;
@synthesize swCopyTags;
LoginView *myLoginView;

NSMutableArray *arrayNo;



//init
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [activityMain stopAnimating];        
        // Custom initialization
//        BOOL iPad = NO;
//#ifdef UI_USER_INTERFACE_IDIOM
//        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
//#endif
        
        myLoginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        
//        if(iPad == YES)
//        {
//            myLoginView = [[LoginView alloc] initWithNibName:@"LoginView_iPad" bundle:nil];            
//        }
//        else
//        {
//            myLoginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];            
//        }
        
        myLoginView.delegate = self;
    }
    return self;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [activityMain stopAnimating];
        
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
        
        if(iPad == YES)
        {
            myLoginView = [[LoginView alloc] initWithNibName:@"LoginView_iPad" bundle:nil];            
        }
        else
        {
            myLoginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];            
        }
        
        myLoginView.delegate = self;
    }
    return self;
    
    
}



-(void)viewDidDisappear:(BOOL)animated  
{
    [super viewDidDisappear:animated];   
    //[linea disconnect];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //btnLineaPro.hidden = YES;
    NSString *fN;
    NSString *lN;

    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"userID"] != 0)
    {
        
        fN = [[NSUserDefaults standardUserDefaults] stringForKey:@"Driver_First_Name"];
        lN = [[NSUserDefaults standardUserDefaults] stringForKey:@"Driver_Last_Name"];
        
        if(fN != nil && lN != nil)
        {
           // lblLoginAs.text = [NSString stringWithFormat:@"Logged In As : %@ %@", fN, lN];
        }
    }
    else
    {
            lblLoginAs.text = @"Please Log In to use AcuTrax";
    }
    

    
//    linea=[Linea sharedDevice];
//    [linea addDelegate:self];
//    [linea connect];
    
    SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [pcCloseOrder selectRow:delegate.closeOrderMode inComponent:0 animated:YES];
    swCopyTags.on = [[NSUserDefaults  standardUserDefaults] boolForKey:@"SaveTags"];

}

//-(void)connectionState:(int)state {
//	switch (state) {
//		case CONN_DISCONNECTED:
//		case CONN_CONNECTING:
//			break;
//		case CONN_CONNECTED:
//            NSLog(@"");
//            btnLineaPro.hidden = NO;
//            
//            break;
//	}
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.navigationController.navigationBar.translucent = NO;
        SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];

    if(delegate.userID ==0)
    {
        btnLogOut.hidden = YES;
        btnLogin.hidden = NO;  
    }
    else
    {
        btnLogOut.hidden = NO;
        btnLogin.hidden = YES;
    }
    // SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [myDelegate addGradient:btnLineaPro];
//    [myDelegate addGradient:btnLogin];
//    [myDelegate addGradient:btnLogOut];
    
    arrayNo = [[NSMutableArray alloc] init];
    [arrayNo addObject:@"Digital Signature"];
    [arrayNo addObject:@"Photo"];
    [arrayNo addObject:@"Card Swipe"];
    [arrayNo addObject:@"No Verification"];
    
    [pcCloseOrder selectRow:1 inComponent:0 animated:NO];
}

- (void)viewDidUnload
{
    [self setBtnLogin:nil];
    [self setBtnLogOut:nil];
    [self setLblLoginAs:nil];
    [self setBtnLineaPro:nil];
    [self setPcCloseOrder:nil];
    [self setSwCopyTags:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)btnLogOut_Touch:(id)sender 
{
    SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate logoutUser];
    btnLogOut.hidden = YES;
    btnLogin.hidden = NO;
    lblLoginAs.text = @"";
    lblLoginAs.text = @"Please Log In to use AcuTrax";
    
}

- (IBAction)btnLogin_Touch:(id)sender 
{
    
    [activityMain startAnimating];
    myLoginView.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:myLoginView animated:YES completion:nil];
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif

        if(iPad == YES)
        {
            myLoginView.view.frame = CGRectMake(-114,-200,768,1024);
        }
        else
        {
            myLoginView.view.frame = CGRectMake(0, 30, 320, 600);
        } 

    
    
    
}

//delegate callback
-(void)touchedOK:(LoginView *)controller   
{
    [activityMain stopAnimating];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [UIView beginAnimations:@"animation" context:nil];
    
        SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate]; 
    
    if(delegate.userID ==0)
    {
        [btnLogin setHidden:NO];
        [btnLogOut setHidden:YES];
    }
    else
    {
        [btnLogin setHidden:YES];
        [btnLogOut setHidden:NO];        
    }
    
}



- (IBAction)btnLineaPro_Touch:(id)sender 
{
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
       
    LineaProOptions *newView;
    if(iPad == YES)
    {
        newView = [[LineaProOptions alloc] initWithNibName:@"LineaProOptions_iPad" bundle:nil];
    }
    else
    {
        newView = [[LineaProOptions alloc] initWithNibName:@"LineaProOptions" bundle:nil];
    }        
    
    [self.navigationController  pushViewController:newView animated:YES];    
}

- (IBAction)swCopyChanged:(id)sender
{

    [[NSUserDefaults standardUserDefaults] setBool:swCopyTags.on forKey:@"SaveTags"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//picker control
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.closeOrderMode = (int)row;
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:@"CloseOrderMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrayNo count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrayNo objectAtIndex:row];
}

@end
