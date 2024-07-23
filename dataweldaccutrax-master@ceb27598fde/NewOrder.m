//
//  NewOrder.m
//  AcuTrax
//
//  Created by Johnathan Rossitter on 11/21/12.
//
//

#import "NewOrder.h"
#import "SPLAppDelegate.h"  
#import "ZBarSDK.h"
#import "LineaSDK.h"
#import "Linea+Connect.h"
#import "PRAVAuthorizationHelper.h"
@interface NewOrder()
@property (nonatomic, strong) PRAVAuthorizationHelper *cameraAuthHelper;
@end

@implementation NewOrder

@synthesize txtOrderNumber;
@synthesize txtPO;
@synthesize btnCreateOrder;



@synthesize btnSnapPhoto;
@synthesize imgPicker;





int selectedCustomerNO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Customer_ID:(int)Customer_ID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"New Order";
        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        [myDelegate addGradient:btnCreateOrder];
        selectedCustomerNO = Customer_ID;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cameraAuthHelper = [[PRAVAuthorizationHelper alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [linea disconnectMe:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    linea=[Linea sharedDevice];
    [linea connectMe:self];
}

- (void)viewDidUnload {
    [self setBtnCreateOrder:nil];
    [self setTxtPO:nil];
    [self setTxtOrderNumber:nil];
    [super viewDidUnload];
}
- (IBAction)btnCreateOrder_Touch:(id)sender
{

    
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate insertNewOrder:[NSDate date] :1 :txtOrderNumber.text :selectedCustomerNO :myDelegate.userID :txtPO.text];
    txtOrderNumber.text = @"";
    txtPO.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}


//laserbased barcode and magstrip
-(void)barcodeData:(NSString *)barcode type:(int)type
{
    NSString *foo =     [barcode stringByReplacingOccurrencesOfString:@"+" withString:@""];
    if([foo hasPrefix:@"%"])
    {
        self.txtOrderNumber.text = [foo substringFromIndex:1];
    }
    else
    {
        self.txtPO.text = foo;
    }
    

    
}



-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{

    if([track1 hasPrefix:@"%"])
    {
        self.txtOrderNumber.text = [track1 substringFromIndex:1];
    }
    else
    {
        self.txtPO.text = track1;
    }
    

    NSLog(@"...%@%@%@...", track1, track2, track3);
}


-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
			break;
		case CONN_CONNECTED:
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
            
            break;
	}
}



- (IBAction)btnScanBarcode_Touch:(id)sender
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
    if([foo hasPrefix:@"%"])
    {
        self.txtOrderNumber.text = [foo substringFromIndex:1];
    }
    else
    {
        self.txtPO.text = foo;
    }
    
    
        [reader dismissViewControllerAnimated:YES completion:nil];
    
    

}









@end
