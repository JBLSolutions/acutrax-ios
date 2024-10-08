/*
	SQLSTUDIOADVANCEDtbl_Orders_Result.h
	The implementation of properties and methods for the SQLSTUDIOADVANCEDtbl_Orders_Result object.
	Generated by SudzC.com
*/
#import "SQLSTUDIOADVANCEDtbl_Orders_Result.h"

@implementation SQLSTUDIOADVANCEDtbl_Orders_Result
	@synthesize Customer = _Customer;
	@synthesize Driver_ID = _Driver_ID;
	@synthesize Order_Created = _Order_Created;
	@synthesize Order_ID = _Order_ID;
	@synthesize Order_Number = _Order_Number;
	@synthesize Order_Status = _Order_Status;
	@synthesize PO_Number = _PO_Number;

	- (id) init
	{
		if(self = [super init])
		{
			self.Order_Created = nil;
			self.Order_Number = nil;
			self.PO_Number = nil;

		}
		return self;
	}

	+ (SQLSTUDIOADVANCEDtbl_Orders_Result*) createWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return [[self alloc] initWithNode: node];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Customer = [[Soap getNodeValue: node withName: @"Customer"] intValue];
			self.Driver_ID = [[Soap getNodeValue: node withName: @"Driver_ID"] intValue];
			self.Order_Created = [Soap dateFromString: [Soap getNodeValue: node withName: @"Order_Created"]];
			self.Order_ID = [[Soap getNodeValue: node withName: @"Order_ID"] intValue];
			self.Order_Number = [Soap getNodeValue: node withName: @"Order_Number"];
			self.Order_Status = [[Soap getNodeValue: node withName: @"Order_Status"] intValue];
			self.PO_Number = [Soap getNodeValue: node withName: @"PO_Number"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"tbl_Orders_Result"];
	}
  
	- (NSMutableString*) serialize: (NSString*) nodeName
	{
		NSMutableString* s = [NSMutableString string];
		[s appendFormat: @"<%@", nodeName];
		[s appendString: [self serializeAttributes]];
		[s appendString: @">"];
		[s appendString: [self serializeElements]];
		[s appendFormat: @"</%@>", nodeName];
		return s;
	}
	
	- (NSMutableString*) serializeElements
	{
		NSMutableString* s = [super serializeElements];
		[s appendFormat: @"<Customer>%@</Customer>", [NSString stringWithFormat: @"%i", self.Customer]];
		[s appendFormat: @"<Driver_ID>%@</Driver_ID>", [NSString stringWithFormat: @"%i", self.Driver_ID]];
		if (self.Order_Created != nil) [s appendFormat: @"<Order_Created>%@</Order_Created>", [Soap getDateString: self.Order_Created]];
		[s appendFormat: @"<Order_ID>%@</Order_ID>", [NSString stringWithFormat: @"%i", self.Order_ID]];
		if (self.Order_Number != nil) [s appendFormat: @"<Order_Number>%@</Order_Number>", [[self.Order_Number stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<Order_Status>%@</Order_Status>", [NSString stringWithFormat: @"%i", self.Order_Status]];
		if (self.PO_Number != nil) [s appendFormat: @"<PO_Number>%@</PO_Number>", [[self.PO_Number stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[SQLSTUDIOADVANCEDtbl_Orders_Result class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}

@end
