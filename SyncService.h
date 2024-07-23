//
//  SyncService.h
//  acutrax
//
//  Created by Michael Lambert on 2/28/17.
//
//

#import <Foundation/Foundation.h>
@class SPLAppDelegate;

typedef NS_OPTIONS(NSUInteger, SyncCommandFlag) {
    SyncOrdersFlag = 1 << 1,
    SyncCylinderTypesFlag = 1 << 2,
    SyncTagsFlag = 1 << 3,
    SyncCustomersFlag = 1 << 4,
    SyncSignaturesFlag = 1 << 5,
    SyncTransactionsFlag = 1 << 6,
    DownloadAssetsFlag = (SyncCylinderTypesFlag | SyncTagsFlag),
    DownloadCustomersFlag = (SyncOrdersFlag | SyncCustomersFlag),
    UploadOrdersFlag = (SyncSignaturesFlag | SyncTransactionsFlag),
    DownloadEverythingFlag = (SyncOrdersFlag | SyncCylinderTypesFlag | SyncTagsFlag | SyncCustomersFlag)
};

@interface SyncService : NSObject

@property (atomic) int syncQueueCount;
@property (nonatomic, copy, nullable) void (^onCompletionBlock)();

+(id)getSyncService;

-(BOOL) isSyncing;
- (void)initializeForSync;
-(void)startSyncForCommands:(SyncCommandFlag)syncCommandFlags;
-(void)incrementSyncCountForTag:(SyncCommandFlag)syncCommandFlags;

-(void)finishSyncTaskSilent;
-(void)finishSyncTask;
-(void)finishSyncTaskWithAlertTitle:(NSString*)title andMessage:(NSString*)message andButtonTitle:(NSString*)buttonTitle;

@end
