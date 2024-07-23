//
//  SyncView.m
//  AcuTrax
//
//  Created by Johnathan Rossitter on 11/21/12.
//
//

#import "SyncView.h"
#import "SPLAppDelegate.h"

@interface SyncView ()
@end

@implementation SyncView
@synthesize btnDownloadAssetData;
@synthesize btnDownloadCustomerData;
@synthesize btnDownloadEverything;
@synthesize btnUploadOrders;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Sync Options";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnDownloadEverything:nil];
    [self setBtnDownloadAssetData:nil];
    [self setBtnDownloadCustomerData:nil];
    [self setBtnUploadOrders:nil];
    [super viewDidUnload];
}

-(void)updateTime {
    SyncService*service = [SyncService getSyncService];
    
    if([service isSyncing] == YES) {
        [self performSelector:@selector(updateTime) withObject:self afterDelay:0.1];
    }
    else {
        [activityMain stopAnimating];
    }
}

-(void)updateBigTime {
    SyncService *service = [SyncService getSyncService];
    
    if([service isSyncing] == YES) {
        [self performSelector:@selector(updateBigTime) withObject:self afterDelay:0.1];
    }
    else {
        [activityMain stopAnimating];
    }
}
- (IBAction)btnDownloadAssets_Touch:(id)sender {
    [activityMain startAnimating];
    SyncService *syncService = [SyncService getSyncService];
    [syncService initializeForSync];
    [syncService incrementSyncCountForTag:DownloadAssetsFlag];
    [self updateTime];
    [syncService startSyncForCommands:DownloadAssetsFlag];
}

- (IBAction)btnDownloadCustomerData_Touch:(id)sender {
    [activityMain startAnimating];
    SyncService *syncService = [SyncService getSyncService];
    [syncService initializeForSync];
    [syncService incrementSyncCountForTag:DownloadCustomersFlag];
    [self updateTime];
    [syncService startSyncForCommands:DownloadCustomersFlag];
}

- (IBAction)btnUploadOrders_Touch:(id)sender {
    [activityMain startAnimating];
    SyncService *syncService = [SyncService getSyncService];
    [syncService initializeForSync];
    [syncService setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
            [myDelegate flushSentOrdersAndshowSyncAlert:true fromViewController:self];
            [[SyncService getSyncService] setOnCompletionBlock:nil];
        });
    }];
    [syncService incrementSyncCountForTag:UploadOrdersFlag];
    [self updateTime];
    [syncService startSyncForCommands:UploadOrdersFlag];
}

- (IBAction)btnDownloadEverything_Touch:(id)sender {
    [activityMain startAnimating];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.isBigSync  = YES;
    SyncService *syncService = [SyncService getSyncService];
    [syncService initializeForSync];
    [syncService incrementSyncCountForTag:DownloadEverythingFlag];
    [self updateBigTime];
    myDelegate.silentMode = NO;
    [syncService startSyncForCommands:DownloadEverythingFlag];
    /* Removing the commented out line below fixed animation for the sync everything button. This method instantly returns and stops animation, hence why it does not show up for sync everything. The responsibility of stopping animation takes place in the updateBigTime method above */    
//    [activityMain stopAnimating];
}
@end
