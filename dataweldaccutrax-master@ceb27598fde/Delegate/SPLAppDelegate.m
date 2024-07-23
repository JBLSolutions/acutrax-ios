#import "SPLAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import "DW_TransactionItem.h"
#import <MapKit/MapKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "NSString+Helpers.h"

@implementation SPLAppDelegate
@synthesize window = _window;
@synthesize tabBarController;
@synthesize userID;
@synthesize driverFirstName;
@synthesize driverLastName;
@synthesize playSounds;
@synthesize apnsID;
@synthesize imageCache;
@synthesize myDeviceToken;
@synthesize background;
@synthesize notificationCount;
@synthesize hasNotifications;
@synthesize isLineaProAttached;
@synthesize playBeep;
@synthesize autoChargeLineaPro;
@synthesize closeOrderMode;
@synthesize isSyncing;
@synthesize isBigSync;
@synthesize lastCylinderType;
@synthesize silentMode;
static NSInteger syncCount;

-(SyncService*) syncService {
    return [SyncService getSyncService];
}

- (void)logoutUser {
    [self flushCustomers];
    [self flushCylinderTypes];
    [self flushSentOrdersAndshowSyncAlert:false fromViewController:nil];
    [self flushTags];
    
    self.userID = 0;
    [self setDriverInitials:@""];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Driver_First_Name"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Driver_Last_Name"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getDriverInitials {
    return (NSString*)[[NSUserDefaults standardUserDefaults] stringForKey:@"operator"];
}
-(void)setDriverInitials:(NSString*)driverInitials {
    [[NSUserDefaults standardUserDefaults] setObject:driverInitials forKey:@"operator"];
}
-(BOOL)driverInitialsSet {
    return [NSString isNullOrEmpty:[self getDriverInitials]] == NO;
}

-(BOOL)isCustomerVendor:(int)CustomerID
{
    BOOL retVal = NO;
    sqlite3 *database;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select zzzvendor from zcustomer where zpkid = %i", CustomerID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                NSString *vendorType  = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)];
                if([vendorType isEqualToString:@"4"])
                {
                    retVal = YES;
                }
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return retVal;
}


-(int)checkShippedAgainstTransactions:(NSString*)orderName customerID:(int)Customer_ID
{
    int items = 0;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select count(*) from ZDEVICE_TRANSACTION where zstatus = 'CS' and  zorder_number = '%@' and zcustomer_number = %i",orderName, Customer_ID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                NSLog(@"****************");
                NSLog(@"%d", sqlite3_column_int(statement, 0));
                items = sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return items;
}
-(int)checkReceivedAgainstTransactions:(NSString*)orderName customerID:(int)Customer_ID
{
    int items = 0;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select count(*) from ZDEVICE_TRANSACTION where zstatus = 'DE' and  zorder_number = '%@' and zcustomer_number = %i",orderName, Customer_ID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                items = sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return items;
}

- (BOOL)CheckTagExistsInTransaction:(NSString*)TagID :(NSString*)OrderNumber :(int)customerNumber
{
    BOOL retVal = NO;
    sqlite3 *database;
    int counter =0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select COUNT(*) from ZDEVICE_TRANSACTION WHERE ZID_TAG = '%@' and ZORDER_NUMBER = '%@' and ZCUSTOMER_NUMBER = %i", TagID, OrderNumber, customerNumber];
        NSLog(@"%@",TagID);
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                counter = sqlite3_column_int(statement, 0);
                if(counter >0)
                {
                    retVal = YES;
                }
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return retVal;
}
-(BOOL)CustomerHasOrder:(int)CustomerID
{
    BOOL retVal = NO;
    sqlite3 *database;
    int counter =0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"SELECT COUNT(*) FROM ZORDER zo INNER JOIN ZCUSTOMER zc ON zo.ZCUSTOMER = zc.ZPKID  WHERE zc.ZPKID = %i",CustomerID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                counter = sqlite3_column_int(statement, 0);
                if(counter >0)
                {
                    retVal = YES;
                }
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return retVal;
}
-(NSString*)stringFromDate:(NSDate*)theDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM_dd_yyyy_HH_mm_ss"];
    return [formatter stringFromDate:theDate];
}
-(NSDate*)dateFromString:(NSString*)theString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM_dd_yyyy_HH_mm_ss"];
    return [formatter dateFromString:theString];
}

//LAT AND LONG
-(double)GetLat
{
    NSLog(@"Getlat SPLAppDelegate.m");
    CLLocationCoordinate2D zoomLocation;
    CLLocationManager  *locationManager;
    locationManager = [[CLLocationManager alloc] init];

    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    CLLocation *location = [locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    zoomLocation.latitude = coordinate.latitude;
    zoomLocation.longitude = coordinate.longitude;
    return zoomLocation.latitude;
}
-(double)GetLong
{
    NSLog(@"Getlong SPLAppDelegate.m");
    CLLocationCoordinate2D zoomLocation;
    CLLocationManager  *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;

    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    CLLocation *location = [locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    zoomLocation.latitude = coordinate.latitude;
    zoomLocation.longitude = coordinate.longitude;
    return zoomLocation.longitude;
}

/*Internal SQL*/
//TRANSACTIONS


-(void)handleTransactionSubmit:(id)result
{
    
    if([result isKindOfClass:[SoapFault class]])
    {
        
    }
    else
    {
        if([result isKindOfClass:[NSError class]])
        {
            NSError *MyError = (NSError*) result;
            if(MyError.code == 410)
            {
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Network"
                                              message:@"Your Network Connection is not Present"
                                              preferredStyle:UIAlertControllerStyleAlert];
                

                UIAlertAction* noButton = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                
                [alert addAction:noButton];
                
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                self.isSyncing = NO;
            }
            return;
        }
    }
    NSNumber *retVal = (NSNumber*)result;
    int foo = [retVal intValue];
    if([retVal intValue] >0)
    {
        sqlite3 *database;

        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
        const char *path = [m_DatabasePath UTF8String];
        if(sqlite3_open(path, &database) == SQLITE_OK)
        {
            NSString *myStatement = [NSString stringWithFormat:@"DELETE FROM ZDEVICE_TRANSACTION WHERE Z_PK = %i",foo];
            const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
            sqlite3_stmt *statement;
            if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
            {
                if(SQLITE_DONE != sqlite3_step(statement))
                {
                    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                }

            }
            else
            {
                NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    
}
-(void)flushSentOrdersAndshowSyncAlert:(BOOL)showSyncAlert fromViewController:(UIViewController*)viewController {
    sqlite3 *database;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"DELETE FROM ZORDER WHERE ZSTATUS = 2"];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }

        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);

    if (!showSyncAlert) {
        syncCount = 0;
        return;
    }
    
    UIAlertController *alert;
    UIAlertAction *okButton;
    if (syncCount == 0) {
        alert = [UIAlertController
                                      alertControllerWithTitle:@"Synchronization Complete"
                                      message:@"Your files have been uploaded and you have been logged out"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       [self logoutUser];
                                       UINavigationController *nav = viewController.navigationController;
                                       [nav popViewControllerAnimated:YES];
                                   }];
        
        
    } else {
        alert = [UIAlertController
                                      alertControllerWithTitle:@"Synchronization Partially Complete"
                                      message:[[NSString alloc]  initWithFormat:@"%@ %@", [@(syncCount) stringValue], @"item(s) did not upload.  Please ensure you have a good internet connection and upload again."]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];        
    }
    [alert addAction:okButton];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
    syncCount = 0;
}

- (NSArray*)unSynchedSignatureFiles {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *bundleDirectory = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"];
    NSArray *pngFiles = [bundleDirectory filteredArrayUsingPredicate:filter];
    return pngFiles;
}

- (NSUInteger)unSynchedSignatureCount {
    return [[self unSynchedSignatureFiles] count];
}

-(void)syncSignatures
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *pngFiles = [self unSynchedSignatureFiles];
    syncCount = [pngFiles count];
    for (NSString *tString in pngFiles)
    {
        NSLog(@"%@", tString);
            
        NSData *imgData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, tString]];
        SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
        service.logging = NO;
        [service UploadSignature:self action:@selector(handleSignature:) _ByteArray:imgData File_Name:tString];
    }
}

-(void)handleSignature:(id)result
{
    [[self syncService] finishSyncTaskSilent];
    if([result isKindOfClass:[NSError class]])
    {
        NSError *MyError = (NSError*) result;
        if(MyError.code == 410)
        {
            [[self syncService] finishSyncTaskWithAlertTitle:@"Network" andMessage:@"Your Network Connection is not Present" andButtonTitle:@"Cancel"];
            
        }
        return;
    }
    NSString *val = (NSString*)result;
    if(val.length > 0)
    {
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        //delete the file
         NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectory, val] error:&error] != YES)
        {
            NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
        syncCount -= 1;
    }
}
-(void)syncTransactions
{
    self.isSyncing = YES;
    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    service.logging = NO;


    sqlite3 *database;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        
        NSString *myStatement = [NSString stringWithFormat:@"SELECT * FROM ZDEVICE_TRANSACTION"];
        const char *sqlStatementExceptions = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        sqlite3_stmt *statementExceptions;
        
        
        if( sqlite3_prepare_v2(database, sqlStatementExceptions, -1, &statementExceptions, NULL) == SQLITE_OK )
        {
            
            while( sqlite3_step(statementExceptions) == SQLITE_ROW )
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.year = 31;
                
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 1)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 2)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 3)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 4)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 5)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 6)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 7)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 8)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 12)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 13)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 14)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 15)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 16)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 17)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 18)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 19)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 20)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 21)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 22)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 23)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 24)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 25)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 26)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 27)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 28)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 29)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 30)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 31)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 32)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 33)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 34)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 35)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 36)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 37)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 38)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 39)]);
                NSLog(@"Batch Numbers: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 40)]);
                
                
                
                NSLog(@"%@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)]);
                
                NSString *shipperReference = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 30)];
                [service Create_tbl_Device_Transaction:self
                                                action:@selector(handleTransactionSubmit:)
                                      Transaction_Date:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 33)]
                                      Transaction_Time:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 36)]
                                       Customer_Number:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)]
                                         Customer_Name:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)]
                                      Customer_Address:@""
                                   Customer_City_State:@""
                                        Common_Carrier:@""
                                        Bill_Of_Lading:@""
                                              Manifest:@""
                                          Date_Shipped:@""
                                                ID_Tag:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 16)]
                                         Cylinder_Type:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)]
                                                 Owner:@""
                                                Status:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 31)]
                                     Shipper_Reference:shipperReference
                                              Operator:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 21)]
                                              Location:@""
                                        Company_Letter:@""
                                          Truck_Number:@""
                                          Order_Number:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 22)]
                                            Lot_Number:@""
                                          Batch_Number:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions,3)]
                                   Gas_Expiration_Date:@""
                                              Sequence:@""
                                               Product:@""
                                              Category:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 1)]
                                      Transaction_Code:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 32)]
                                             Line_Item:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 17)]
                                       Cylinder_Volume:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 12)]
                                        Ownership_Code:@""
                                         Dock_Location:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 14)]
                                             PO_Number:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 25)]
                                        Release_Number:@""
                                    Transaction_Source:@""
                                   Registration_Number:@""
                                    Transaction_Status:1
                                              Callback:sqlite3_column_int(statementExceptions, 0)
                                         Serial_Number:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 37)]
                 
                 ];

            }
        }
        sqlite3_finalize(statementExceptions);
        
    }
    [[self syncService] finishSyncTaskSilent];
}

//CYLINDERS
-(NSMutableArray*)listAllTypes
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];

    sqlite3 *database;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        
        NSString *myStatement = [NSString stringWithFormat:@"select * from zcylinder_type order by ZCT_TYPE"];
        const char *sqlStatementExceptions = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        sqlite3_stmt *statementExceptions;
        
        
        if( sqlite3_prepare_v2(database, sqlStatementExceptions, -1, &statementExceptions, NULL) == SQLITE_OK )
        {
            
            while( sqlite3_step(statementExceptions) == SQLITE_ROW )
            {

                SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *cyl = [[SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result alloc]init];
//                NSLog(@"1: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 1)]);
//                NSLog(@"2: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 2)]);
//                NSLog(@"3: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 3)]);
//                NSLog(@"4: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 4)]);
//                NSLog(@"5: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 5)]);
//                NSLog(@"6: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 6)]);
//                NSLog(@"7: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 7)]);
//                NSLog(@"8: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 8)]);
//                NSLog(@"9: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)]);
//                NSLog(@"10: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)]);
//                NSLog(@"11: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)]);
//                NSLog(@"12: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 12)]);
//                NSLog(@"13: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 13)]);
//                NSLog(@"14: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 14)]);
//                NSLog(@"15: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 15)]);
//                NSLog(@"16: %@",[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 16)]);
                
                cyl.Cylinder_Type_ID = sqlite3_column_int(statementExceptions, 6);
                cyl.Cylinder_Type = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 15)];
                cyl.Description_1 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 8)];
                cyl.Description_2 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)];
                cyl.Description_3 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)];
                cyl.Description_4 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)];
                
                if([cyl.Description_1 isEqualToString:@"(null)"])
                {
                    cyl.Description_1 = @"";
                }
                if([cyl.Description_2 isEqualToString:@"(null)"])
                {
                    cyl.Description_2 = @"";
                }
                if([cyl.Description_3 isEqualToString:@"(null)"])
                {
                    cyl.Description_3 = @"";
                }
                if([cyl.Description_4 isEqualToString:@"(null)"])
                {
                    cyl.Description_4 = @"";
                }
                
                cyl.Maintain_Volume =(sqlite3_column_int(statementExceptions, 4) == 1);
                [retVal addObject:cyl];
                cyl  = nil;
            }
        }
        sqlite3_finalize(statementExceptions);
        
    }
    return retVal;
}
-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)getCylinderTypeByPKID:(int)ID
{
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *retVal = [[SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result alloc]init];
    retVal.Cylinder_Type = @"Item ID Not Recognized";
    sqlite3 *database;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        
        NSString *myStatement = [NSString stringWithFormat:@"select * from zcylinder_type where zpkid = %i order by ZCT_DESCRIPTION",ID];
        const char *sqlStatementExceptions = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        sqlite3_stmt *statementExceptions;
        
        
        if( sqlite3_prepare_v2(database, sqlStatementExceptions, -1, &statementExceptions, NULL) == SQLITE_OK )
        {
            
            while( sqlite3_step(statementExceptions) == SQLITE_ROW )
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.year = 31;
                retVal.Cylinder_Type_ID = sqlite3_column_int(statementExceptions, 6);
                retVal.Cylinder_Type = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 8)];
                retVal.Description_1 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)];
                retVal.Description_2 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)];
                retVal.Description_3 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)];
                retVal.Description_4 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 12)];
                retVal.UN_Number = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 16)];
                retVal.Track_Type = (sqlite3_column_int(statementExceptions, 3) == 1);
                retVal.Maintain_Volume =(sqlite3_column_int(statementExceptions, 4) == 1);
                retVal.Category = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 1)];
                if([retVal.Description_1 isEqualToString:@"(null)"])
                {
                    retVal.Description_1 = @"";
                }
                if([retVal.Description_2 isEqualToString:@"(null)"])
                {
                    retVal.Description_2 = @"";
                }
                if([retVal.Description_3 isEqualToString:@"(null)"])
                {
                    retVal.Description_3 = @"";
                }
                if([retVal.Description_4 isEqualToString:@"(null)"])
                {
                    retVal.Description_4 = @"";
                }
                
            }
        }
        sqlite3_finalize(statementExceptions);
        
    }
    return retVal;
    
}
-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)resolveTankBySerial:(NSString*)Serial
{
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *retVal = [[SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result alloc]init];
    retVal.Cylinder_Type = @"Item ID Not Recognized";
    sqlite3 *database;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        
        NSString *myStatement = [NSString stringWithFormat:@"select zct.*,zt.ZTAGID  from ztag zt inner join zcylinder_type zct on zt.ZCYLINDERTYPE = zct.ZPKID WHERE zt.ZSERIAL = '%@' COLLATE NOCASE",Serial];
        const char *sqlStatementExceptions = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        sqlite3_stmt *statementExceptions;
        
        
        if( sqlite3_prepare_v2(database, sqlStatementExceptions, -1, &statementExceptions, NULL) == SQLITE_OK )
        {
            
            while( sqlite3_step(statementExceptions) == SQLITE_ROW )
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.year = 31;
                retVal.Cylinder_Type_ID = sqlite3_column_int(statementExceptions, 6);
                retVal.Cylinder_Type = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 15)];//ksl changed from 14 to 15 to match resolveTank
                retVal.Description_1 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)];
                retVal.Description_2 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)];
                retVal.Description_3 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)];
                retVal.Description_4 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 12)];
                retVal.UN_Number = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 16)];
                retVal.TagID = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 17)];
                retVal.Serial_Number = Serial;//ksl this was never being set on the return object
                retVal.Track_Type = (sqlite3_column_int(statementExceptions, 3) == 1);
                retVal.Category = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 8)];//ksl changed from 1 to 8 to match resolveTank
                retVal.Maintain_Volume =(sqlite3_column_int(statementExceptions, 4) == 1);
                if([retVal.Description_1 isEqualToString:@"(null)"])
                {
                    retVal.Description_1 = @"";
                }
                if([retVal.Description_2 isEqualToString:@"(null)"])
                {
                    retVal.Description_2 = @"";
                }
                if([retVal.Description_3 isEqualToString:@"(null)"])
                {
                    retVal.Description_3 = @"";
                }
                if([retVal.Description_4 isEqualToString:@"(null)"])
                {
                    retVal.Description_4 = @"";
                }
            }
        }
        sqlite3_finalize(statementExceptions);
        
    }
    return retVal;

}
-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)resolveTankByID:(int)ID
{
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *retVal = [[SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result alloc]init];
    retVal.Cylinder_Type = @"Item ID Not Recognized";
    retVal.Description_2 = @"Item ID Not Found";
    sqlite3 *database;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        
        NSString *myStatement = [NSString stringWithFormat:@"select zct.*,zt.ZSerial from ztag zt inner join zcylinder_type zct on zt.ZCYLINDERTYPE = zct.ZPKID WHERE zt.ZCYLINDERTYPE = %i COLLATE NOCASE",ID];
        const char *sqlStatementExceptions = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        sqlite3_stmt *statementExceptions;
        
        
        if( sqlite3_prepare_v2(database, sqlStatementExceptions, -1, &statementExceptions, NULL) == SQLITE_OK )
        {
            
            while( sqlite3_step(statementExceptions) == SQLITE_ROW )
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.year = 31;
                retVal.Cylinder_Type_ID = sqlite3_column_int(statementExceptions, 6);
                retVal.Cylinder_Type = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 8)];
                retVal.Description_1 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)];
                retVal.Description_2 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)];
                retVal.Description_3 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)];
                retVal.Description_4 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 12)];
                retVal.Track_Type = (sqlite3_column_int(statementExceptions, 3) == 1);
                retVal.Maintain_Volume =(sqlite3_column_int(statementExceptions, 4) == 1);
                retVal.UN_Number =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 16)];
                retVal.Category = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 1)];
                if([retVal.Description_1 isEqualToString:@"(null)"])
                {
                    retVal.Description_1 = @"";
                }
                if([retVal.Description_2 isEqualToString:@"(null)"])
                {
                    retVal.Description_2 = @"";
                }
                if([retVal.Description_3 isEqualToString:@"(null)"])
                {
                    retVal.Description_3 = @"";
                }
                if([retVal.Description_4 isEqualToString:@"(null)"])
                {
                    retVal.Description_4 = @"";
                }
                
            }
        }
        sqlite3_finalize(statementExceptions);
        
    }
    return retVal;
}

-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)resolveTank:(NSString*)Tag
{
    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *retVal = [[SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result alloc]init];
    retVal.Cylinder_Type = @"Item ID Not Recognized";
    retVal.Description_2 = @"Item ID Not Found";
    sqlite3 *database;
    
    NSLog(@"Tag: %@",Tag);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        
        NSString *myStatement = [NSString stringWithFormat:@"select zct.*,zt.ZSerial from ztag zt inner join zcylinder_type zct on zt.ZCYLINDERTYPE = zct.ZPKID WHERE lower(ltrim(rtrim(zt.ZTAGID))) = lower(ltrim(rtrim('%@'))) COLLATE NOCASE",Tag];
        const char *sqlStatementExceptions = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        sqlite3_stmt *statementExceptions;
        
        
        if( sqlite3_prepare_v2(database, sqlStatementExceptions, -1, &statementExceptions, NULL) == SQLITE_OK )
        {

            while( sqlite3_step(statementExceptions) == SQLITE_ROW )
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.year = 31;
                retVal.Cylinder_Type_ID = sqlite3_column_int(statementExceptions, 6);
                retVal.Cylinder_Type = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 15)];
                retVal.Description_1 = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 9)];
                retVal.Description_2 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 10)];
                retVal.Description_3 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 11)];
                retVal.Description_4 =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 12)];
                retVal.Track_Type = (sqlite3_column_int(statementExceptions, 3) == 1);
                retVal.Category = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 8)];
                retVal.Maintain_Volume =(sqlite3_column_int(statementExceptions, 4) == 1);
                retVal.UN_Number =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 16)];
                retVal.Serial_Number =[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statementExceptions, 17)];
                retVal.TagID = Tag; //ksl this was never being set on the return item.
                //32
                //13 is Proper_Name_1
                //7 is hazard_class, weight or track_type
                //5 is Customer_ID
                if([retVal.Description_1 isEqualToString:@"(null)"])
                {
                    retVal.Description_1 = @"";
                }
                if([retVal.Description_2 isEqualToString:@"(null)"])
                {
                    retVal.Description_2 = @"";
                }
                if([retVal.Description_3 isEqualToString:@"(null)"])
                {
                    retVal.Description_3 = @"";
                }
                if([retVal.Description_4 isEqualToString:@"(null)"])
                {
                    retVal.Description_4 = @"";
                }

            }
        }
        sqlite3_finalize(statementExceptions);
        
    }
    return retVal;
}

-(BOOL)checkCylinderExists:(int)cylinderID
{
    BOOL retVal = NO;
    sqlite3 *database;
    int counter =0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select COUNT(*) AS RecordCount from ZCYLINDER_TYPE WHERE ZPKID = %i",cylinderID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                counter = sqlite3_column_int(statement, 0);
                if(counter >0)
                {
                    retVal = YES;
                }
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return retVal;
}
-(void)flushCylinderTypes
{
    sqlite3 *database;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"DELETE FROM ZCYLINDER_TYPE"];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }

        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
-(void)downloadCylinderTypes
{
    //pull the cylinder list down from the web service
    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    service.logging = NO;
    [service Get_Cylinders_Of_Driver:self action:@selector(handleCylinderList:) Driver_ID:self.userID];
}
-(void)handleCylinderList:(id)result
{
    
    if([result isKindOfClass:[SoapFault class]])
    {
        [[self syncService] finishSyncTaskSilent];
        return;
    }
    else
    {
        if([result isKindOfClass:[NSError class]])
        {
            NSError *MyError = (NSError*) result;
            if(MyError.code == 410)
            {
                [[self syncService] finishSyncTaskWithAlertTitle:@"Network" andMessage:@"Your Network Connection is not Present" andButtonTitle:@"Cancel"];
            }
            return;
        }
    }
    [self flushCylinderTypes];
    NSMutableArray *myData = (NSMutableArray*)result;
    
    sqlite3 *database;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        sqlite3_exec(database, "BEGIN", 0, 0, 0);
        
    for(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *myPOI in myData)
    {
        if([self checkCylinderExists:myPOI.Cylinder_Type_ID] == NO)
        {
                int trackIT;
                int VolumeIT;
                if(myPOI.Track_Type == YES)
                {
                    trackIT = 1;
                }
                else
                {
                    trackIT =0;
                }
                
                if(myPOI.Maintain_Volume == YES)
                {
                    VolumeIT = 1;
                }
                else
                {
                    VolumeIT = 0;
                }
                
                
                NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZCYLINDER_TYPE (ZCT_TRACK, ZCT_VOLMNT, ZCT_HAZCLS, ZCUSTOMER_ID, ZCT_DESCRIPTION, ZCT_PROP1, ZCT_PROP2, ZCT_PROP3, ZCT_PROP4, ZCT_PROP5, ZCT_TYPE, ZCT_UNNO,ZPKID,ZCT_CATEGORY) VALUES (%i ,%i ,%f ,%i, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@',%i,'%@');",trackIT,VolumeIT,[myPOI.Hazzard_Class doubleValue] , myPOI.Customer_ID,myPOI.Description_1, myPOI.Proper_Name_1,myPOI.Proper_Name_2,myPOI.Proper_Name_3, myPOI.Proper_Name_4,myPOI.Proper_Name_5,myPOI.Cylinder_Type, myPOI.UN_Number,myPOI.Cylinder_Type_ID,myPOI.Category];
                const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
                sqlite3_stmt *statement;
                if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
                {
                    if(SQLITE_DONE != sqlite3_step(statement))
                    {
                        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                    }

                }
                else
                {
                    NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
        }
    }
        sqlite3_exec(database, "COMMIT", 0, 0, 0);
    sqlite3_close(database);
    if(silentMode == NO)
    {
        [[self syncService] finishSyncTask];
    } else {
        [[self syncService] finishSyncTaskSilent];
    }

}

//TAGS

-(void)addSingleTag:(int)CustomerID :(int)CYlinderType :(int)TagID :(NSString*)Serial :(NSString*)Tag
{
    sqlite3 *database;
    NSLog(@"addSingleTag tag : %@",Tag);
    NSLog(@"addSingleTag CustomerID : %d",CustomerID);
    NSLog(@"addSingleTag CYlinderType : %d",CYlinderType);
    NSLog(@"addSingleTag TagID : %d",TagID);
    NSLog(@"addSingleTag Serial : %@",Serial);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
      NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZTAG (ZCUSTOMERID, ZCYLINDERTYPE, ZPKID, ZSERIAL, ZTAGID) VALUES (%i ,%i ,%i , '%@', '%@');",CustomerID,CYlinderType,TagID,Serial,Tag];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }
            
        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

-(void)flushTags
{
    sqlite3 *database;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"DELETE FROM ZTAG"];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }

        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
-(void)downloadTags
{
   
    self.tagsFlushed = NO;
    //pull the cylinder list down from the web service
    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    service.logging = NO;
    [service Get_Tags_Of_Driver:self action:@selector(handleTags:) Driver_ID:self.userID];
}
-(void)handleTags:(id)result
{
    NSLog(@"Got Data");
    if([result isKindOfClass:[SoapFault class]])
    {
        [[self syncService] finishSyncTaskSilent];
        return;
    }
    else
    {
        if([result isKindOfClass:[NSError class]])
        {
            NSError *MyError = (NSError*) result;
            if(MyError.code == 410)
            {
                [[self syncService] finishSyncTaskWithAlertTitle:@"Network" andMessage:@"Your Network Connection is not Present" andButtonTitle:@"Cancel"];
            }
            return;
        }
    }
    if (!self.tagsFlushed) {
        [self flushTags];
        self.tagsFlushed = YES;
    }
    int lastTag=0;
    NSMutableArray *myData = (NSMutableArray*)result;
    NSLog(@"Start Write to SQL");
    sqlite3 *database;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
        int tagsWithSpaces = 0;
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
            sqlite3_exec(database, "BEGIN", 0, 0, 0);
    for(SQLSTUDIOADVANCEDTag_Result *myPOI in myData)
    {
        lastTag = myPOI.Tag_ID;

            if ([myPOI.tagID isEqualToString:@"CW078506"] || myPOI.Tag_ID == 14056444)
            {
                NSLog(@"%i ,%i ,%i , '%@', '%@'",myPOI.Customer_ID, myPOI.Cylinder_Type,myPOI.Tag_ID,myPOI.Serial_Number,myPOI.tagID);
            }
        
            if ([myPOI.tagID containsString:@" "]) {
                NSLog(@"Has space : %i , '%@'",myPOI.Tag_ID, myPOI.tagID);
                tagsWithSpaces++;
            }
            NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZTAG (ZCUSTOMERID, ZCYLINDERTYPE, ZPKID, ZSERIAL, ZTAGID) VALUES (%i ,%i ,%i , '%@', '%@');",myPOI.Customer_ID, myPOI.Cylinder_Type,myPOI.Tag_ID,myPOI.Serial_Number,myPOI.tagID];
            const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
            sqlite3_stmt *statement;
            if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
            {
                if(SQLITE_DONE != sqlite3_step(statement))
                {
                    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                }

            }
            else
            {
                NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
    }
        sqlite3_exec(database, "COMMIT", 0, 0, 0);
sqlite3_close(database);
    NSLog(@"End Write to SQL");
    if(myData.count >0)
    {
        SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
        service.logging = NO;
        [service Get_Tags_Of_Driver_After:self action:@selector(handleTags:) Driver_ID:self.userID Tag_ID:lastTag];
    }
    else
    {
        NSLog(@"tags with spaces %i",tagsWithSpaces);
       NSLog(@"No More Data");
        if(silentMode == NO)
        {
            [[self syncService] finishSyncTask];
        } else {
            [[self syncService] finishSyncTaskSilent];
        }
        self.isBigSync = YES;
    }
}

//CUSTOMERS
-(void)flushCustomers
{
    sqlite3 *database;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"DELETE FROM ZCUSTOMER"];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }

        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
-(void)downloadCustomers
{
    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    service.logging = NO;
    [service Get_Customers_Of_Driver:self action:@selector(handleDownloadCustomers:) Driver_ID:self.userID];
}
-(void)handleDownloadCustomers:(id)result
{
    int lastCustomer = 0;
    if([result isKindOfClass:[SoapFault class]])
    {
        self.isSyncing = NO;
        if (self.isBigSync)
            self.isBigSync = NO;
        return;
    }
    else
    {
        if([result isKindOfClass:[NSError class]])
        {
            NSError *MyError = (NSError*) result;
            if(MyError.code == 410)
            {
                [[self syncService] finishSyncTaskWithAlertTitle:@"Network" andMessage:@"Your Network Connection is not Present" andButtonTitle:@"Cancel"];
                if (self.isBigSync)
                    self.isBigSync = NO;
            }
            return;
        }
    }
    
    [self flushCustomers];
    NSMutableArray *myData = (NSMutableArray*)result;
   
    
     sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        sqlite3_exec(database, "BEGIN", 0, 0, 0);
                     // Begin Transaction
    
    for(SQLSTUDIOADVANCEDtbl_Customer_Result *myPOI in myData)
    {
        lastCustomer = myPOI.Customer_ID;

            
            NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZCUSTOMER( ZPKID,ZLATITUDE, ZLONGITUDE, ZADDRESS, ZADDRESS2, ZCITYSTATE, ZNAME, ZNUMBER, ZPHONE, ZZIP,ZZZVENDOR,ZZZZCUSTOMERID)VALUES(%i,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%i',%i);",myPOI.Customer_ID,[myPOI.Longitude stringValue], [myPOI.Latitude stringValue],myPOI.Customer_Address, myPOI.Customer_Address_2,myPOI.CityState, myPOI.Customer_Name, myPOI.Account_Number,myPOI.Phone, myPOI.Zip, myPOI.Code,myPOI.Customer_ID];
            
            const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
            sqlite3_stmt *statement;
            if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
            {
                if(SQLITE_DONE != sqlite3_step(statement))
                {
                    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                }

            }
            else
            {
                NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
    }
    sqlite3_exec(database, "COMMIT", 0, 0, 0);
    sqlite3_close(database);
    NSLog(@"End Write to SQL");
    NSLog(@"No More Data");
    if(silentMode == NO) {
        [[self syncService] finishSyncTask];
    }
    else {
        [[self syncService] finishSyncTaskSilent];
    }
    self.isBigSync = NO;
}

-(SQLSTUDIOADVANCEDtbl_Orders_Result*)GetOrder:(int)OrderID
{
    SQLSTUDIOADVANCEDtbl_Orders_Result  *retVal = [[SQLSTUDIOADVANCEDtbl_Orders_Result alloc]init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select * FROM ZORDER WHERE ZPKID = %i",OrderID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                retVal.Order_Number =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                retVal.PO_Number =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return  retVal;

}
-(SQLSTUDIOADVANCEDtbl_Customer_Result*)GetCustomer:(int)CustomerID
{
    SQLSTUDIOADVANCEDtbl_Customer_Result  *retVal = [[SQLSTUDIOADVANCEDtbl_Customer_Result alloc]init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select * FROM ZCUSTOMER WHERE ZPKID = %i",CustomerID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {

                retVal.Customer_ID = sqlite3_column_int(statement, 3);
                retVal.Customer_Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                retVal.Customer_Address =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                retVal.Customer_Address_2 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                retVal.CityState =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                retVal.Account_Number =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                retVal.Phone =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                retVal.Zip =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                retVal.Longitude = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(statement, 5)];
                retVal.Latitude = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(statement, 4)];

            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return  retVal;
}
-(NSMutableArray*)ListCustomerLocationsForMap:(double)Longitude :(double)Latitude
{

    NSNumber *myLongMinus = [NSNumber numberWithDouble:Longitude -1];
    NSNumber *myLongPlus = [NSNumber numberWithDouble:Longitude +1];

    NSNumber *myLatMinus = [NSNumber numberWithDouble:Latitude -1];
    NSNumber *myLatPlus = [NSNumber numberWithDouble:Latitude +1];

    
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"SELECT 	ZPKID, ZNAME, ZLONGITUDE, ZLATITUDE FROM ZCUSTOMER WHERE ZLATITUDE <> 0 AND ZLATITUDE <> 0 AND ZLONGITUDE > %@  AND ZLONGITUDE < %@	 AND ZLATITUDE < %@  AND ZLATITUDE > %@",[myLatMinus  stringValue], [myLatPlus stringValue], [myLongPlus stringValue],[myLongMinus stringValue]];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.year = 31;
                
                SQLSTUDIOADVANCEDCustomer_Location *order = [[SQLSTUDIOADVANCEDCustomer_Location alloc] init];
                order.Customer_ID = sqlite3_column_int(statement, 0);
                order.Customer_Name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                double theLong   = sqlite3_column_double(statement, 2);
                double theLat = sqlite3_column_double(statement, 3);
                
                NSDecimalNumber *newLong = [[NSDecimalNumber   alloc]initWithDouble:theLong];
                NSDecimalNumber *newLat = [[NSDecimalNumber alloc]initWithDouble:theLat];
                order.Longitude = newLong;
                order.Latitude = newLat;
                [items addObject:order];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return  items;

}
-(NSMutableArray*)ListOrdersOfCustomer:(int)CustomerID
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select * FROM ZORDER WHERE ZCUSTOMER = %i AND ZSTATUS = 1",CustomerID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                components.year = 31;
                
                SQLSTUDIOADVANCEDtbl_Orders_Result *order = [[SQLSTUDIOADVANCEDtbl_Orders_Result alloc] init];
                order.Order_ID = sqlite3_column_int(statement, 5);
                order.Order_Number =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                order.Order_Created = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 7)] options:0];
                order.PO_Number = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                [items addObject:order];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return  items;
}
//-(int)GetShippedCount:(int)OrderItemID :(NSString*)TankType
-(int)GetShippedCount:(int)OrderItemID :(NSString*)TankType
{
    int items = 0;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
//        NSString *myStatement = [NSString stringWithFormat:@"SELECT COUNT(*) AS Shipped FROM	zorder_item	INNER JOIN	zorder ON zorder.ZPKID = zorder_item.zorder_ID	INNER JOIN	ZDEVICE_TRANSACTION	ON ZDEVICE_TRANSACTION.ZORDER_NUMBER = zorder.ZORDER_NUMBER WHERE	ZORDER_ITEM.Z_PK = %i AND ZORDER_ITEM.ZORDER_TYPE = %i",OrderItemID,1];
        NSString *myStatement = [NSString stringWithFormat:@"SELECT COUNT(*) AS Shipped FROM zorder_item	INNER JOIN zorder ON zorder_item.zorder_ID = zorder.ZPKID INNER JOIN ZDEVICE_TRANSACTION	ON zorder.ZORDER_NUMBER = ZDEVICE_TRANSACTION.ZORDER_NUMBER 	INNER JOIN ZCYLINDER_TYPE ON zorder_item.ZCYLINDER_TYPE = ZCYLINDER_TYPE.ZPKID WHERE ZORDER_ITEM.Z_PK = %i AND ZDEVICE_TRANSACTION.ZSTATUS = 'CS' AND ZDEVICE_TRANSACTION.ZCYLINDER_TYPE = '%@'",OrderItemID, TankType];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                items = sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return items;
}
-(int)GetReturnedCount:(int)OrderItemID :(NSString*)TankType
{
    int items = 0;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"SELECT COUNT(*) AS Shipped FROM zorder_item	INNER JOIN zorder ON zorder_item.zorder_ID = zorder.ZPKID INNER JOIN ZDEVICE_TRANSACTION	ON zorder.ZORDER_NUMBER = ZDEVICE_TRANSACTION.ZORDER_NUMBER INNER JOIN ZCYLINDER_TYPE ON zorder_item.ZCYLINDER_TYPE = ZCYLINDER_TYPE.ZPKID WHERE ZORDER_ITEM.Z_PK = %i AND ZDEVICE_TRANSACTION.ZSTATUS = 'DE' AND ZDEVICE_TRANSACTION.ZCYLINDER_TYPE = '%@'",OrderItemID,TankType];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                items = sqlite3_column_int(statement, 0);
                
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return items;
}
//-(NSDecimalNumber*)GetShippedVolume:(int)OrderItemID:(NSString*)TankType
-(NSDecimalNumber*) GetShippedVolume:(int)OrderItemID TType:(NSString*)TankType
{
    NSDecimalNumber *items = 0;
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
//        NSString *myStatement = [NSString stringWithFormat:@"SELECT SUM(ZCYLINDER_VOLUME) AS Shipped FROM	zorder_item	INNER JOIN	zorder ON zorder.ZPKID = zorder_item.zorder_ID	INNER JOIN	ZDEVICE_TRANSACTION	ON ZDEVICE_TRANSACTION.ZORDER_NUMBER = zorder.ZORDER_NUMBER WHERE	ZORDER_ITEM.Z_PK = %i AND ZORDER_ITEM.ZORDER_TYPE = 2",OrderItemID];
        NSString *myStatement = [NSString stringWithFormat:@"SELECT SUM(ZCYLINDER_VOLUME) AS Shipped FROM zorder_item INNER JOIN	zorder ON zorder.ZPKID = zorder_item.zorder_ID	INNER JOIN	ZDEVICE_TRANSACTION	ON ZDEVICE_TRANSACTION.ZORDER_NUMBER = zorder.ZORDER_NUMBER INNER JOIN ZCYLINDER_TYPE ON zorder_item.ZCYLINDER_TYPE = ZCYLINDER_TYPE.ZPKID WHERE ZORDER_ITEM.Z_PK = %i AND  ZDEVICE_TRANSACTION.ZSTATUS = 'CS' AND ZDEVICE_TRANSACTION.ZCYLINDER_TYPE = '%@'",OrderItemID,TankType];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                items =  [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(statement, 0)];
                
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return items;
}
-(NSMutableArray*)ListItemsOfOrder:(int)OrderID
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select Zorder_item.ZCOUNT, Zorder_item.zorder_type, zcylinder_type.ZCT_DESCRIPTION, ZORDER_ITEM.Z_PK, ZCYLINDER_TYPE.ZCT_TYPE  from zorder_item inner join zcylinder_type on zorder_item.ZCYLINDER_TYPE = zcylinder_type.ZPKID WHERE ZORDER_ID = %i",OrderID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                SQLSTUDIOADVANCEDOrderDetail *order = [[SQLSTUDIOADVANCEDOrderDetail alloc] init];
                order.Cylinder_Type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                order.Count = sqlite3_column_int(statement, 0);
                order.Order_Type = sqlite3_column_int(statement, 1);
                int orderItemID =sqlite3_column_int(statement, 3);

                if(order.Order_Type == 1)
                {
                    order.Order_Status_ID = [self GetShippedCount:orderItemID :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                }
                else
                {
                    order.Order_Status_ID = [self GetReturnedCount:orderItemID :[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                }
                order.Order_Number = [[self GetShippedVolume:orderItemID TType:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]]stringValue];
                [items addObject:order];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return items;
}
-(NSMutableArray*)ListTransactionOfOrder:(NSString*)OrderNumber
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"SELECT * FROM ZDEVICE_TRANSACTION WHERE ZORDER_NUMBER = '%@'",OrderNumber];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                DW_TransactionItem *order = [[DW_TransactionItem alloc] init];
                order.PK = sqlite3_column_int(statement, 0);
                order.cylinderType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                order.cylinderVolume = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                order.tagID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                order.operation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                [items addObject:order];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return items;
}
-(void)DeleteTransaction:(int)PK
{
    sqlite3 *database;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"DELETE FROM ZDEVICE_TRANSACTION WHERE Z_PK = %i",PK];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }

        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
-(NSMutableArray*)ListAllCustomers
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select * FROM ZCUSTOMER order by ZNAME"];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                SQLSTUDIOADVANCEDtbl_Customer_Result *customer = [[SQLSTUDIOADVANCEDtbl_Customer_Result alloc] init];
                customer.Customer_ID = sqlite3_column_int(statement, 3);
                customer.Customer_Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                customer.Customer_Address =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                customer.Customer_Address_2 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                customer.CityState =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                customer.Account_Number =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                customer.Phone =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                customer.Zip =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                customer.Longitude = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(statement, 5)];
                customer.Latitude = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(statement, 4)];
                
//                NSLog(@"ID: %d",customer.Customer_ID);
//                NSLog(@"Customer_Name: %@",customer.Customer_Name);
//                NSLog(@"Customer_Address: %@",customer.Customer_Address);
//                NSLog(@"Customer_Address_2: %@",customer.Customer_Address_2);
//                NSLog(@"CityState: %@",customer.CityState);
//                NSLog(@"Account_Number: %@",customer.Account_Number);
//                NSLog(@"ID: %@",customer.Phone);
//                NSLog(@"ID: %@",customer.Zip);
//                NSLog(@"ID: %@",customer.Longitude);
//                NSLog(@"ID: %@",customer.Latitude);
                
                [items addObject:customer];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return  items;
}

-(NSMutableArray*)ListTodaysStops
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {

        NSString *myStatement = [NSString stringWithFormat:@"select zcustomer.ZPKID, zcustomer.ZNAME, zcustomer.ZLATITUDE, zcustomer.ZLONGITUDE, zcustomer.zzip, (select sum(zcount) from zorder_item where zorder_id = zorder.ZPKID and zorder_type = 1) as ships, (select sum(zcount) from zorder_item where zorder_id = zorder.ZPKID and zorder_type = 2) as returns, zcustomer.ZPKID, zcustomer.znumber from zorder inner join zcustomer on zorder.ZCUSTOMER = zcustomer.ZPKID where  ZORDER.ZSTATUS = 1 order by ZNAME"];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        

        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                SQLSTUDIOADVANCEDTodaysStop *stop = [[SQLSTUDIOADVANCEDTodaysStop alloc] init];
                stop.Customer_ID = sqlite3_column_int(statement, 7);
                stop.Customer_Name = [NSString stringWithFormat:@"(%@) %@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)],[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
                stop.Latitude = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(statement, 2)];
                stop.Longitude = [[NSDecimalNumber alloc] initWithDouble:sqlite3_column_double(statement, 3)];
                stop.Ship = sqlite3_column_int(statement, 5);
                stop.Return = sqlite3_column_int(statement, 6);
                stop.Zip = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                

                
                [items addObject:stop];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return  items;

}

//ORDERS
-(BOOL)checkOrderExists:(int)orderID
{
    BOOL retVal = NO;
    sqlite3 *database;
    int counter =0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select COUNT(*) AS RecordCount from ZORDER WHERE ZPKID = %i",orderID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                counter = sqlite3_column_int(statement, 0);
                if(counter >0)
                {
                    retVal = YES;
                }
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return retVal;
}
-(void)markOrderAsClosed:(NSString*)OrderNumber
{
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"UPDATE ZORDER SET ZSTATUS = 2 WHERE ZORDER_NUMBER = '%@'",OrderNumber];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }
        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
-(void)downloadOrder
{
    //pull the new orders down from the web service
    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    service.logging = NO;
    [service Get_Order_Of_Driver:self action:@selector(handleDownloadOrders:) Driver_ID:self.userID];
}
-(void)handleDownloadOrders:(id)result
{
    
    if([result isKindOfClass:[SoapFault class]])
    {
        [[self syncService] finishSyncTaskSilent];
        return;
    }
    else
    {
        if([result isKindOfClass:[NSError class]])
        {
            NSError *MyError = (NSError*) result;
            if(MyError.code == 410)
            {
                [[self syncService] finishSyncTaskWithAlertTitle:@"Network" andMessage:@"Your Network Connection is not Present" andButtonTitle:@"Cancel"];
            }
            return;
        }
    }
    SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
    service.logging = NO;
    
    
    //push orders into sqlite
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    
    NSMutableArray *myData = (NSMutableArray*)result;
    for(SQLSTUDIOADVANCEDtbl_Orders_Result *myPOI in myData)
    {
        if([self checkOrderExists:myPOI.Order_ID] == NO)
        {
            sqlite3 *database;
            int rowID =0;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
            const char *path = [m_DatabasePath UTF8String];
            if(sqlite3_open(path, &database) == SQLITE_OK)
            {
                NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZORDER( ZCUSTOMER, ZDRIVER, ZSTATUS, ZORDER_CREATED, ZORDER_NUMBER, ZPO_NUMBER,ZPKID) VALUES (%i ,%i ,%i , '%@', '%@', '%@',%i);",myPOI.Customer,myPOI.Driver_ID,myPOI.Order_Status,[formatter stringFromDate:myPOI.Order_Created], myPOI.Order_Number,myPOI.PO_Number,myPOI.Order_ID];
                const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
                sqlite3_stmt *statement;
                if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
                {
                    if(SQLITE_DONE != sqlite3_step(statement))
                    {
                        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                    }
                    //rowID = sqlite3_last_insert_rowid(database);
                    //rowID = [[NSNumber alloc] initWithLongLong:sqlite3_last_insert_rowid(database)];
                    NSNumber *nsRowID = [[NSNumber alloc] initWithLongLong:sqlite3_last_insert_rowid(database)];
                    rowID=[nsRowID intValue];
                }
                else
                {
                    NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
            sqlite3_close(database);
            [service Get_Items_Of_Order:self action:@selector(handleDownloadedOrderItems:) Order_ID:myPOI.Order_ID CallBack:rowID];
        }
    }
    
    if(silentMode == NO)
    {
        [[self syncService] finishSyncTask];
    } else {
        [[self syncService] finishSyncTaskSilent];
    }
}
-(NSString*)resolveOrderNumberByPO:(NSString*)PONumber
{
    NSString *retVal = @"";
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select  ZORDER_NUMBER from ZORDER where ZPO_NUMBER = '%@'",PONumber];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                retVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return retVal;
}
-(NSString*)resolveOrderNumber:(int)OrderID
{
    NSString *retVal = @"";
    sqlite3 *database;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"SELECT ZORDER_NUMBER FROM ZORDER WHERE ZPKID = %i",OrderID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                
                retVal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return retVal;
}
//ORDER ITEMS
-(BOOL)checkOrderItemExists:(int)orderItemID
{
    BOOL retVal = NO;
    sqlite3 *database;
    int counter =0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        NSString *myStatement = [NSString stringWithFormat:@"select COUNT(*) AS RecordCount from ZORDER_ITEM WHERE ZORDER_ITEM_ID = %i",orderItemID];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        
        
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                counter = sqlite3_column_int(statement, 0);
                if(counter >0)
                {
                    retVal = YES;
                }
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return retVal;
}
-(void)handleDownloadedOrderItems:(id)result
{
    
    if([result isKindOfClass:[SoapFault class]])
    {
        [[self syncService] finishSyncTaskSilent];
        return;
    }
    else
    {
        if([result isKindOfClass:[NSError class]])
        {
            NSError *MyError = (NSError*) result;
            if(MyError.code == 410)
            {
                [[self syncService] finishSyncTaskWithAlertTitle:@"Network" andMessage:@"Your Network Connection is not Present" andButtonTitle:@"Cancel"];
            }
            return;
        }
    }
    
    NSMutableArray *myData = (NSMutableArray*)result;
    
    sqlite3 *database;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
                sqlite3_exec(database, "BEGIN", 0, 0, 0);
    for(SQLSTUDIOADVANCEDtbl_Order_Items_Result *myPOI in myData)
    {
        if([self checkOrderItemExists:myPOI.Order_Item_ID] == NO)
        {
            

                NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZORDER_ITEM (ZCOUNT, ZCYLINDER_TYPE, ZLINE_NUMBER, ZORDER_ID, ZORDER_TYPE,ZORDER_ITEM_ID) VALUES (%i, %i, %i, %i, %i,%i);",myPOI.Count, myPOI.Cylinder_Type, myPOI.Line_Number,myPOI.Order_ID,myPOI.Order_Type,myPOI.Order_Item_ID];
                const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
                sqlite3_stmt *statement;
                if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
                {
                    if(SQLITE_DONE != sqlite3_step(statement))
                    {
                        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                    }

                }
                else
                {
                    NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
                }
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
            }
        }
        
    }
     sqlite3_exec(database, "COMMIT", 0, 0, 0);
    sqlite3_close(database);

    
}




-(void)syncOrders
{
//push the orders up to the web service
}
-(void)insertNewOrder:(NSDate*)order_created
                     :(int)order_status
                     :(NSString*)order_number
                     :(int)customer
                     :(int)driver
                     :(NSString*)po_number
{
//insert a new order that was pulled down from the web service
    sqlite3 *database;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
    const char *path = [m_DatabasePath UTF8String];
    if(sqlite3_open(path, &database) == SQLITE_OK)
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-12-00-00"];
        
        NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZORDER( ZCUSTOMER, ZDRIVER, ZSTATUS, ZORDER_CREATED, ZORDER_NUMBER, ZPO_NUMBER,ZPKID) VALUES (%i ,%i ,%i , '%@', '%@', '%@',%i);",customer,driver,order_status,[formatter stringFromDate:order_created],order_number,po_number,0];
        const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if(SQLITE_DONE != sqlite3_step(statement))
            {
                NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
            }

        }
        else
        {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
        }
        sqlite3_reset(statement);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

-(void)insertNewOrderItem:(int)cylinder_type
                         :(int)order_id
                         :(int)order_type
                         :(int)count
                         :(int)line_number
{
//insert a new order item that was pulled down from the web service
}

-(void)insertNewDeviceTransaction :(NSString*)transaction_date
                                  :(NSString*)transaction_time
                                  :(int)customer_number
                                  :(NSString*)customer_name
                                  :(NSString*)id_tag
                                  :(NSString*)cylinder_type
                                  :(NSString*)status
                                  :(NSString*)operator
                                  :(NSString*)order_number
                                  :(NSString*)transaction_code
                                  :(NSString*)line_number
                                  :(NSString*)cylinder_volume
                                  :(NSString*)serialNumber
                                  :(NSString*)poNumber
                                  :(NSString*)batchnumber
                                  :(NSString*)shipperReference
{

        sqlite3 *database;

        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* m_DatabasePath = [documentsDirectory stringByAppendingPathComponent:@"OrderModel.sqlite"];
        const char *path = [m_DatabasePath UTF8String];
        if(sqlite3_open(path, &database) == SQLITE_OK)
        {
            NSString *myStatement = [NSString stringWithFormat:@"INSERT INTO ZDEVICE_TRANSACTION (ZTRANSACTION_DATE,ZTRANSACTION_TIME,ZCUSTOMER_NUMBER,ZCUSTOMER_NAME,ZID_TAG,ZCYLINDER_TYPE,ZSTATUS,ZOPERATOR,ZORDER_NUMBER,ZTRANSACTION_CODE,ZLINE_ITEM,ZCYLINDER_VOLUME,ZDOCK_LOCATION,ZPO_NUMBER,ZBATCH_NUMBER,ZSHIPPER_REFERENCE) VALUES ('%@','%@',%i,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",transaction_date, transaction_time,customer_number,customer_name,id_tag,cylinder_type,status,operator,order_number,transaction_code,line_number,cylinder_volume,serialNumber,poNumber,batchnumber,shipperReference];
            const char *sqlStatement = [myStatement cStringUsingEncoding:NSASCIIStringEncoding];
            sqlite3_stmt *statement;
            if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
            {
                if(SQLITE_DONE != sqlite3_step(statement))
                {
                    NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
                }

            }
            else
            {
                NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);


    
}





/*End Internal SQL*/

SystemSoundID audioEffect;

-(void)bootStrapLinea:(Linea*)linea
{
    if(autoChargeLineaPro == YES)
    {
         [linea setCharging:YES error:nil];
    }
    else
    {
        [linea setCharging:NO error:nil];       
    }
}

//init
- (id)init
{
    self = [super init];
    if (self) 
    {
        lastCylinderType=0;
        
        imageCache = [[NSMutableDictionary alloc] init];
        playSounds = YES;
        
        playBeep = [[NSUserDefaults standardUserDefaults] boolForKey:@"playBeep"];
        
        autoChargeLineaPro =[[NSUserDefaults standardUserDefaults] boolForKey:@"autoChargeLineaPro"];

        //if([[NSUserDefaults  standardUserDefaults] integerForKey:@"CloseOrderMode"] == nil)
        if([[NSUserDefaults  standardUserDefaults] integerForKey:@"CloseOrderMode"] == 0)
        {
            closeOrderMode = 0;
        }else
        {
            closeOrderMode = (int)[[NSUserDefaults  standardUserDefaults] integerForKey:@"CloseOrderMode"];
        }
        
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"userID"] != 0)
        {
            userID =(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
            int nPlaySounds = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"playSounds"];
           
            switch (nPlaySounds) {
                case 0:
                    playSounds = YES;
                    break;
                case 1:
                    playSounds = YES;
                    break;
                case 2:
                    playSounds = NO;
                    break;
                default:
                    break;
            }
        }
        else
        {
            userID = 0;
            
        }
    }
    return self;
}





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    [Fabric with:@[[Crashlytics class]]];
    
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif    
  
    self.window.rootViewController = self.tabBarController;
    [window setFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
        NSLog(@"recieved background thread");
}

-(void)alertOnSyncCompletionWithTitle:(NSString*)title andMessage:(NSString*)message andButtonTitle:(NSString *)buttonTitle{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:buttonTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    
    [alert addAction:CancelButton];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    hasNotifications = YES;
    notificationCount++;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}



/************
 IMAGE CODE
 ************/


//a function to clear a single image from the cache
- (void)clearImageCache:(NSString*)ImageName;
{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    NSError *error = nil;
    NSString*    finalString = [[
                                 [ImageName stringByReplacingOccurrencesOfString:@":" withString:@""] 
                                 stringByReplacingOccurrencesOfString:@"." withString:@""]
                                stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    BOOL removeSuccess = [fileMgr removeItemAtPath:[NSString stringWithFormat:@"%@/%@",imagePath,finalString] error:&error];
    if (!removeSuccess) 
    {
        // Error handling
        
    }
}

//a function to clear the entire image cache
- (void)clearImageCache
{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:imagePath error:&error];
    if (error == nil) {
        for (NSString *path in directoryContents) {
            NSString *fullPath = [imagePath stringByAppendingPathComponent:path];
            BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) 
            {
                // Error handling
                
            }
        }
    } else {
        // Error handling
    }
}

//a simple image caling tool
- (UIImage *)scaleMe:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//a higher level call that will get an image view based on a call to getImage -- if Glass= YES it will auto add a gradient layer
-(UIImageView*) getImageView:(NSString*)imageName size:(CGSize)Size glass:(BOOL)Glass isWebBased:(BOOL)IsWebBased
{
    UIImage *myImage = [self getImage:imageName size:Size isWebBased:IsWebBased];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:myImage];
    if(Glass == YES)
    {
        [self addGradientImage:myImageView];
    }
    return myImageView;
    
}

//main call to get an image from the image cache
-(UIImage*) getImage:(NSString*)imageName size:(CGSize)Size isWebBased:(BOOL)IsWebBased
{
    NSString* imageNameCopy = [imageName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString*    finalString = [[
                                 [imageNameCopy stringByReplacingOccurrencesOfString:@":" withString:@""] 
                                 stringByReplacingOccurrencesOfString:@"." withString:@""]
                                stringByReplacingOccurrencesOfString:@"/" withString:@""];
    UIImage* cachedImage = [imageCache objectForKey:finalString];
    
    if(cachedImage == nil)
    {
        NSError *error;
        error = nil;
        UIImage *img;
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:finalString];
        //see if the image exists in the documents dir
        img = [UIImage imageWithContentsOfFile:imagePath];
        if(img != nil)
        {
            
        }
        else
        {
            
            if(IsWebBased == YES)
            {
                //load it from online
                NSURL *url = [NSURL URLWithString:imageNameCopy];
                NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                
                if(error != nil)
                {
                    //load a local error or file not found image
                    img = [UIImage imageNamed:@"na.gif"];       
                }
                else
                {
                    //init the image with the data
                    img = [[UIImage alloc] initWithData:data];
                    //save it to cache
                    [data writeToFile:imagePath atomically:YES];
                }
            }
            else
            {
                img = [UIImage imageNamed:imageNameCopy]; 
            }
        }
        
        UIImage *copyImg;
        if(Size.width == 0 && Size.height == 0)
        {
            copyImg = img;
        }
        else 
        {
            copyImg = [self scaleMe: img toSize:Size];
        }
        [imageCache  setValue:copyImg forKey:finalString];  
        cachedImage = [imageCache objectForKey:finalString];        
    }
    
    return cachedImage;
}


-(void) addGradientImage:(UIImageView *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];

    [layer addSublayer:shineLayer];
}
-(void) addGradient:(UIButton *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;

    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.2f],
                            [NSNumber numberWithFloat:0.3f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}

-(NSString*) stripHTML:(NSString*) source
{
    
    NSRange r;
    NSString *s = source;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    s =   [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "]; 
    return s;
}








- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

















/*Data Modeling*/


@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext =  self.managedObjectContext;
    if(managedObjectContext != nil)
    {
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved Error %@, %@", error,[error userInfo]);
            abort();
        }
    }
}

-(NSManagedObjectContext *) managedObjectContext
{
    if(__managedObjectContext !=nil)
    {
        return  __managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil)
    {
//        __managedObjectContext = [[NSManagedObjectContext alloc]init];
        __managedObjectContext = [[NSManagedObjectContext alloc]init];

        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

-(NSManagedObjectModel *) managedObjectModel
{
    if(__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OrderModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

-(NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirecotry] URLByAppendingPathComponent:@"OrderModel.sqlite"];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSInferMappingModelAutomaticallyOption];
    //_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

-(NSURL *) applicationDocumentsDirecotry
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DM_Audit" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"auditTimestamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];;
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
}
-(void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
        if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
            UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
            __block UIBackgroundTaskIdentifier background_task; //Create a task object
            background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
                [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
                background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
                //System will be shutting down the app at any point in time now
            }];
            //Background tasks require you to use asyncrous tasks
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Perform your tasks that your application requires
                NSLog(@"\n\nRunning in the background!\n\n");
                [application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
                background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
            });
        }
    }
}
/*End Data Modeiling*/
@end
