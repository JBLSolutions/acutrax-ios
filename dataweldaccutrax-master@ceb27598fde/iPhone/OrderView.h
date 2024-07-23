//
//  OrderView.h
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreView.h"
@interface OrderView : CoreView
{

    IBOutlet UIButton *btnMap;
    IBOutlet UILabel *lblCustomer;
    IBOutlet UITableView *tblData;
    NSMutableArray *rawData;
    IBOutlet UIButton *btnCloseOrder;

}

@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomer;

@property (strong, nonatomic) IBOutlet UIButton *btnShipTank;
@property (strong, nonatomic) IBOutlet UIButton *btnReturnTank;

@property (nonatomic, strong) IBOutlet UITableView *tblData;
@property (nonatomic,strong) NSMutableArray *rawData;
@property (strong, nonatomic) IBOutlet UIButton *btnCloseOrder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil customerID:(int)Customer_ID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil orderID:(int)Order_ID customerID:(int)Customer_ID poName:(NSString*)PO_Name;
- (IBAction)btnNewOrder_Touch:(id)sender;

- (IBAction)btnMap_Touch:(id)sender;
- (IBAction)btnShipTank_Touch:(id)sender;
- (IBAction)btnReturnTank_Touch:(id)sender;
- (IBAction)btnCloseOrder_Touch:(id)sender;

@end
