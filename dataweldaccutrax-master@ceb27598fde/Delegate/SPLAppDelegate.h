#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import <CoreData/CoreData.h>
//#import "SQLSTUDIOADVANCEDServices.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"
#import <MapKit/MapKit.h>
#import "SyncService.h"

@interface SPLAppDelegate : UIResponder <UIApplicationDelegate,NSFetchedResultsControllerDelegate>
{
    BOOL playSounds;
    IBOutlet UIWindow *window;
    IBOutlet UITabBarController *tabBarController;
    NSString *apnsID;
    NSString* myDeviceToken;
    int userID;
    NSString *driverFirstName;
    NSString *driverLastName;
    NSMutableDictionary *imageCache;
    UIImageView *background;
    bool hasNotifications;
    int notificationCount;
    BOOL playBeep;
    BOOL isLineaProAttached;
    BOOL autoChargeLineaPro;
    int closeOrderMode;
    int lastCylinderType;
 
    
}
@property (nonatomic) BOOL tagsFlushed;
@property (nonatomic) BOOL silentMode;
@property (nonatomic) int lastCylinderType;
@property (nonatomic) int closeOrderMode;
@property (nonatomic) BOOL autoChargeLineaPro;
@property (nonatomic) BOOL playSounds;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, copy) NSString *apnsID;
@property (nonatomic, strong) NSString* myDeviceToken;
@property (nonatomic) int userID;
@property (nonatomic, strong) NSString *driverFirstName;
@property (nonatomic, strong) NSString *driverLastName;
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (nonatomic, strong) UIImageView *background;
@property (nonatomic) bool hasNotifications;
@property (nonatomic) int notificationCount;
@property (nonatomic) BOOL playBeep;
@property (nonatomic) BOOL isLineaProAttached;
@property (nonatomic) BOOL isBigSync;

-(void)logoutUser;

-(double)GetLat;
-(double)GetLong;

//-(void) playSound : (NSString *) fName : (NSString *) ext;
-(void) addGradient:(UIButton *) _button;
-(void) addGradientImage:(UIImageView *) _button;
-(NSString*) stripHTML:(NSString*) source;

-(void)bootStrapLinea:(Linea*)linea;
-(NSString*)getDriverInitials;
-(void)setDriverInitials:(NSString*)driverInitials;
-(BOOL)driverInitialsSet;

//main call to get an image from the image cache
- (UIImage*) getImage:(NSString*)imageName size:(CGSize)Size isWebBased:(BOOL)IsWebBased;

//a higher level call that will get an image view based on a call to getImage -- if Glass= YES it will auto add a gradient layer
- (UIImageView*) getImageView:(NSString*)imageName size:(CGSize)Size glass:(BOOL)Glass isWebBased:(BOOL)IsWebBased;

//a simple image caling tool
- (UIImage *)scaleMe:(UIImage *)image toSize:(CGSize)size;

//a function to clear the entire image cache
- (void)clearImageCache;

//clear a single image from the cache
- (void)clearImageCache:(NSString*)ImageName;


-(SyncService*) syncService;

//DATABASE
@property (nonatomic) BOOL isSyncing;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(BOOL)isCustomerVendor:(int)CustomerID;
-(void)syncTransactions;
-(void)flushCustomers;
-(void)downloadCustomers;
-(void)handleDownloadCustomers:(id)result;
-(BOOL)checkOrderExists:(int)orderID;
-(BOOL)checkOrderItemExists:(int)orderItemID;
-(BOOL)checkCylinderExists:(int)cylinderID;
-(void)downloadOrder;
-(void)syncOrders;
-(void)downloadCylinderTypes;
-(void)downloadTags;
-(void)flushCylinderTypes;
-(void)flushTags;
-(void)alertOnSyncCompletionWithTitle:(NSString*)title andMessage:(NSString*)message andButtonTitle:(NSString*)buttonTitle;

-(int)checkShippedAgainstTransactions:(NSString*)orderName  customerID:(int)Customer_ID;
-(int)checkReceivedAgainstTransactions:(NSString*)orderName  customerID:(int)Customer_ID;

-(NSString*)resolveOrderNumber:(int)OrderID;
-(NSString*)resolveOrderNumberByPO:(NSString*)PONumber;
-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)resolveTank:(NSString*)Tag;
-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)resolveTankByID:(int)ID;
-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)resolveTankBySerial:(NSString*)Serial;
-(NSMutableArray*)listAllTypes;
-(NSMutableArray*)ListAllCustomers;
-(SQLSTUDIOADVANCEDtbl_Customer_Result*)GetCustomer:(int)CustomerID;
-(SQLSTUDIOADVANCEDtbl_Orders_Result*)GetOrder:(int)OrderID;
-(NSMutableArray*)ListOrdersOfCustomer:(int)CustomerID;
-(NSMutableArray*)ListItemsOfOrder:(int)OrderID;
-(NSMutableArray*)ListTodaysStops;
-(NSMutableArray*)ListTransactionOfOrder:(NSString*)OrderNumber;
-(NSMutableArray*)ListCustomerLocationsForMap:(double)Longitude :(double)Latitude;
-(BOOL)CustomerHasOrder:(int)CustomerID;
-(BOOL)CheckTagExistsInTransaction:(NSString*)TagID :(NSString*)OrderNumber :(int)customerNumber;
-(int)GetShippedCount:(int)OrderItemID :(NSString*)TankType;
-(int)GetReturnedCount:(int)OrderItemID  :(NSString*)TankType;
-(NSDecimalNumber*) GetShippedVolume:(int)OrderItemID TType:(NSString*)TankType;
-(void)DeleteTransaction:(int)PK;
-(void)flushSentOrdersAndshowSyncAlert:(BOOL)showSyncAlert fromViewController:(UIViewController*)viewController;
-(void)addSingleTag:(int)CustomerID :(int)CYlinderType :(int)TagID :(NSString*)Serial :(NSString*)Tag;
-(SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)getCylinderTypeByPKID:(int)ID;
-(void)insertNewOrder:(NSDate*)order_created
                     :(int)order_status
                     :(NSString*)order_number
                     :(int)customer
                     :(int)driver
                     :(NSString*)po_number;

-(void)insertNewOrderItem:(int)cylinder_type
                         :(int)order_id
                         :(int)order_type
                         :(int)count
                         :(int)line_number;

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
:(NSString*)shipperReference;

-(void)markOrderAsClosed:(NSString*)OrderNumber;
- (NSUInteger)unSynchedSignatureCount;
-(void)syncSignatures;

-(NSString*)stringFromDate:(NSDate*)theDate;
-(NSDate*)dateFromString:(NSString*)theString;
@end
