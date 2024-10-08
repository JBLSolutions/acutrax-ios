/*
	SQLSTUDIOADVANCEDArrayOftbl_Cylinder_Type_Result.h
	The implementation of properties and methods for the SQLSTUDIOADVANCEDArrayOftbl_Cylinder_Type_Result array.
	Generated by SudzC.com
*/
#import "SQLSTUDIOADVANCEDArrayOftbl_Cylinder_Type_Result.h"

#import "SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result.h"
@implementation SQLSTUDIOADVANCEDArrayOftbl_Cylinder_Type_Result

	+ (id) createWithNode: (CXMLNode*) node
	{
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result* value = [[SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result createWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"tbl_Cylinder_Type_Result"]];
		}
		return s;
	}
@end
