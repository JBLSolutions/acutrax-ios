#import "MyPicker.h"
#import "SPLAppDelegate.h"


@implementation MyPicker
@synthesize pcMain;
@synthesize btnMain;
@synthesize rawData;
@synthesize delegate;
@synthesize tblData;

    static NSString *CellIdentifier = @"Cell";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        rawData = [[NSMutableArray alloc] init];
        SPLAppDelegate *myDelegate = (SPLAppDelegate*)[[UIApplication sharedApplication] delegate];
        rawData = [myDelegate listAllTypes];
//        [pcMain reloadAllComponents];
        [tblData registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        [tblData reloadData];
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSearch];
}

- (void)viewDidUnload
{
    [self setPcMain:nil];
    [self setBtnMain:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnMain_Touch:(id)sender 
{
    [delegate touchedOK:self];
}



//table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [self.searchResult count];
    }
    return [rawData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //the commented code below was having no effect. We were dropping into this condition every single time.
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell prepareForReuse];
        CGRect frame;
        frame.origin.x = 10;
        frame.origin.y = 5;
        frame.size.height = 20;
        BOOL iPad = NO;
#ifdef UI_USER_INTERFACE_IDIOM
        iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
        
        if(iPad == YES)
        {
            frame.size.width = 768;
        }
        else
        {
            frame.size.width = 300;
        }
        UILabel *labelName = [[UILabel alloc]initWithFrame:frame];
        labelName.tag = 1;
        [cell.contentView addSubview:labelName];
        labelName.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        labelName.textColor = [UIColor blackColor];
        labelName.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails = [[UILabel alloc]initWithFrame:frame];
        lblDetails.tag = 2;
        [cell.contentView addSubview:lblDetails];
        lblDetails.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails.textColor = [UIColor blackColor];
        lblDetails.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails2 = [[UILabel alloc]initWithFrame:frame];
        lblDetails2.tag = 3;
        [cell.contentView addSubview:lblDetails2];
        lblDetails2.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails2.textColor = [UIColor blackColor];
        lblDetails2.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails3 = [[UILabel alloc]initWithFrame:frame];
        lblDetails3.tag = 4;
        [cell.contentView addSubview:lblDetails3];
        lblDetails3.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails3.textColor = [UIColor blackColor];
        lblDetails3.backgroundColor = [UIColor clearColor];
        
        frame.origin.y += 20;
        UILabel *lblDetails4 = [[UILabel alloc]initWithFrame:frame];
        lblDetails4.tag = 5;
        [cell.contentView addSubview:lblDetails4];
        lblDetails4.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        lblDetails4.textColor = [UIColor blackColor];
        lblDetails4.backgroundColor = [UIColor clearColor];
        

        
    }
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:1];
    UILabel *detailLabel = (UILabel*)[cell.contentView viewWithTag:2];
    UILabel *detailLabel2 = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *detailLabel3 = (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *detailLabel4 = (UILabel*)[cell.contentView viewWithTag:5];

    SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result *myGSO;
    if (self.searchController.active){
        myGSO = (SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)[self.searchResult objectAtIndex:indexPath.row];
    } else {
        myGSO = (SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result*)[rawData objectAtIndex:indexPath.row];
    }
    nameLabel.text = myGSO.Cylinder_Type;
    detailLabel.text =  myGSO.Description_1;
    detailLabel2.text = myGSO.Description_2;
    detailLabel3.text = myGSO.Description_3;
    detailLabel4.text = myGSO.Description_4;
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    UIImage *myaccimage = [UIImage imageNamed:@"disclosure_indicator_blue.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myaccimage];
    [cell setAccessoryView:imageView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rowgradient.png"]];
    cell.backgroundView = tempImageView;
    UIImage *cachedImage = [UIImage imageNamed:@"web_icon.png"];
    cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView setImage:cachedImage];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCylinder = nil;
    if (self.searchController.active) {
        self.selectedCylinder = [self.searchResult objectAtIndex:indexPath.row];
    }
    else {
        self.selectedCylinder = [self.rawData objectAtIndex:indexPath.row];
    }
    [delegate touchedOK:self];
}

- (void) setupSearch {
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.rawData count]];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = NSLocalizedString(@"Search by name or address", "search by name or address");
    
    [self.tblData setTableHeaderView:self.searchController.searchBar]; //this line add the searchBar
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tblData reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger*)scope
{
    /*
     Update the filtered array based on the search text and scope.
     */
    
    [self.searchResult removeAllObjects]; // First clear the filtered array.
    
    NSLog(@"scope is :%@;", scope);
    NSLog(@"search test is %@", searchText);
    NSLog(@"searchbar.text is %@", self.searchController.searchBar.text);
    /*
     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    
    for (SQLSTUDIOADVANCEDtbl_Cylinder_Type_Result* data in rawData)
    {
        NSRange range = [[data.Cylinder_Type lowercaseString] rangeOfString:[searchText lowercaseString]];
        if (range.length > 0)
        {
            [self.searchResult addObject:data];
        }
    }
}@end

