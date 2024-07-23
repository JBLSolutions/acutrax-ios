//
//  DW_TransactionItem.m
//  AcuTrax
//
//  Created by Johnathan Rossitter on 11/20/12.
//
//

#import "DW_TransactionItem.h"

@implementation DW_TransactionItem
@synthesize cylinderType;
@synthesize cylinderVolume;
@synthesize tagID;
@synthesize operation;
@synthesize PK;

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        PK = 0;
        cylinderType = [[NSString alloc]init];
        cylinderVolume = [[NSString alloc]init];
        tagID = [[NSString alloc]init];
        operation = [[NSString alloc]init];        
    }
    return self;
}

- (void)dealloc
{
    PK = 0;
}

@end
