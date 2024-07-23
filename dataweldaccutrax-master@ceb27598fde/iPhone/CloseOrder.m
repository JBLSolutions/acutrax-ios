//
//  CloseOrder.m
//  DataWeld
//
//  Created by Johnathan Rossitter on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CloseOrder.h"
#import "SPLAppDelegate.h"
#import "T1Autograph.h"
#import <QuartzCore/QuartzCore.h>
#import "DW_TransactionItem.h"

@implementation CloseOrder

@synthesize btnDecline;
@synthesize btnConfirm;
@synthesize txtLicense;
@synthesize lblSwipeCard;
@synthesize autograph;
@synthesize outputImage;
@synthesize tblData;
@synthesize rawData;
@synthesize btnSnapPhoto;
@synthesize imgPicker;
@synthesize snappedPhoto;
@synthesize btnClear;
@synthesize autographView;

NSString *orderNumber;

- (void)autographDidCancelModalView:(T1Autograph *)autograph {
	NSLog(@"Autograph modal signature has been cancelled");
}

- (void)autographDidCompleteWithNoSignature:(T1Autograph *)autograph {
	NSLog(@"User pressed the done button without signing");
}

- (void)autograph:(T1Autograph *)autograph didEndLineWithSignaturePointCount:(NSUInteger)count {
	NSLog(@"Line ended with total signature point count of %lu", (unsigned long)count);
	
	// Note: You can use the 'count' parameter to determine if the line is substantial enough to enable the done or clear button.
}
-(void)autograph:(T1Autograph *)autograph didCompleteWithSignature:(T1Signature *)signature {

    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];  

    snappedPhoto = signature.imageView.image;
    NSData* imageData = UIImageJPEGRepresentation(snappedPhoto, 1.0);
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    [imageData writeToFile:[NSString stringWithFormat:@"%@/signature_%@_%@_%@_%@_%@.jpg",imagePath,[myDelegate stringFromDate:[NSDate date]],[NSString stringWithFormat:@"%i",myDelegate.userID],
                            [[NSNumber numberWithDouble:[myDelegate GetLat]] stringValue],
                            [[NSNumber numberWithDouble:[myDelegate GetLong]] stringValue], orderNumber] atomically:NO];

    NSURL *myURL = [[NSURL alloc] initFileURLWithPath:imagePath];
    [self addSkipBackupAttributeToItemAtURL:myURL ];
    
    [myDelegate markOrderAsClosed:orderNumber];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOrderNumber:(NSString*)OrderNumber {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //CGFloat padding = self.view.frame.size.width / 15;
        // Custom initialization
        orderNumber = OrderNumber;
        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        rawData = [myDelegate ListTransactionOfOrder:orderNumber];
        self.title = @"Confirm Order";
        self.navigationItem.leftBarButtonItem = nil;        
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}


- (IBAction)btnConfirm_Touch:(id)sender {
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];

    switch (myDelegate.closeOrderMode) {
        //digital sig
        case 0: {
            NSLog(@"digsig");
            [autograph done:self];
            break;
        }
        //photo
        case 1: {
            if(snappedPhoto == nil) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Close Order" message:@"You have not snapped a photo yet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
//                [alert show];

                UIAlertController * message=   [UIAlertController
                                                alertControllerWithTitle:@"Cannot Close Order"
                                                message:@"You have not snapped a photo yet."
                                                preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction* OkButton = [UIAlertAction
                                           actionWithTitle:@"Ok"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [message dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                
                [message addAction:OkButton];
                
                [self presentViewController:message animated:YES completion:nil];
            
            
            }
            else {
                [myDelegate markOrderAsClosed:orderNumber];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            break;
        }
        //card swipe
        case 2: {
            if(txtLicense.text.length ==0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Close Order" message:@"You have swiped a card yet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
//                [alert show];

                UIAlertController * message=   [UIAlertController
                                                alertControllerWithTitle:@"Cannot Close Order"
                                                message:@"You have swiped a card yet."
                                                preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction* OkButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [message dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                
                [message addAction:OkButton];
                
                [self presentViewController:message animated:YES completion:nil];
            
            
            }
            else {
                SQLSTUDIOADVANCEDAdvanced *service = [[SQLSTUDIOADVANCEDAdvanced alloc] init];
                service.logging = NO;
                [service UploadSwipeSignature:self action:@selector(handleSwipeSig:) FileName: [NSString stringWithFormat:@"swipesignature_%@_%@_%@_%@_%@.txt",[myDelegate stringFromDate:[NSDate date]],[NSString stringWithFormat:@"%i",myDelegate.userID],[[NSNumber numberWithDouble:[myDelegate GetLat]] stringValue],[[NSNumber numberWithDouble:[myDelegate GetLong]] stringValue], orderNumber] FileData:txtLicense.text];
                
            }
            break;
        }
        //none
        case 3: {
            [myDelegate markOrderAsClosed:orderNumber];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
   
}
-(void)handleSwipeSig:(id)result {
    if([result isKindOfClass:[SoapFault class]]) {
    }
    else {
        if([result isKindOfClass:[NSError class]]) {
            NSError *MyError = (NSError*) result;
            if(MyError.code == 410) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network" message:@"Your Network Connection is not Present" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil ];
//                [alert show];

                UIAlertController * message=   [UIAlertController
                                                alertControllerWithTitle:@"Network"
                                                message:@"Your Network Connection is not Present"
                                                preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction* CancelButton = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [message dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];
                
                [message addAction:CancelButton];
                
                [self presentViewController:message animated:YES completion:nil];
            
            }
            return;
        }
    }
    
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate markOrderAsClosed:orderNumber];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)btnDecline_Touch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    switch (myDelegate.closeOrderMode) {
        case 2: {
            [linea disconnect];
            break;
        }
    }
}
//more explicit way of documenting what is going on
//essentially the autographView and the txtLicenseView are never visible at the same time
//its either or.
- (void)hideAutographView {
    autographView.hidden = YES;
    txtLicense.hidden = NO;
    lblSwipeCard.hidden = NO;
    self.btnClear.hidden = YES;
}
- (void)unhideAutographView {
    autographView.hidden = NO;
    txtLicense.hidden = YES;
    lblSwipeCard.hidden = YES;
    self.btnClear.hidden = NO;
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"%i", myDelegate.closeOrderMode);
    txtLicense.hidden = YES;
    lblSwipeCard.hidden = YES;
    autographView.hidden = YES;
    btnSnapPhoto.hidden = YES;
    self.btnClear.hidden = YES;
    switch (myDelegate.closeOrderMode) {
        //digital sig
        case 0: {
            [self unhideAutographView];
            break;
        }
        //photo
        case 1: {
            btnSnapPhoto.hidden = NO;
            break;
        }
        //card swipe
        case 2: {
            [self hideAutographView];
            linea=[Linea sharedDevice];
            [linea setDelegate:self];
            [linea connect];
            break;
        }
        //none
        case 3: {
            break;
        }
        default:
            break;
    }
    [super viewDidLayoutSubviews];
    /*
    [self.btnClear removeFromSuperview];
    [btnClear setTranslatesAutoresizingMaskIntoConstraints:YES];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    if(iPad == YES) {
            [btnClear setFrame:CGRectMake(448,848,300,60)];
    } else {
        if(screenBounds.size.height == 568) {
                [btnClear setFrame:CGRectMake(175,448,131,40)];
        } else {
            [btnClear setFrame:CGRectMake(180,380,131,40)];
        }
    }

    [self.view addSubview:btnClear];
     */
}


-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
			break;
		case CONN_CONNECTED:
            txtLicense.hidden = NO;
            lblSwipeCard.hidden = NO;
            SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
            [linea setMSCardDataMode:MS_PROCESSED_CARD_DATA error:nil];
           // [linea msStartScan];
           // [linea stopScan];
            [linea setScanButtonMode:BUTTON_DISABLED error:nil];
            [linea setScanBeep:myDelegate.playBeep volume:0 beepData:nil length:0 error:nil];
            break;
	}
}

-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3 {
    autographView.hidden = YES;
    
    txtLicense.text =  [NSString stringWithFormat:@"%@%@%@", track1, track2, track3];
   // btnConfirm.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate addGradient:btnConfirm];
    [myDelegate addGradient:btnDecline];
    [myDelegate addGradient:btnSnapPhoto];
    
	// Make a view for the signature
	autographView.layer.borderColor = [UIColor blackColor].CGColor;
	autographView.layer.borderWidth = 3;
	autographView.layer.cornerRadius = 10;
    [autographView setMultipleTouchEnabled:YES];
    // set stroke width.  Default is 6

	[autographView setBackgroundColor:[UIColor whiteColor]];
	
	// Initialize Autograph library
	self.autograph = [T1Autograph autographWithView:autographView delegate:self];
    //[autograph setSwipeToUndoEnabled:YES];
	
	// to remove the watermark, get a license code from Ten One, and enter it here	
//	[autograph setLicenseCode:@"4fabb271f7d93f07346bd02cec7a1ebe10ab7bec"];
    //[autograph setLicenseCode:@"d43379b24277b9a5eb8339f6b17cdcc8916744d9"];
    [autograph setLicenseCode:@"dcc40431be2d8fcf0a6c2f1f70cc831673a5098a"];
    
    [autograph setStrokeWidth:1];

    [autograph setSwipeToUndoEnabled:YES];
}

- (void)viewDidUnload {
    [self setLblSwipeCard:nil];
    [self setTxtLicense:nil];
    [self setBtnConfirm:nil];
    [self setBtnSnapPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rawData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        CGRect frame;
        frame.origin.x = 10;
        frame.origin.y = 5;
        frame.size.height = 20;
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
        
        if(iPad == YES) {
            frame.size.width = 580;
        } else {
            frame.size.width = 300;
        }
        UILabel *labelName = [[UILabel alloc]initWithFrame:frame];
        labelName.tag = 1;
        [cell.contentView addSubview:labelName];
        labelName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        labelName.backgroundColor = [UIColor clearColor];
        labelName.textColor = [UIColor blackColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails = [[UILabel alloc]initWithFrame:frame];
        lblDetails.tag = 2;
        [cell.contentView addSubview:lblDetails];
        lblDetails.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        lblDetails.backgroundColor = [UIColor clearColor];
        lblDetails.textColor = [UIColor blackColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails2 = [[UILabel alloc]initWithFrame:frame];
        lblDetails2.tag = 3;
        [cell.contentView addSubview:lblDetails2];
        lblDetails2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        lblDetails2.backgroundColor = [UIColor clearColor];
        lblDetails2.textColor = [UIColor blackColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails3 = [[UILabel alloc]initWithFrame:frame];
        lblDetails3.tag = 4;
        [cell.contentView addSubview:lblDetails3];
        lblDetails3.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        lblDetails3.backgroundColor = [UIColor clearColor];
        lblDetails3.textColor = [UIColor blackColor];
    }
    
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *detailLabel2 = (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *detailLabel3 = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *detailLabel4 = (UILabel*)[cell.contentView viewWithTag:4];
    
    DW_TransactionItem *myGSO = [rawData objectAtIndex:indexPath.row];
    
    nameLabel.text = myGSO.cylinderType;
    NSLog(@"nameLabel.text = %@", myGSO.cylinderType);
    detailLabel2.text = [NSString stringWithFormat:@"Volume: %@",myGSO.cylinderVolume];

    if([myGSO.operation isEqualToString:@"CS"]) {
      detailLabel3.text = [NSString stringWithFormat:@"Operation: %@",@"Shipped"];
    } else {
      detailLabel3.text = [NSString stringWithFormat:@"Operation: %@",@"Returned"];
    }
  
    detailLabel4.text = [NSString stringWithFormat:@"Tag: %@",myGSO.tagID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rowgradient.png"]];
    cell.backgroundView = tempImageView;
    UIImage *cachedImage = [UIImage imageNamed:@"web_icon.png"];
    cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView setImage:cachedImage];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        DW_TransactionItem *myGSO = [rawData objectAtIndex:indexPath.row];
        [myDelegate DeleteTransaction:myGSO.PK];
        rawData = [myDelegate ListTransactionOfOrder:orderNumber];
        [tblData reloadData];
    }
}
- (IBAction)btnSnapPhotoTouch:(id)sender {
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //[self presentModalViewController:self.imgPicker animated:YES];
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}

//visual based barcode delegate
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info {
        [activityMain startAnimating];
        //[reader dismissModalViewControllerAnimated: YES];
        [reader dismissViewControllerAnimated:YES completion:nil];
        snappedPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
    [activityMain startAnimating];
    //[reader dismissModalViewControllerAnimated: YES];
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    snappedPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];

    
    UIImage *snappedSmall = [myDelegate scaleMe:snappedPhoto toSize:CGSizeMake(640, 960)];
    
    
    
    NSData* imageData = UIImageJPEGRepresentation(snappedSmall, 1.0);
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    [imageData writeToFile:[NSString stringWithFormat:@"%@/photosignature%@_%@_%@_%@_%@.jpg",imagePath,[myDelegate stringFromDate:[NSDate date]],[NSString stringWithFormat:@"%i",myDelegate.userID],[[NSNumber numberWithDouble:[myDelegate GetLat]] stringValue],[[NSNumber numberWithDouble:[myDelegate GetLong]] stringValue], orderNumber] atomically:NO];
    NSURL *myURL = [[NSURL alloc] initFileURLWithPath:imagePath];
    [self addSkipBackupAttributeToItemAtURL:myURL ];
}
- (IBAction)btnClear_Touch:(id)sender {
    [autograph reset:self];
}
@end
