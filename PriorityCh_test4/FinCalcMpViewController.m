//
//  FinCalcMpViewController.m
//  PriorityCh_test4
//
//  Created by Mateo on 5/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "FinCalcMpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Session_FinCalc.h"
#import "Support_FinCalc.h"
#import "Utility.h"
#import "FnaConstants.h"
#import "FNASession.h"
#import "GetPersonalProfile.h"
#import "FinCalcCustomCell.h"
#import "Support_Retirement.h"
#import "ModalActiveProfileViewController.h"

@interface FinCalcMpViewController ()

@property (nonatomic, retain) NSMutableArray *arrChild;
@property (nonatomic, assign) NSNumber *currentAge;
@property (nonatomic, assign) NSString *gender;
@property (nonatomic, assign) NSNumber *currency;
@property (nonatomic, retain) NSString *channelName;
@property (nonatomic, retain) NSString *fundName1;
@property (nonatomic, retain) NSString *fundName2;
@property (nonatomic, retain) NSString *fundName3;
@property (nonatomic, retain) NSString *fundName4;
@property (nonatomic, retain) NSString *fundName5;

@end

@implementation FinCalcMpViewController

@synthesize arrChild = _arrChild;


#pragma mark - Life Cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _channelName = [Utility getUserDefaultsValue:@"CHANNEL"];
    
    [self initImgTitle:[Session_FinCalc sharedSession].productName];
    [self initSwitch:[Session_FinCalc sharedSession].productName];
    [self addTopButtons];
    [self updateSwitchDeathBenType];
    _currency = [NSNumber numberWithInt:14];
    [self updateFundTextFields:[Session_FinCalc sharedSession].productName currency:_currency];
    
    _lbl_Overlay.layer.cornerRadius = 8;
    _img_Title.layer.cornerRadius = 8;
    
    [self loadProfile];
}

#pragma mark - Custom Methods

- (void) addTopButtons
{
    UIBarButtonItem *setProfile = [[UIBarButtonItem alloc] initWithTitle:@"Set Active Profile" style:UIBarButtonItemStylePlain target:self action:@selector(setActiveProfile)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: setProfile, nil];
}

- (void) loadProfile
{
    if ([[FNASession sharedSession].profileId length] > 0 ) {
        
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        _currentAge = [Support_Retirement getCurrentAge:[Support_Retirement getBirthdate:[FNASession sharedSession].clientDob]];
        
        [_txt_CurrentAge setText:[NSString stringWithFormat:@"%@", _currentAge]];
        [_switch_Gender setSelectedSegmentIndex:[[FNASession sharedSession].clientGender isEqualToString:@"M"] ? 0 : 1];
        
        [_txt_CurrentAge setUserInteractionEnabled:NO];
        [_txt_CurrentAge setBorderStyle:UITextBorderStyleNone];
        [_switch_Gender setUserInteractionEnabled:NO];
    }
    else {
        
        [_txt_CurrentAge setUserInteractionEnabled:YES];
        [_txt_CurrentAge setBorderStyle:UITextBorderStyleRoundedRect];
        [_switch_Gender setUserInteractionEnabled:YES];
    }
}

- (void) initImgTitle: (NSString *) productName
{
    if ([[Utility getUserDefaultsValue:@"CHANNEL"] isEqualToString:@"MBCL"]) {
        
        if ([productName isEqualToString:kProductName_AffluenceGold]) {
            NSLog(@"productName = %@", productName);
            [_img_Title setImage:[UIImage imageNamed:@"edited_Enrich.png"]];
        }
        if ([productName isEqualToString:kProductName_AffluenceMaxGold]) {
            NSLog(@"productName = %@", productName);
            [_img_Title setImage:[UIImage imageNamed:@"edited_PlatinumInvestElite_trans.png"]];
        }
        if ([productName isEqualToString:kproductName_WealthPremier]) {
            NSLog(@"productName = %@", productName);
            [_img_Title setImage:[UIImage imageNamed:@"edited_McblWealthPremier_trans1.png"]];
        }
    }
    else {
        
        if ([productName isEqualToString:kProductName_AffluenceGold]) {
            NSLog(@"productName = %@", productName);
            [_img_Title setImage:[UIImage imageNamed:@"edited_AffluenceGold.png"]];
        }
        if ([productName isEqualToString:kProductName_AffluenceMaxGold]) {
            NSLog(@"productName = %@", productName);
            [_img_Title setImage:[UIImage imageNamed:@"edited_AffluenceMaxGold.png"]];
        }
        if ([productName isEqualToString:kproductName_WealthPremier]) {
            NSLog(@"productName = %@", productName);
            [_img_Title setImage:[UIImage imageNamed:@"edited_WealthPremiere.png"]];
        }
    }
}

- (void) initSwitch: (NSString *) productName
{
    if ((![productName isEqualToString:kproductName_WealthPremier]) && (![productName isEqualToString:kProductName_McblWealthPrem])) {
        
        //determine deathBenType
        if ([productName isEqualToString:kProductName_PlatinumInvest] || [productName isEqualToString:kProductName_AffluenceMaxGold]) {
            
            [_switchDeathBenType setUserInteractionEnabled:NO];
            [_switchDeathBenType setSelectedSegmentIndex:1];
            [self updateSwitchDeathBenType];
            [Session_FinCalc sharedSession].isFel = [NSNumber numberWithInt:0]; //false
            _switchDeathBenType.alpha = 0;
        }
        else {
            
            [self updateSwitchDeathBenType];
            [Session_FinCalc sharedSession].isFel = [NSNumber numberWithInt:1]; //true
        }
    }
    else {
        
        [self initializeUI_Hwm];
    }

}

- (void) initializeUI_Hwm
{
    //set currency switch
    [_switchCurrency setUserInteractionEnabled:NO];
    [_switchCurrency setSelectedSegmentIndex:1];
    
    //set _switchDeathBenType
    [_switchDeathBenType setUserInteractionEnabled:NO];
    [_switchDeathBenType setSelectedSegmentIndex:1];
    [self updateSwitchDeathBenType];
    
    //update textfields
    [_lbl_BondFund setText:@"Wealth\nPremier\n2023 Fund"];
    [_txtBondFUnd setEnabled:NO];
    [_txtBondFUnd setAlpha:0];

    
    //set height for _lblTitle
    //CGRect frameRect = _lbl_BondFund.frame;
    //frameRect.size.height = 60;
    //_lbl_BondFund.frame = frameRect;
    
    [_lbl_EquityFund setText:@""];
    [_txtEquityFund setEnabled:NO];
    _txtEquityFund.alpha = 0;
    
    [_lbl_StableFund setText:@""];
    [_txtStableFund setEnabled:NO];
    _txtStableFund.alpha = 0;
    
    [_lbl_Apbf setText:@""];
    [_txtApbf setEnabled:NO];
    _txtApbf.alpha = 0;
}

- (void) updateSwitchDeathBenType
{
    if (_switchDeathBenType.selectedSegmentIndex == 0) {
        [Session_FinCalc sharedSession].deathBenType = [NSNumber numberWithInt:1];
    }
    else {
        [Session_FinCalc sharedSession].deathBenType = [NSNumber numberWithInt:1];
    }
}

- (void) updateFundTextFields: (NSString *) productName currency: (NSNumber *) currency
{
    //check channel
    
    if (([productName isEqualToString:kProductName_EnrichMax]) || ([productName isEqualToString:kProductName_AffluenceGold])) {
        
        if ([currency compare:[NSNumber numberWithInt:14]] == NSOrderedSame) {
            
            _fundName1 = kFundName_MP_BondFund;
            _fundName2 = kFundName_MP_EquityFund;
            _fundName3 = kFundName_MP_StableFund;
            _fundName4 = @"";
            _fundName5 = kFundName_MP_Balanced;
            
            [_txtBondFUnd setEnabled:YES];
            
            [_txtEquityFund setEnabled:YES];
            _txtEquityFund.alpha = 1;
            
            [_txtStableFund setEnabled:YES];
            _txtStableFund.alpha = 1;
            
            [_txtApbf setEnabled:NO];
            _txtApbf.alpha = 0.3;
            
            [_txtBalanced setEnabled:YES];
            _txtBalanced.alpha = 1;
            
        } else {
            
            _fundName1 = kFundName_MP_BondFund;
            _fundName2 = @"";
            _fundName3 = @"";
            _fundName4 = @"";
            _fundName5 = @"";
            
            [_txtBondFUnd setEnabled:YES];
            
            [_txtEquityFund setEnabled:NO];
            _txtEquityFund.alpha = 0.3;
            
            [_txtStableFund setEnabled:NO];
            _txtStableFund.alpha = 0.3;
            
            [_txtApbf setEnabled:NO];
            _txtApbf.alpha = 0.3;
            
            [_txtBalanced setEnabled:NO];
            _txtBalanced.alpha = 0.3;
        }
        
        [_lbl_BondFund setText:_fundName1];
        [_lbl_EquityFund setText:_fundName2];
        [_lbl_StableFund setText:_fundName3];
        [_lbl_Apbf setText:_fundName4];
        [_lbl_Balanced setText:_fundName5];
        
    }
    
    if (([productName isEqualToString:kProductName_PlatinumInvest]) || ([productName isEqualToString:kProductName_AffluenceMaxGold])) {
        
        if([currency compare:[NSNumber numberWithInt:14]] == NSOrderedSame) {
            
            _fundName1 = kFundName_MP_SecureFund;
            _fundName2 = kFundName_MP_GrowthFund;
            _fundName3 = kFundName_MP_Diversified;
            _fundName4 = @"";
            _fundName5 = kFundName_MP_Dynamic;
            
            [_txtBondFUnd setEnabled:YES];
            
            [_txtEquityFund setEnabled:YES];
            _txtEquityFund.alpha = 1;
            
            [_txtStableFund setEnabled:YES];
            _txtStableFund.alpha = 1;
            
            [_txtApbf setEnabled:NO];
            _txtApbf.alpha = 0.3;
            
            [_txtBalanced setEnabled:YES];
            _txtBalanced.alpha = 1;
            
        }
        else {
            
            _fundName1 = kFundName_MP_SecureFund;
            _fundName2 = kFundName_MP_ASEAN;
            _fundName3 = @"";
            _fundName4 = kFundName_MP_Apbf;
            _fundName5 = @"";
            
            [_lbl_BondFund setText:@"Secure Fund"];
            [_txtBondFUnd setEnabled:YES];
            
            [_lbl_EquityFund setText:@"ASEAN Growth Fund"];
            [_txtEquityFund setEnabled:YES];
            _txtEquityFund.alpha = 1;
            
            [_lbl_StableFund setText:@""];
            [_txtStableFund setEnabled:NO];
            _txtStableFund.alpha = 0.3;
            
            [_lbl_Apbf setText:@"Asia Pacfic Bond Fund"];
            [_txtApbf setEnabled:YES];
            _txtApbf.alpha = 1;
            
            [_lbl_Balanced setText:@""];
            [_txtBalanced setEnabled:NO];
            _txtBalanced.alpha = 0.3;
        }
        
        [_lbl_BondFund setText:_fundName1];
        [_lbl_EquityFund setText:_fundName2];
        [_lbl_StableFund setText:_fundName3];
        [_lbl_Apbf setText:_fundName4];
        [_lbl_Balanced setText:_fundName5];
        
    }
    
    [self clearFundTextFields];
}

- (void) clearFundTextFields
{
    _txtApbf.text = 0;
    _txtBondFUnd.text = 0;
    _txtEquityFund.text = 0;
    _txtStableFund.text = 0;
    _txtBalanced.text = 0;
}

#pragma mark - IBActions

- (IBAction)compute:(id)sender
{
    //init values
    NSMutableArray *_arrErrors = [[[NSMutableArray alloc]init]autorelease];
    NSNumber *deathBentype = [[[NSNumber alloc]init]autorelease];
    
    
    if ([self.arrChild count] > 0) {
        [self.arrChild removeAllObjects];
    }
    
    _gender = _switch_Gender.selectedSegmentIndex == 0 ? @"M" : @"F";
    _currentAge = [NSNumber numberWithInt:[_txt_CurrentAge.text intValue]];
    
    if ([[Session_FinCalc sharedSession].productName isEqualToString:kproductName_WealthPremier]) {
        _currency = [NSNumber numberWithInt:2];
    }
    else {
        _currency = _switchCurrency.selectedSegmentIndex == 0 ? [NSNumber numberWithInt:14] : [NSNumber numberWithInt:2];
    }
    
    
    
    if ([[Session_FinCalc sharedSession].productName isEqualToString:kproductName_WealthPremier]){
        _txtBondFUnd.text = @"100";
    }
    
    //determine deathBenType
    if ([[Session_FinCalc sharedSession].productName isEqualToString:kProductName_AffluenceGold]){
        
        NSNumber *sel = [[[NSNumber alloc]init]autorelease];
        sel = [NSNumber numberWithInt:_switchDeathBenType.selectedSegmentIndex];
        
        deathBentype = sel;
    }
    else {
        
        deathBentype = [NSNumber numberWithInt:2];
    }
    
    _arrErrors = [Support_FinCalc Validate:[NSNumber numberWithDouble:[_txt_Premium.text doubleValue]]
                                  bondFund:[NSNumber numberWithDouble:[_txtBondFUnd.text doubleValue]]
                                equityFund:[NSNumber numberWithDouble:[_txtEquityFund.text doubleValue]]
                                stableFund:[NSNumber numberWithDouble:[_txtStableFund.text doubleValue]]
                                   apbFund:[NSNumber numberWithDouble:[_txtApbf.text doubleValue]]
                              balancedFund:[NSNumber numberWithDouble:[_txtBalanced.text doubleValue]]
                                       age:_currentAge
                                       sex:_gender
                               productName:[Session_FinCalc sharedSession].productName
                                  currency:_currency
                                    dbType:deathBentype
                                   channel:[Utility getUserDefaultsValue:@"CHANNEL"]];
    
                      
   if ([_arrErrors count] == 0)
   {
       
       NSNumber *bondAllocation = [[[NSNumber alloc]init]autorelease];
       NSNumber *stableAllocation = [[[NSNumber alloc]init]autorelease];
       NSNumber *equityAllocation = [[[NSNumber alloc]init]autorelease];
       NSNumber *apbfAllocation = [[[NSNumber alloc]init]autorelease];
       NSNumber *balancedAllocation = [[[NSNumber alloc]init]autorelease];
       
       bondAllocation = [NSNumber numberWithDouble:([_txtBondFUnd.text doubleValue]/ 100)];
       equityAllocation = [NSNumber numberWithDouble:([_txtEquityFund.text doubleValue]/ 100)];
       stableAllocation = [NSNumber numberWithDouble:([_txtStableFund.text doubleValue]/ 100)];
       apbfAllocation = [NSNumber numberWithDouble:([_txtApbf.text doubleValue]/ 100)];
       balancedAllocation = [NSNumber numberWithDouble:([_txtBalanced.text doubleValue]/ 100)];
       
       self.arrChild = [Support_FinCalc getAccountValue:_currentAge
                                                premium:[NSNumber numberWithInt:[_txt_Premium.text intValue]]
                                         bondAllocation:bondAllocation
                                       equityAllocation:equityAllocation
                                       stableAllocation:stableAllocation
                                     balancedAllocation:balancedAllocation
                                         apbfAllocation:apbfAllocation
                                             growthRate:[NSNumber numberWithInt:[_switchGrowthRate selectedSegmentIndex]]
                                            productName:[Session_FinCalc sharedSession].productName
                                               currency:_currency
                                                  isFel:[Session_FinCalc sharedSession].isFel
                                                 gender:_gender
                                           deathBenType:deathBentype];
       
       
//       self.arrChild = [Support_FinCalc getAccountValue:[NSNumber numberWithDouble:45]
//                                                premium:[NSNumber numberWithInt:31250]
//                                         bondAllocation:[NSNumber numberWithDouble:.2]
//                                       equityAllocation:[NSNumber numberWithDouble:.4]
//                                       stableAllocation:[NSNumber numberWithDouble:0]
//                                         apbfAllocation:[NSNumber numberWithDouble:.4]
//                                             growthRate:[NSNumber numberWithInt:0]
//                                            productName:[Session_FinCalc sharedSession].productName
//                                               currency:[NSNumber numberWithInt:2]
//                                                  isFel:[Session_FinCalc sharedSession].isFel
//                                                 gender:@"M"
//                                           deathBenType:deathBentype];
       
       [_tblView reloadData];
   }
   else {
       
       [[FNASession sharedSession].finCalcErrors removeAllObjects];
       [FNASession sharedSession].finCalcErrors = _arrErrors;
       [self performSegueWithIdentifier:@"toErrorPage" sender:self];
   }
    
    [_arrErrors removeAllObjects];
}

- (void) setActiveProfile
{
    [self performSegueWithIdentifier:@"toProfileList" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toErrorPage"]) {
        [[segue destinationViewController] setFincalcerror_delegate:self];
        FinCalcErrorListViewController *modal = [[[FinCalcErrorListViewController alloc]init]autorelease];
        [modal setFincalcerror_delegate:self];
    }
    
    if ([[segue identifier] isEqualToString:@"toProfileList"]) {
        [[segue destinationViewController] setDelegate1:self];
        ModalActiveProfileViewController *modal = [[[ModalActiveProfileViewController alloc]init]autorelease];
        modal.delegate1 = self;
    }
}

- (IBAction)changeCurrency:(id)sender {
    
    NSNumber *currencyValue = [[[NSNumber alloc]init]autorelease];
    
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *seg = (UISegmentedControl *) sender;
        
        if (seg.selectedSegmentIndex == 0) {
            currencyValue = [NSNumber numberWithInt:14];
        }
        else {
            currencyValue = [NSNumber numberWithInt:2];
        }
        
    }
    
    _currency = currencyValue;
    
    [self updateFundTextFields:[Session_FinCalc sharedSession].productName currency:_currency];
}

#pragma mark -
#pragma mark Delegate Methods

-(void)closeTheModal
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) finishedDoingMyThing:(NSString *)labelString
{
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        [self loadProfile];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -
#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.arrChild count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FinCalcCustomCell *cell = (FinCalcCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FinCalcCustomCell" owner:self options:nil];
    for (id _cell in nib)
    {
        if ([_cell isKindOfClass:[FinCalcCustomCell class]])
        {
            cell = (FinCalcCustomCell *)_cell;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
    }
    
    NSDictionary *dicItem = [[[NSDictionary alloc]init]autorelease];
    
    dicItem = [NSDictionary dictionaryWithDictionary:[self.arrChild objectAtIndex:indexPath.row]];
    
    [cell.lblYear setText:[dicItem objectForKey:@"intYear"]];
    [cell.lblAge setText:[dicItem objectForKey:@"yearSpan"]];
    [cell.lblAcctValue setText:[dicItem objectForKey:@"strAcctValue"]];
    [cell.lblDeathBen setText:[dicItem objectForKey:@"strDbFinal"]];
    
    cell.showsReorderControl = YES;
    
    return cell;
}


#pragma mark -
#pragma Memory Management

- (void)dealloc {
    
    [_lbl_Overlay release];
    [_tblView release];
    
    [_switchCurrency release];
    [_switchDeathBenType release];
    [_switchGrowthRate release];
    [_switch_Gender release];
    
    [_txtBondFUnd release];
    [_txtEquityFund release];
    [_txtStableFund release];
    [_txtApbf release];
    [_txt_Premium release];
    [_txt_CurrentAge release];
    
    [_lbl_BondFund release];
    [_lbl_EquityFund release];
    [_lbl_StableFund release];
    [_lbl_Apbf release];
    
    [_btnCompute release];
    
    [_arrChild release];
    [_gender release];

    [_img_Title release];
    
    [super dealloc];
}


- (void)viewDidUnload {
    
    [self setLbl_Overlay:nil];
    [self setSwitchCurrency:nil];
    [self setSwitchDeathBenType:nil];
    [self setSwitchGrowthRate:nil];
    [self setTxtBondFUnd:nil];
    [self setTxtEquityFund:nil];
    [self setTxtStableFund:nil];
    [self setTxtBalanced:nil];
    [self setTxtApbf:nil];
    [self setBtnCompute:nil];
    [self setTblView:nil];
    [self setLbl_BondFund:nil];
    [self setLbl_EquityFund:nil];
    [self setLbl_StableFund:nil];
    [self setLbl_Apbf:nil];
    [self setLbl_Balanced:nil];
    [self setTxt_Premium:nil];
    [self setSwitch_Gender:nil];
    [self setTxt_CurrentAge:nil];
    [self setArrChild:nil];
    [self setGender:nil];
    [self setCurrentAge:nil];
    [self setImg_Title:nil];
    [self setCurrency:nil];
    
    [super viewDidUnload];
}


@end
