//
//  LineaProOptions.h
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "CoreView.h"

@interface LineaProOptions : CoreView<LineaDelegate>
{
    IBOutlet UISwitch *swAutoCharge;
    IBOutlet UISwitch *swPlayBeep;
    IBOutlet UIImageView *battery;
    IBOutlet UILabel *voltageLevel;
    IBOutlet UITextView *txtDiags;
    Linea* linea;
}
@property (strong, nonatomic) IBOutlet UILabel *lblIsDetected;
@property (strong, nonatomic) IBOutlet UILabel *lblCharge;
@property (strong, nonatomic) IBOutlet UIView *lblBatt;
@property (strong, nonatomic) IBOutlet UILabel *lblBeep;
@property (strong, nonatomic) IBOutlet UISwitch *swAutoCharge;
@property (strong, nonatomic) IBOutlet UISwitch *swPlayBeep;
@property (strong, nonatomic) IBOutlet UIImageView *battery;
@property (strong, nonatomic) IBOutlet UILabel *voltageLevel;
@property (strong, nonatomic) IBOutlet UITextView *txtDiags;
- (IBAction)swPlayBeep_Touch:(id)sender;
- (IBAction)swAutoCharge_Touch:(id)sender;

@end
