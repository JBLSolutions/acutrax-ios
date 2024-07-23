//
//  SyncService.m
//  acutrax
//
//  Created by Michael Lambert on 2/28/17.
//
//

#import "SyncService.h"
#import "SPLAppDelegate.h"

@implementation SyncService

+(id) getSyncService {
    static SyncService *syncService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        syncService = [[self alloc] init];
    });
    return syncService;
}

+(SPLAppDelegate*)sharedAppDelegate; {
    return (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL) isSyncing {
    return self.syncQueueCount > 0;
}

- (void)initializeForSync {
    self.syncQueueCount = 0;
}

-(void)startSyncForCommands:(SyncCommandFlag)syncCommandFlags {
    [self sync:syncCommandFlags];
}

-(void)incrementSyncCountForTag:(SyncCommandFlag)syncCommandFlags {
    if ((syncCommandFlags & SyncOrdersFlag) != 0) {
        self.syncQueueCount++;
    }
    
    if ((syncCommandFlags & SyncCylinderTypesFlag) != 0) {
        self.syncQueueCount++;
    }
    
    if ((syncCommandFlags & SyncTagsFlag) != 0) {
        self.syncQueueCount++;
    }
    
    if ((syncCommandFlags & SyncCustomersFlag) != 0) {
        self.syncQueueCount++;
    }
    
    if ((syncCommandFlags & SyncSignaturesFlag) != 0) {
        //self.syncQueueCount++;
        //sync count is incremented in the update signatures method.
        //one increment for every png uploaded.
        NSLog(@"sync count pre sync signatures %d",self.syncQueueCount);
        NSUInteger signatureCount = [[SyncService sharedAppDelegate] unSynchedSignatureCount];
        self.syncQueueCount += (int)signatureCount;
        NSLog(@"sync count post sync signatures %d",self.syncQueueCount);
    }
    
    if ((syncCommandFlags & SyncTransactionsFlag) != 0) {
        self.syncQueueCount++;
    }
}

-(void)sync:(SyncCommandFlag)syncCommandFlags {
    if ((syncCommandFlags & SyncOrdersFlag) != 0) {
        [self updateOrders];
    }
    
    if ((syncCommandFlags & SyncCylinderTypesFlag) != 0) {
        [self updateCylinderTypes];
    }
    
    if ((syncCommandFlags & SyncTagsFlag) != 0) {
        [self updateTags];
    }
    
    if ((syncCommandFlags & SyncCustomersFlag) != 0) {
        [self updateCustomers];
    }
    
    if ((syncCommandFlags & SyncSignaturesFlag) != 0) {
        [self updateSignatures];
    }
    
    if ((syncCommandFlags & SyncTransactionsFlag) != 0) {
        [self updateTransactions];
    }
}

-(void)updateOrders {
    [[SyncService sharedAppDelegate] downloadOrder];
}

-(void)updateCylinderTypes {
    [[SyncService sharedAppDelegate] downloadCylinderTypes];
}

-(void)updateTags {
    [[SyncService sharedAppDelegate] downloadTags];
}

-(void)updateCustomers {
    [[SyncService sharedAppDelegate] downloadCustomers];
}

-(void)updateSignatures {
    [[SyncService sharedAppDelegate] syncSignatures];
}

-(void)updateTransactions {
    [[SyncService sharedAppDelegate] syncTransactions];
}

-(void)finishSyncTaskSilent {
    self.syncQueueCount--;
    if (self.syncQueueCount == 0 && self.onCompletionBlock) {
        self.onCompletionBlock();
    }
}

-(void)finishSyncTask {
    [self finishSyncTaskSilent];
    if (![self isSyncing]) {
        [[SyncService sharedAppDelegate] alertOnSyncCompletionWithTitle:@"Synchronization Complete" andMessage:@"Your local database is now up to date." andButtonTitle:@"OK"];
    }
}

-(void)finishSyncTaskWithAlertTitle:(NSString*)title andMessage:(NSString*)message andButtonTitle:(NSString*)buttonTitle{
    [[SyncService sharedAppDelegate] alertOnSyncCompletionWithTitle:title andMessage:message andButtonTitle:buttonTitle];
    [self finishSyncTask];
}
@end
