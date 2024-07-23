//
//  DW_TransactionItem.h
//  AcuTrax
//
//  Created by Johnathan Rossitter on 11/20/12.
//
//

#import <Foundation/Foundation.h>

@interface DW_TransactionItem : NSObject
{
    NSString *cylinderType;
    NSString *cylinderVolume;
    NSString *tagID;
    NSString *operation;
    int PK;
}
@property (nonatomic) int PK;
@property (nonatomic,strong) NSString *cylinderType;
@property (nonatomic,strong) NSString *cylinderVolume;
@property (nonatomic,strong) NSString *tagID;
@property (nonatomic,strong) NSString *operation;
@end
