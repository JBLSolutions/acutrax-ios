//
//  LoginView.h
//  Accidents
//
//  Created by Johnathan Rossitter on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "CoreView.h"
//define delagate
@class LoginView;
@protocol LoginViewDelegate

-(void)touchedOK:(LoginView *) controller;
@end

//define class
@interface LoginView : CoreView<LineaDelegate>
{
    //members
    IBOutlet UITextField *txtUser;
    IBOutlet UITextField *txtPassword;
    Linea* linea;
    IBOutlet UILabel *lblSwipeCard;
    IBOutlet UIButton *btnCancel;
}

//properties
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UITextField *txtUser;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) NSObject<LoginViewDelegate> *delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UILabel *lblSwipeCard;


//actions
- (IBAction)btnLogin_Touch:(id)sender;
- (IBAction)btnCancel_Touch:(id)sender;


@end
