/*
	SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result.h
	The interface definition of properties and methods for the SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result : SoapObject
{
	NSString* _Category;
	NSString* _Class;
	int _Customer_ID;
	NSString* _Cylinder_Type;
	int _Cylinder_Type_ID;
	NSString* _Description_1;
	NSString* _Description_2;
	NSString* _Description_3;
	NSString* _Description_4;
	NSDecimalNumber* _Hazzard_Class;
	BOOL _Maintain_Volume;
	NSString* _Proper_Name_1;
	NSString* _Proper_Name_2;
	NSString* _Proper_Name_3;
	NSString* _Proper_Name_4;
	NSString* _Proper_Name_5;
	BOOL _Track_Type;
	NSString* _UN_Number;
	NSDecimalNumber* _Weight;
	NSString* _ssImage_Cylinder_Image;
    NSString* _Serial_Number;
	
}

    @property (nonatomic, strong) NSString* TagID;
	@property (strong, nonatomic) NSString* Category;
	@property (strong, nonatomic) NSString* Class;
	@property int Customer_ID;
	@property (strong, nonatomic) NSString* Cylinder_Type;
	@property int Cylinder_Type_ID;
	@property (strong, nonatomic) NSString* Description_1;
	@property (strong, nonatomic) NSString* Description_2;
	@property (strong, nonatomic) NSString* Description_3;
	@property (strong, nonatomic) NSString* Description_4;
	@property (strong, nonatomic) NSDecimalNumber* Hazzard_Class;
	@property BOOL Maintain_Volume;
	@property (strong, nonatomic) NSString* Proper_Name_1;
	@property (strong, nonatomic) NSString* Proper_Name_2;
	@property (strong, nonatomic) NSString* Proper_Name_3;
	@property (strong, nonatomic) NSString* Proper_Name_4;
	@property (strong, nonatomic) NSString* Proper_Name_5;
	@property BOOL Track_Type;
	@property (strong, nonatomic) NSString* UN_Number;
	@property (strong, nonatomic) NSDecimalNumber* Weight;
	@property (strong, nonatomic) NSString* ssImage_Cylinder_Image;
	@property (strong, nonatomic) NSString* Serial_Number;

	+ (SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*) createWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
