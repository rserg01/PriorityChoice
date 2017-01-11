//
//  FinCalc.m
//  PriorityCh_test4
//
//  Created by Manulife on 8/15/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "FinCalc.h"
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

@interface FinCalc ()

@property (nonatomic, retain) NSMutableArray *arrChild;
@property (nonatomic, assign) NSNumber *currentAge;
@property (nonatomic, assign) NSString *gender;
@property (nonatomic, assign) NSNumber *currency;

@end

@implementation FinCalc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initImgTitle:[Session_FinCalc sharedSession].productName];
    [self initSwitch:[Session_FinCalc sharedSession].productName];
    [self addTopButtons];
    [self updateSwitchDeathBenType];
    _currency = [NSNumber numberWithInt:14];
    [self updateFundTextFields:[Session_FinCalc sharedSession].productName currency:_currency];

}


#pragma mark - Custom Methods

- (void) addTopButtons
{
    UIBarButtonItem *setProfile = [[UIBarButtonItem alloc] initWithTitle:@"Set Active Profile" style:UIBarButtonItemStylePlain target:self action:@selector(setActiveProfile)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: setProfile, nil];
}

- (void) initImgTitle: (NSString *) productName
{
    if ([productName isEqualToString:kProductName_AffluenceGold]) {
        NSLog(@"productName = %@", productName);
        [_img_Template setImage:[UIImage imageNamed:@"edited_AffluenceGold.png"]];
    }
    if ([productName isEqualToString:kProductName_AffluenceMaxGold]) {
        NSLog(@"productName = %@", productName);
        [_img_Template setImage:[UIImage imageNamed:@"edited_AffluenceMaxGold.png"]];
    }
    if ([productName isEqualToString:kproductName_WealthPremier]) {
        NSLog(@"productName = %@", productName);
        [_img_Template setImage:[UIImage imageNamed:@"edited_WealthPremiere.png"]];
    }
}

- (void) initSwitch: (NSString *) productName
{
    /*
     20150129 Surge - took out option for HWM
     HWM will no longer be an option in the financial calculator
     */
    
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
            
            [_lbl_BondFund setText:@"Bond Fund"];
            [_txtBondFund setEnabled:YES];
            
            [_lbl_EquityFund setText:@"Equity Fund"];
            [_txtEquityFund setEnabled:YES];
            _txtEquityFund.alpha = 1;
            
            [_lbl_StableFund setText:@"Stable Fund"];
            [_txtStableFund setEnabled:YES];
            _txtStableFund.alpha = 1;
            
            [_lbl_Apbf setText:@""];
            [_txtApbf setEnabled:NO];
            _txtApbf.alpha = 0.3;
            
            [_lbl_BalancedFund setText:@"Balanced Fund"];
            [_txtBalanced setEnabled:YES];
            _txtBalanced.alpha = 1;
            
        } else {
            
            [_lbl_BondFund setText:@"Bond Fund"];
            [_txtBondFund setEnabled:YES];
            
            [_lbl_EquityFund setText:@""];
            [_txtEquityFund setEnabled:NO];
            _txtEquityFund.alpha = 0.3;
            
            
            [_lbl_StableFund setText:@""];
            [_txtStableFund setEnabled:NO];
            _txtStableFund.alpha = 0.3;
            
            [_lbl_Apbf setText:@""];
            [_txtApbf setEnabled:NO];
            _txtApbf.alpha = 0.3;
            
            
            [_lbl_BalancedFund setText:@"Balanced Fund"];
            [_txtBalanced setEnabled:NO];
            _txtBalanced.alpha = 0.3;
        }
        
    }
    
    if (([productName isEqualToString:kProductName_PlatinumInvest]) || ([productName isEqualToString:kProductName_AffluenceMaxGold])) {
        
        if([currency compare:[NSNumber numberWithInt:14]] == NSOrderedSame) {
            
            [_lbl_BondFund setText:@"Secure Fund"];
            [_txtBondFund setEnabled:YES];
            
            [_lbl_EquityFund setText:@"Growth Fund"];
            [_txtEquityFund setEnabled:YES];
            _txtEquityFund.alpha = 1;
            
            [_lbl_StableFund setText:@"Diversified Value Fund"];
            [_txtStableFund setEnabled:YES];
            _txtStableFund.alpha = 1;
            
            [_lbl_Apbf setText:@""];
            [_txtApbf setEnabled:NO];
            _txtApbf.alpha = 0.3;
            
            [_lbl_StableFund setText:@"Dynamic Alloc Fund"];
            [_txtStableFund setEnabled:YES];
            _txtStableFund.alpha = 1;
            
        }
        else {
            
            [_lbl_BondFund setText:@"Secure Fund"];
            [_txtBondFund setEnabled:YES];
            
            [_lbl_EquityFund setText:@"ASEAN Growth Fund"];
            [_txtEquityFund setEnabled:YES];
            _txtEquityFund.alpha = 1;
            
            [_lbl_StableFund setText:@""];
            [_txtStableFund setEnabled:NO];
            _txtStableFund.alpha = 0.3;
            
            [_lbl_Apbf setText:@"Asia Pacfic Bond Fund"];
            [_txtApbf setEnabled:YES];
            _txtApbf.alpha = 1;
            
            [_lbl_StableFund setText:@"Dynamic Alloc Fund"];
            [_txtStableFund setEnabled:NO];
            _txtStableFund.alpha = 0.3;
        }
        
    }
    
    [self clearFundTextFields];
}

- (void) clearFundTextFields
{
    _txtApbf.text = 0;
    _txtBondFund.text = 0;
    _txtEquityFund.text = 0;
    _txtStableFund.text = 0;
    _txtBalanced.text = 0;
}


#pragma mark - Delegate Methods

-(void)closeTheModal
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) finishedDoingMyThing:(NSString *)labelString
{
    if ([labelString isEqualToString:@"success_activeProfile"]) {
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];
        //[self loadProfile];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBActions

- (IBAction)compute:(id)sender
{
    NSMutableArray *_arrErrors = [[[NSMutableArray alloc]init]autorelease];
    
    if ([self.arrChild count] > 0) {
        [self.arrChild removeAllObjects];
    }
    
    _gender = _switchGender.selectedSegmentIndex == 0 ? @"M" : @"F";
    _currentAge = [NSNumber numberWithInt:[_txtCurrentAge.text intValue]];
    
    if ([[Session_FinCalc sharedSession].productName isEqualToString:kproductName_WealthPremier]){
        _txtBondFund.text = @"100";
    }
    
    _arrErrors = [Support_FinCalc Validate:[NSNumber numberWithDouble:[_txtPremium.text doubleValue]]
                                  bondFund:[NSNumber numberWithDouble:[_txtBondFund.text doubleValue]]
                                equityFund:[NSNumber numberWithDouble:[_txtEquityFund.text doubleValue]]
                                stableFund:[NSNumber numberWithDouble:[_txtStableFund.text doubleValue]]
                                   apbFund:[NSNumber numberWithDouble:[_txtApbf.text doubleValue]]
                              balancedFund:[NSNumber numberWithDouble:[_txtBalanced.text doubleValue]]
                                       age:_currentAge
                                       sex:_gender
                               productName:[Session_FinCalc sharedSession].productName
                                  currency:_currency
                                    dbType:[NSNumber numberWithInteger:_switchDeathBenType.selectedSegmentIndex]
                                   channel:[Utility getUserDefaultsValue:@"CHANNEL"]];
    
    
    if ([_arrErrors count] == 0) {
        
        NSNumber *bondAllocation = [[[NSNumber alloc]init]autorelease];
        NSNumber *stableAllocation = [[[NSNumber alloc]init]autorelease];
        NSNumber *equityAllocation = [[[NSNumber alloc]init]autorelease];
        NSNumber *apbfAllocation = [[[NSNumber alloc]init]autorelease];
        NSNumber *balancedAllocation = [[[NSNumber alloc]init]autorelease];
        
        bondAllocation = [NSNumber numberWithDouble:([_txtBondFund.text doubleValue]/ 100)];
        equityAllocation = [NSNumber numberWithDouble:([_txtEquityFund.text doubleValue]/ 100)];
        stableAllocation = [NSNumber numberWithDouble:([_txtStableFund.text doubleValue]/ 100)];
        apbfAllocation = [NSNumber numberWithDouble:([_txtApbf.text doubleValue]/ 100)];
        
        NSLog(@"Bond = %@", bondAllocation);
        NSLog(@"Equity = %@", equityAllocation);
        NSLog(@"Stable = %@", stableAllocation);
        NSLog(@"APBF = %@", apbfAllocation);
        
        self.arrChild = [Support_FinCalc getAccountValue:_currentAge
                                                 premium:[NSNumber numberWithInt:[_txtPremium.text intValue]]
                                          bondAllocation:bondAllocation
                                        equityAllocation:equityAllocation
                                        stableAllocation:stableAllocation
                                      balancedAllocation:balancedAllocation
                                          apbfAllocation:apbfAllocation
                                              growthRate:[NSNumber numberWithInteger:[_switchGrowthRate selectedSegmentIndex]]
                                             productName:[Session_FinCalc sharedSession].productName
                                                currency:_currency
                                                   isFel:[Session_FinCalc sharedSession].isFel
                                                  gender:_gender
                                            deathBenType:[Session_FinCalc sharedSession].deathBenType];
        
        //       self.arrChild = [Support_FinCalc getAccountValue:[NSNumber numberWithDouble:30]
        //                                                premium:[NSNumber numberWithInt:500000]
        //                                         bondAllocation:[NSNumber numberWithDouble:0]
        //                                       equityAllocation:[NSNumber numberWithDouble:0]
        //                                       stableAllocation:[NSNumber numberWithDouble:1]
        //                                         apbfAllocation:[NSNumber numberWithDouble:0]
        //                                             growthRate:[NSNumber numberWithInt:0]
        //                                            productName:[Session_FinCalc sharedSession].productName
        //                                               currency:[Session_FinCalc sharedSession].currency
        //                                                  isFel:[Session_FinCalc sharedSession].isFel
        //                                                 gender:@"F"
        //                                           deathBenType:[NSNumber numberWithInt:1]];
        
        [_tblView reloadData];
    }
    else {
        
        [[FNASession sharedSession].finCalcErrors removeAllObjects];
        [FNASession sharedSession].finCalcErrors = _arrErrors;
        [self performSegueWithIdentifier:@"toErrorPage" sender:self];
    }
    
    [_arrErrors removeAllObjects];
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


#pragma mark - TableView

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    [_img_Template release];
    [_tblView release];
    [_txtBondFund release];
    [_txtEquityFund release];
    [_txtStableFund release];
    [_txtApbf release];
    [_txtPremium release];
    [_txtCurrentAge release];
    [_switchCurrency release];
    [_switchGender release];
    [_switchGrowthRate release];
    [_switchDeathBenType release];
    [_btn_Compute release];
    
    [_arrChild release];
    //[_currentAge release];
    [_gender release];
    //[_currency release];
    
    [_lbl_BondFund release];
    [_lbl_EquityFund release];
    [_lbl_StableFund release];
    [_lbl_Apbf release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImg_Template:nil];
    [self setTblView:nil];
    [self setTxtBondFund:nil];
    [self setTxtEquityFund:nil];
    [self setTxtStableFund:nil];
    [self setTxtApbf:nil];
    [self setTxtPremium:nil];
    [self setTxtCurrentAge:nil];
    [self setSwitchCurrency:nil];
    [self setSwitchGender:nil];
    [self setSwitchGrowthRate:nil];
    [self setSwitchDeathBenType:nil];
    [self setBtn_Compute:nil];
    
    [self setArrChild:nil];
    [self setCurrentAge:nil];
    [self setGender:nil];
    [self setCurrency:nil];
    
    [self setLbl_BondFund:nil];
    [self setLbl_EquityFund:nil];
    [self setLbl_StableFund:nil];
    [self setLbl_Apbf:nil];
    [super viewDidUnload];
}


@end
