//
//  CloseOrder.h
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineaSDK.h"
#import "T1Autograph.h"
#import "CoreView.h"


@interface CloseOrder : CoreView<LineaDelegate,T1AutographDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    T1Autograph *autograph;
   	Linea* linea;
    IBOutlet UILabel *lblSwipeCard;
    IBOutlet UITextView *txtLicense;
    IBOutlet UIButton *btnDecline;
    IBOutlet UIButton *btnConfirm;

    UIImageView *outputImage;
        UIImagePickerController *imgPicker;
    IBOutlet UITableView *tblData;
    NSMutableArray *rawData;
    UIImage *snappedPhoto;

}
- (IBAction)btnClear_Touch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (nonatomic, strong) IBOutlet UITableView *tblData;
@property (nonatomic,strong) NSMutableArray *rawData;

@property (strong) T1Autograph *autograph;
@property (strong, nonatomic) IBOutlet UIButton *btnSnapPhoto;
- (IBAction)btnSnapPhotoTouch:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnDecline;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UITextView *txtLicense;
@property (strong, nonatomic) IBOutlet UILabel *lblSwipeCard;
@property (strong, nonatomic) IBOutlet UIView *autographView;

@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UIImage *snappedPhoto;

@property (strong) UIImageView *outputImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOrderNumber:(NSString*)OrderNumber;
- (IBAction)btnConfirm_Touch:(id)sender;
- (IBAction)btnDecline_Touch:(id)sender;
//- (IBAction)btnConfirm2:(id)sender;
@end
