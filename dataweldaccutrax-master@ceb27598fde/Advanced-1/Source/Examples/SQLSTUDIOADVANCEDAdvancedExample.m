/*
	SQLSTUDIOADVANCEDAdvancedExample.m
	Provides example and test runs the service's proxy methods.
	Generated by SudzC.com
*/
#import "SQLSTUDIOADVANCEDAdvancedExample.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"

@implementation SQLSTUDIOADVANCEDAdvancedExample

- (void)run {
	// Create the service
	SQLSTUDIOADVANCEDAdvanced* service = [SQLSTUDIOADVANCEDAdvanced service];
	service.logging = YES;
	// service.username = @"username";
	// service.password = @"password";
	

	// Returns int
	/*  */
    [service Create_tbl_Device_Transaction:self action:@selector(Create_tbl_Device_TransactionHandler:) Transaction_Date: @"" Transaction_Time: @"" Customer_Number: @"" Customer_Name: @"" Customer_Address: @"" Customer_City_State: @"" Common_Carrier: @"" Bill_Of_Lading: @"" Manifest: @"" Date_Shipped: @"" ID_Tag: @"" Cylinder_Type: @"" Owner: @"" Status: @"" Shipper_Reference: @"" Operator: @"" Location: @"" Company_Letter: @"" Truck_Number: @"" Order_Number: @"" Lot_Number: @"" Batch_Number: @"" Gas_Expiration_Date: @"" Sequence: @"" Product: @"" Category: @"" Transaction_Code: @"" Line_Item: @"" Cylinder_Volume: @"" Ownership_Code: @"" Dock_Location: @"" PO_Number: @"" Release_Number: @"" Transaction_Source: @"" Registration_Number: @"" Transaction_Status: 0 Callback: 0 Serial_Number: @""];

	// Returns SQLSTUDIOADVANCEDLogin_Token*
	/*  */
	[service Driver_Login:self action:@selector(Driver_LoginHandler:) User_Name: @"" Password: @"" Device_ID: @""];

	// Returns SQLSTUDIOADVANCEDLogin_Token*
	/*  */
	[service Driver_Login_By_DL:self action:@selector(Driver_Login_By_DLHandler:) DL_Tracks: @"" Device_ID: @""];

	// Returns int
	/*  */
	//[service EnrollPushNotifications:self action:@selector(EnrollPushNotificationsHandler:) Driver_ID: 0 Device: @""];

	// Returns NSMutableArray*
	/*  */
	[service Get_All_Customer_Locations_of_Driver:self action:@selector(Get_All_Customer_Locations_of_DriverHandler:) Driver_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Customers_Of_Driver:self action:@selector(Get_Customers_Of_DriverHandler:) Driver_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Customers_Of_Driver_After:self action:@selector(Get_Customers_Of_Driver_AfterHandler:) Driver_ID: 0 Customer_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Cylinders_Of_Driver:self action:@selector(Get_Cylinders_Of_DriverHandler:) Driver_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Items_Of_Order:self action:@selector(Get_Items_Of_OrderHandler:) Order_ID: 0 CallBack: 0];

	// Returns SQLSTUDIOADVANCEDCustomer_Location*
	/*  */
	[service Get_Location_Of_Customer:self action:@selector(Get_Location_Of_CustomerHandler:) Customer_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Order_Details_Of_Customer:self action:@selector(Get_Order_Details_Of_CustomerHandler:) Customer_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Order_Of_Driver:self action:@selector(Get_Order_Of_DriverHandler:) Driver_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Tags_Of_Driver:self action:@selector(Get_Tags_Of_DriverHandler:) Driver_ID: 0];

	// Returns NSMutableArray*
	/*  */
	[service Get_Tags_Of_Driver_After:self action:@selector(Get_Tags_Of_Driver_AfterHandler:) Driver_ID: 0 Tag_ID: 0];

	// Returns SQLSTUDIOADVANCEDTag_Result*
	/*  */
	[service Get_Tank_Data:self action:@selector(Get_Tank_DataHandler:) Serial_Code: @""];

	// Returns NSMutableArray*
	/*  */
	[service Get_Todays_Stops:self action:@selector(Get_Todays_StopsHandler:) Driver_ID: 0];

	// Returns NSString*
	/*  */
	[service UploadSignature:self action:@selector(UploadSignatureHandler:) _ByteArray: [NSData data] File_Name: @""];

	// Returns int
	/*  */
	[service UploadSwipeSignature:self action:@selector(UploadSwipeSignatureHandler:) FileName: @"" FileData: @""];
}

	

// Handle the response from Create_tbl_Device_Transaction.
		
- (void) Create_tbl_Device_TransactionHandler: (int) value {
			

	// Do something with the int result
		
	NSLog(@"Create_tbl_Device_Transaction returned the value: %@", [NSNumber numberWithInt:value]);
			
}
	

// Handle the response from Driver_Login.
		
- (void) Driver_LoginHandler: (id) value {

    
    NSLog(@"in loginhandler");
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the SQLSTUDIOADVANCEDLogin_Token* result
		SQLSTUDIOADVANCEDLogin_Token* result = (SQLSTUDIOADVANCEDLogin_Token*)value;
	NSLog(@"Driver_Login returned the value: %@", result);
			
}
	

// Handle the response from Driver_Login_By_DL.
		
- (void) Driver_Login_By_DLHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the SQLSTUDIOADVANCEDLogin_Token* result
		SQLSTUDIOADVANCEDLogin_Token* result = (SQLSTUDIOADVANCEDLogin_Token*)value;
	NSLog(@"Driver_Login_By_DL returned the value: %@", result);
			
}
	

// Handle the response from EnrollPushNotifications.
		
- (void) EnrollPushNotificationsHandler: (int) value {
			

	// Do something with the int result
		
	NSLog(@"EnrollPushNotifications returned the value: %@", [NSNumber numberWithInt:value]);
			
}
	

// Handle the response from Get_All_Customer_Locations_of_Driver.
		
- (void) Get_All_Customer_Locations_of_DriverHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_All_Customer_Locations_of_Driver returned the value: %@", result);
			
}
	

// Handle the response from Get_Customers_Of_Driver.
		
- (void) Get_Customers_Of_DriverHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Customers_Of_Driver returned the value: %@", result);
			
}
	

// Handle the response from Get_Customers_Of_Driver_After.
		
- (void) Get_Customers_Of_Driver_AfterHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Customers_Of_Driver_After returned the value: %@", result);
			
}
	

// Handle the response from Get_Cylinders_Of_Driver.
		
- (void) Get_Cylinders_Of_DriverHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Cylinders_Of_Driver returned the value: %@", result);
			
}
	

// Handle the response from Get_Items_Of_Order.
		
- (void) Get_Items_Of_OrderHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Items_Of_Order returned the value: %@", result);
			
}
	

// Handle the response from Get_Location_Of_Customer.
		
- (void) Get_Location_Of_CustomerHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the SQLSTUDIOADVANCEDCustomer_Location* result
		SQLSTUDIOADVANCEDCustomer_Location* result = (SQLSTUDIOADVANCEDCustomer_Location*)value;
	NSLog(@"Get_Location_Of_Customer returned the value: %@", result);
			
}
	

// Handle the response from Get_Order_Details_Of_Customer.
		
- (void) Get_Order_Details_Of_CustomerHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Order_Details_Of_Customer returned the value: %@", result);
			
}
	

// Handle the response from Get_Order_Of_Driver.
		
- (void) Get_Order_Of_DriverHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Order_Of_Driver returned the value: %@", result);
			
}
	

// Handle the response from Get_Tags_Of_Driver.
		
- (void) Get_Tags_Of_DriverHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Tags_Of_Driver returned the value: %@", result);
			
}
	

// Handle the response from Get_Tags_Of_Driver_After.
		
- (void) Get_Tags_Of_Driver_AfterHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Tags_Of_Driver_After returned the value: %@", result);
			
}
	

// Handle the response from Get_Tank_Data.
		
- (void) Get_Tank_DataHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the SQLSTUDIOADVANCEDTag_Result* result
		SQLSTUDIOADVANCEDTag_Result* result = (SQLSTUDIOADVANCEDTag_Result*)value;
	NSLog(@"Get_Tank_Data returned the value: %@", result);
			
}
	

// Handle the response from Get_Todays_Stops.
		
- (void) Get_Todays_StopsHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSMutableArray* result
		NSMutableArray* result = (NSMutableArray*)value;
	NSLog(@"Get_Todays_Stops returned the value: %@", result);
			
}
	

// Handle the response from UploadSignature.
		
- (void) UploadSignatureHandler: (id) value {

	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
			

	// Do something with the NSString* result
		NSString* result = (NSString*)value;
	NSLog(@"UploadSignature returned the value: %@", result);
			
}
	

// Handle the response from UploadSwipeSignature.
		
- (void) UploadSwipeSignatureHandler: (int) value {
			

	// Do something with the int result
		
	NSLog(@"UploadSwipeSignature returned the value: %@", [NSNumber numberWithInt:value]);
			
}
	

@end
		
