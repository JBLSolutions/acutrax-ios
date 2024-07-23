//
//  Options.h
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreView.h"
#import "LoginView.h"
//#import "LineaSDK.h"


@interface Options : CoreView<LoginViewDelegate>
{
    IBOutlet UIButton *btnLineaPro;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnLogOut;
    IBOutlet UILabel *lblLoginAs;
//    Linea* linea;

}
@property (strong, nonatomic) IBOutlet UISwitch *swCopyTags;
@property (strong, nonatomic) IBOutlet UIPickerView *pcCloseOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnLineaPro;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UILabel *lblLoginAs;

- (IBAction)btnLineaPro_Touch:(id)sender;
- (IBAction)swCopyChanged:(id)sender;

@end
