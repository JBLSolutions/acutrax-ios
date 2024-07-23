//
//  LineaProOptions.m
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LineaProOptions.h"
#import "SPLAppDelegate.h"

@interface LineaProOptions ()

@end

@implementation LineaProOptions
@synthesize lblIsDetected;
@synthesize lblCharge;
@synthesize lblBatt;
@synthesize lblBeep;
@synthesize swAutoCharge;
@synthesize swPlayBeep;
@synthesize battery;
@synthesize voltageLevel;
@synthesize txtDiags;


-(void)viewDidDisappear:(BOOL)animated  
{
    [super viewDidDisappear:animated];
    [linea disconnect];
    
}
-(void) viewDidAppear:(BOOL)animated
{

    
    [super viewDidAppear:animated];
    

    
    linea=[Linea sharedDevice];
    [linea addDelegate:self];
    [linea connect];
    
    
    
    
    SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(delegate.playBeep == YES)
    {
        self.swPlayBeep.on = YES;
    }
    else
    {
        self.swPlayBeep.on = NO;
    }
    
    if(delegate.autoChargeLineaPro == YES)
    {
        self.swAutoCharge.on   = YES;
    }
    else
    {
        self.swAutoCharge.on = NO;
    }

}

-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
           
            break;
		case CONN_CONNECTING:
			break;
		case CONN_CONNECTED:
            [self updateBattery];
            lblBatt.hidden = NO;
            lblBeep.hidden = NO;
            lblCharge.hidden = NO;
            swAutoCharge.hidden = NO;
            swPlayBeep.hidden = NO;
            lblIsDetected.hidden = YES;
            txtDiags.text = [NSString stringWithFormat:@"SDK version: %d.%d\n%@ %@ connected\nHardware revision: %@\nFirmware revision: %@\nSerial number: %@",linea.sdkVersion/100,linea.sdkVersion%100,linea.deviceName,linea.deviceModel,linea.hardwareRevision,linea.firmwareRevision,linea.serialNumber];
            break;
	}
}


-(void)updateBattery
{
    NSError *error=nil;
    
    int percent;
    float voltage;
    
	if([linea getBatteryCapacity:&percent voltage:&voltage error:&error])
    {
        [voltageLevel setText:[NSString stringWithFormat:@"%d%%",percent]];
        [battery setHidden:FALSE];
        [voltageLevel setHidden:FALSE];
        if(percent<0.1)
            [battery setImage:[UIImage imageNamed:@"0.png"]];
        else if(percent<40)
            [battery setImage:[UIImage imageNamed:@"25.png"]];
        else if(percent<60)
            [battery setImage:[UIImage imageNamed:@"50.png"]];
        else if(percent<80)
            [battery setImage:[UIImage imageNamed:@"75.png"]];
        else
            [battery setImage:[UIImage imageNamed:@"100.png"]];
    }else
    {
        [battery setHidden:TRUE];
        [voltageLevel setHidden:TRUE];
    }
    [self.view addSubview:battery];
    [self.view addSubview:voltageLevel];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
            self.title = @"Linea Pro Options";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSwPlayBeep:nil];
    [self setBattery:nil];
    [self setVoltageLevel:nil];
    [self setSwAutoCharge:nil];
    [self setTxtDiags:nil];
    [self setLblBeep:nil];
    [self setLblBatt:nil];
    [self setLblCharge:nil];
    [self setLblIsDetected:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)swPlayBeep_Touch:(id)sender 
{
SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
if(swPlayBeep.on == YES)
{
    delegate.playBeep = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"playBeep"];
}
else
{
    delegate.playBeep = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"playBeep"];
}

[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)swAutoCharge_Touch:(id)sender 
{
    SPLAppDelegate *delegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(swPlayBeep.on == YES)
    {
        delegate.autoChargeLineaPro = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoChargeLineaPro"];
        [linea setCharging:YES error:nil];
    }
    else
    {
        delegate.autoChargeLineaPro = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoChargeLineaPro"];
        [linea setCharging:NO error:nil];        
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
