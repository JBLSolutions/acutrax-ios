#import <UIKit/UIKit.h>
#import "CoreView.h"
#import "SQLSTUDIOADVANCEDAdvanced.h"

@class MyPicker;
@protocol MyPickerDelegate

-(void)touchedOK:(MyPicker *) controller;
@end

@interface MyPicker : CoreView<UISearchControllerDelegate, UISearchResultsUpdating>
{
    IBOutlet UIPickerView *pcMain;
    IBOutlet UIButton *btnMain;
    NSMutableArray *rawData;
    IBOutlet UITableView *tblData;
}
@property (nonatomic, strong) IBOutlet UITableView *tblData;
@property (strong, nonatomic) IBOutlet UIPickerView *pcMain;
@property (strong, nonatomic) IBOutlet UIButton *btnMain;
@property (strong, nonatomic) NSMutableArray *rawData;
@property (nonatomic, strong) NSObject<MyPickerDelegate> *delegate;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) UISearchController* searchController;
@property (strong, nonatomic) SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result* selectedCylinder;

- (IBAction)btnMain_Touch:(id)sender;

@end

