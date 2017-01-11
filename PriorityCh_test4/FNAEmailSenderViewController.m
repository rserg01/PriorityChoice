//
//  FNAEmailSenderViewController.m
//  FNA_20120322
//
//  Created by Manulife on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FNAEmailSenderViewController.h"
#import "Utility.h"
#import "FNASession.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FnaConstants.h"

@interface FNAEmailSenderViewController()

@end


@implementation FNAEmailSenderViewController

@synthesize arrData, clientEmail, agentEmail;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    //- very important step if you want feedbacks on what the user did with your email sheet
    [picker setSubject:@"Priority Choice"];
    
    NSArray *arr = [NSArray arrayWithObjects:clientEmail,agentEmail, nil];
    [picker setToRecipients:arr];
    
    // Fill out the email body text        
    NSString *emailBody = @"";
    
    for(int i = 0; i < [arrData count]; i++)
    {
        NSDictionary *dicData = [NSDictionary dictionaryWithDictionary:[arrData objectAtIndex:i]];
        
        NSLog(@"%@", [dicData objectForKey:@"tableName"]);
        NSLog(@"%@", [dicData objectForKey:@"clientID"]);
        NSLog(@"%@", [dicData objectForKey:@"dataSetName"]);

        
        NSArray *arrFieldnames = [NSArray arrayWithArray:[Utility getColumnNamesForTable:[dicData objectForKey:@"tableName"]]];
        NSDictionary *dicResult = [NSDictionary dictionaryWithDictionary:[Utility getDataSetFromFieldNames2:arrFieldnames withTable:[dicData objectForKey:@"tableName"] withClientID:[dicData objectForKey:@"clientID"] withDataSetName:[dicData objectForKey:@"dataSetName"]]];
        NSArray *tempResult = [NSArray arrayWithArray:[dicResult objectForKey:@"result"]];
        
        for(int j = 0; j < [tempResult count]; j++)
        {
            NSLog(@"j = %d", j);
            NSDictionary *dicTemp = [NSDictionary dictionaryWithDictionary:[tempResult objectAtIndex:j]];
            NSLog(@"dicTemp : %@",dicTemp);
            
            //Priority Rank
            if ([[dicTemp objectForKey:@"dataset"] isEqualToString:kDataset_PriorityRank])
            {
                
                int educFund = [[dicTemp objectForKey:@"EducFund"]intValue]+1;
                int incomeProt = [[dicTemp objectForKey:@"IncomeProt"]intValue]+1;
                int retirement = [[dicTemp objectForKey:@"Retirement"]intValue]+1;
                int investment = [[dicTemp objectForKey:@"Investment"]intValue]+1;
                int health = [[dicTemp objectForKey:@"Health"]intValue]+1;
                int estatePlan = [[dicTemp objectForKey:@"EstatePlan"]intValue]+1;
                NSString *mcblPriority = [dicTemp objectForKey:@"McblPriority"];
                
                NSLog(@"mcblPriority = %@", mcblPriority);
                if ([mcblPriority isEqualToString:@"Investment"]) {
                    mcblPriority = @"You have also magnified this priority:<br/>"
                                    @"Protection product with <b>investment</b> focus."
                                    @"<br/><br/>";
                } else if ([mcblPriority isEqualToString:@"Savings"]) {
                    mcblPriority =  @"You have also magnified this priority:<br/>"
                                    @"Protection product with <b>savings</b> focus."
                                    @"<br/><br/>";
                } else {
                    mcblPriority = @"";
                }
                
                NSString *strChannel = [Utility getUserDefaultsValue:@"CHANNEL"];
                NSString *emailString = @"";
                
                //change images per sales channel
                if ([strChannel isEqualToString:@"MCBL"])
                {
                    emailString = 
                    [NSString stringWithFormat:@"<h2>Priority Ranking</h2><br/>"
                     "Thank you for your time and for entrusting your insurance and financial needs with Manulife.<br/>"
                     "Please find below details of options for you that best suit your needs and your priorities at this time, as we earlier discussed:<br/>"
                     "Education Funding : %i<br/>"
                     "Income Protection : %i<br/>"
                     "Retirement : %i<br/>"
                     "Investment : %i<br/>"
                     "Health : %i<br/>"
                     "Estate Planning : %i<br/>"
                     "<br/>"
                     "%@"
                     "Again, thank you for choosing Manulife, for your future!",
                     educFund,
                     incomeProt,
                     retirement,
                     investment,
                     health,
                     estatePlan,
                     mcblPriority];
                    
                    
                }
                
                else {
                    
                    emailString = 
                    [NSString stringWithFormat:@"<h2>Priority Ranking</h2><br/>"
                     "Thank you for your time and for entrusting your insurance and financial needs with Manulife.<br/>"
                     "Please find below details of options for you that best suit your needs and your priorities at this time, as we earlier discussed:<br/>"
                     "Education Funding : %i<br/>"
                     "Income Protection : %i<br/>"
                     "Retirement : %i<br/>"
                     "Investment : %i<br/>"
                     "Health : %i<br/>"
                     "Estate Planning : %i<br/>"
                     "<br/><br/>"
                     "Again, thank you for choosing Manulife, for your future!",
                     educFund,
                     incomeProt,
                     retirement,
                     investment,
                     health,
                     estatePlan];
                    
                }
                
                emailBody = [emailBody stringByAppendingString:emailString];

            }
            
            //EducFunding
            if ([[dicTemp objectForKey:@"dataset"] isEqualToString:kDataset_Education])
            {
                float allocatedPersonalAsset = [[dicTemp objectForKey:@"AllocatedPersonalAsset"]floatValue]*50000;
                float budget = [[dicTemp objectForKey:@"EducBudget"]floatValue]*5000;
                float presentAnnUnivCost = [[dicTemp objectForKey:@"PresentAnnualCost"]floatValue]*500;
                
                //-----------------
                NSString *emailString = 
                    [NSString stringWithFormat:@"<h2>Education Funding</h2><br/>"
                                                "Present Annual Cost of University : %@<br/>"
                                                "Year of Entry : %@<br/>"
                                                "Allocated Personal Asset : %.0f<br/>"
                                                "Education Savings Goal : %@<br/>"
                                                "Insurance Importance : %@<br/>"
                                                "Budget : %.0f<br/>",
                     
                     [NSString stringWithFormat:@"%.0f", presentAnnUnivCost],
                     [dicTemp objectForKey:@"YearOfEntry"],
                     allocatedPersonalAsset,
                     [dicTemp objectForKey:@"EducSavingsGoal"],
                     [dicTemp objectForKey:@"InsImportance"],
                     budget];
                
                emailBody = [emailBody stringByAppendingString:emailString];
            }
            
            //Income Protection
            if ([[dicTemp objectForKey:@"dataset"] isEqualToString:kDataset_IncomeProtection])
            {
                
                float housing = [[dicTemp objectForKey:@"Housing"]floatValue]*500;
                float food = [[dicTemp objectForKey:@"Food"]floatValue]*500;
                float utilities = [[dicTemp objectForKey:@"Utilities"]floatValue]*500;
                float clothing = [[dicTemp objectForKey:@"Clothing"]floatValue]*500;
                float entertainment= [[dicTemp objectForKey:@"Entertainment"]floatValue]*500;
                float contribution = [[dicTemp objectForKey:@"Contribution"]floatValue]*500;
                float householdHelp = [[dicTemp objectForKey:@"HouseholdHelp"]floatValue]*500;
                float medical = [[dicTemp objectForKey:@"Medical"]floatValue]*500;
                float otherExp = [[dicTemp objectForKey:@"OtherExp"]floatValue]*500;
                float savingsPerMonth = [[dicTemp objectForKey:@"SavingsPerMonth"]floatValue]*500;
                
                emailBody = [emailBody stringByAppendingString:@"<h2>Income Protection</h2><br/>"];
                emailBody = [emailBody stringByAppendingString:@"<strong>Family Expense per Month</strong><br />"];
                emailBody = [emailBody stringByAppendingFormat:@"Housing : %.0f<br/>",housing];
                emailBody = [emailBody stringByAppendingFormat:@"Food : %.0f<br/>",food];
                emailBody = [emailBody stringByAppendingFormat:@"Utilities : %.0f<br/>",utilities];
                emailBody = [emailBody stringByAppendingFormat:@"Clothing : %.0f<br/>",clothing];
                emailBody = [emailBody stringByAppendingFormat:@"Entertainment : %.0f<br/>",entertainment];
                emailBody = [emailBody stringByAppendingFormat:@"Contribution/Gifts : %.0f<br/>",contribution];
                emailBody = [emailBody stringByAppendingFormat:@"Household Help : %.0f<br/>",householdHelp];
                emailBody = [emailBody stringByAppendingFormat:@"Medical Expenses : %.0f<br/>",medical];
                emailBody = [emailBody stringByAppendingFormat:@"Savings per Month: %.0f<br/>",savingsPerMonth];
                emailBody = [emailBody stringByAppendingFormat:@"Other Expenses : %.0f<br/><br/>",otherExp];
                
                emailBody = [emailBody stringByAppendingString:@"<strong>Family Savings Protection Goal</strong><br />"];
                emailBody = [emailBody stringByAppendingFormat:@"Accident & Disability Insurance Need: %@<br/>",[dicTemp objectForKey:@"AccidentDisabilityNeed"]];
                emailBody = [emailBody stringByAppendingFormat:@"Assumed Annual Interest Rate : %@%%<br/>",[dicTemp objectForKey:@"AssumedAnnualIntRate"]];
                emailBody = [emailBody stringByAppendingFormat:@"Protection Goal : %@<br/>",[dicTemp objectForKey:@"ProtectionGoal"]];
                emailBody = [emailBody stringByAppendingFormat:@"Budget : %@<br/>",[dicTemp objectForKey:@"Budget"]];
            }
            
            //Retirement Planning
            if ([[dicTemp objectForKey:@"dataset"] isEqualToString:kDataset_Retirement])
            {
                emailBody = [emailBody stringByAppendingString:@"<h2>Retirement Planning</h2><br/>"];
                emailBody = [emailBody stringByAppendingFormat:@"Retirement Age : %@<br/>",[dicTemp objectForKey:@"RetirementAge"]];
                emailBody = [emailBody stringByAppendingFormat:@"Current Monthly Earnings : %@<br/>",[dicTemp objectForKey:@"CurrentMoEarnings"]];
                emailBody = [emailBody stringByAppendingFormat:@"Expected Annual Increase Rate : %@%%<br/>",[dicTemp objectForKey:@"ExpectedAnnInc"]];
                emailBody = [emailBody stringByAppendingFormat:@"Inflation Rate : %@%%<br/>",[dicTemp objectForKey:@"InflationRate"]];
                emailBody = [emailBody stringByAppendingFormat:@"Assumed Interest Rate : %@%%<br/>",[dicTemp objectForKey:@"InterestRate"]];
                emailBody = [emailBody stringByAppendingFormat:@"Market Rate : %@%%<br/>",[dicTemp objectForKey:@"MarketRate"]];
                emailBody = [emailBody stringByAppendingFormat:@"Life Insurance Need : %@<br/>",[dicTemp objectForKey:@"InsuranceNeed"]];
                emailBody = [emailBody stringByAppendingFormat:@"Accident and Disability Insurance Need : %@<br/>",[dicTemp objectForKey:@"AccidentDisabilityNeed"]];
                emailBody = [emailBody stringByAppendingFormat:@"Monthly Income Needed : %@<br/>",[dicTemp objectForKey:@"MonthlyIncomeNeeded"]];
                emailBody = [emailBody stringByAppendingFormat:@"Retirement Benefit Factor : %@<br/>",[dicTemp objectForKey:@"RetBenFactor"]];
                emailBody = [emailBody stringByAppendingFormat:@"Service Years from Date Hired : %@<br/>",[dicTemp objectForKey:@"ServYrsFrDateHired"]];
                emailBody = [emailBody stringByAppendingFormat:@"Budget : %@<br/>",[dicTemp objectForKey:@"Budget"]];
                emailBody = [emailBody stringByAppendingFormat:@"Notes : %@<br/>",[dicTemp objectForKey:@"Notes"]];
            }
            
            //Investment
            if ([[dicTemp objectForKey:@"dataset"] isEqualToString:kDataset_Investment])
            {
                float incrementvalue = 100000;
                
                float business = [[dicTemp objectForKey:@"prBusiness"]floatValue]*incrementvalue;
                float emergencyFund = [[dicTemp objectForKey:@"prBusiness"]floatValue]*incrementvalue;
                float estateTax = [[dicTemp objectForKey:@"prEstateTax"]floatValue]*incrementvalue;
                float holiday = [[dicTemp objectForKey:@"prHoliday"]floatValue]*incrementvalue;
                float legacy = [[dicTemp objectForKey:@"prLegacy"]floatValue]*incrementvalue;
                float newCar = [[dicTemp objectForKey:@"prNewCar"]floatValue]*incrementvalue;
                float newHome = [[dicTemp objectForKey:@"prNewHome"]floatValue]*incrementvalue;
                float retirement = [[dicTemp objectForKey:@"prRetirement"]floatValue]*incrementvalue;
                
                float budget = [[dicTemp objectForKey:@"Budget"]floatValue]*100000;
                
                int riskProfile = [[dicTemp objectForKey:@"RiskProfile"]intValue];
                NSString *strRiskProfile =@"";
                switch (riskProfile) {
                    case 0:
                        strRiskProfile = @"Conservative";
                        break;
                    case 1:
                        strRiskProfile = @"Moderate";
                        break;
                    case 2:
                        strRiskProfile = @"Aggressive";
                        break;
                    default:
                        break;
                }
                
                
                emailBody = [emailBody stringByAppendingString:@"<h2>Investment & Fund Accumulation</h2><br/>"];
                emailBody = [emailBody stringByAppendingFormat:@"Business : %.0f<br/>",business];
                emailBody = [emailBody stringByAppendingFormat:@"Emergency Fund : %.0f<br/>",emergencyFund];
                emailBody = [emailBody stringByAppendingFormat:@"Estate Tax : %.0f<br/>",estateTax];
                emailBody = [emailBody stringByAppendingFormat:@"Holiday : %.0f<br/>",holiday];
                emailBody = [emailBody stringByAppendingFormat:@"Legacy : %.0f<br/>",legacy];
                emailBody = [emailBody stringByAppendingFormat:@"New Car : %.0f<br/>",newCar];
                emailBody = [emailBody stringByAppendingFormat:@"New Home : %.0f<br/>",newHome];
                emailBody = [emailBody stringByAppendingFormat:@"Retirement : %.0f<br/><br/>",retirement];
                emailBody = [emailBody stringByAppendingFormat:@"Cost of Savings : %@<br/>",[dicTemp objectForKey:@"CostOfSavings"]];
                emailBody = [emailBody stringByAppendingFormat:@"Working Investment : %@<br/>",[dicTemp objectForKey:@"WorkingInvestment"]];
                emailBody = [emailBody stringByAppendingFormat:@"Risk Profile : %@<br/>",strRiskProfile];
                emailBody = [emailBody stringByAppendingFormat:@"Other Investments : %@<br/>",[dicTemp objectForKey:@"InvestmentRequired"]];                
                emailBody = [emailBody stringByAppendingFormat:@"Budget : %.0f<br/>",budget];
            }
            
            //Impaired Health
            if ([[dicTemp objectForKey:@"dataset"] isEqualToString:kDataset_Health])
            {
                
                float employeeCov = [[dicTemp objectForKey:@"EmployeeCoverage"]floatValue]*100000;
                float healthCov = [[dicTemp objectForKey:@"HospitalRoom"]floatValue]*100000;
                
                float semiPrivate = [[dicTemp objectForKey:@"SemiPrivate"]floatValue]*1000;
                float smallPrivate = [[dicTemp objectForKey:@"SmallPrivate"]floatValue]*1000;
                float privateDeLuxe = [[dicTemp objectForKey:@"PrivateDeLuxe"]floatValue]*1000;
                float suite = [[dicTemp objectForKey:@"Suite"]floatValue]*1000;
                
                float medAndNursingCare = [[dicTemp objectForKey:@"MedAndNursingCare"]floatValue]*100000;
                float criticalIllnessCov = [[dicTemp objectForKey:@"CriticalIllnessCoverage"]floatValue]*100000;
                
                                      
                emailBody = [emailBody stringByAppendingString:@"<h2>Living with Impaired Health</h2><br/>"];
                
                emailBody = [emailBody stringByAppendingFormat:@"Employee Coverage : %.0f<br/>",employeeCov];
                emailBody = [emailBody stringByAppendingFormat:@"Health Protection : %.0f<br/>",healthCov];
                
                emailBody = [emailBody stringByAppendingFormat:@"Semi Private : %.0f<br/>",semiPrivate];
                emailBody = [emailBody stringByAppendingFormat:@"Small Private : %.0f<br/>",smallPrivate];
                emailBody = [emailBody stringByAppendingFormat:@"Private De Luxe : %.0f<br/>",privateDeLuxe];
                emailBody = [emailBody stringByAppendingFormat:@"Suite : %.0f<br/>",suite];
                
                emailBody = [emailBody stringByAppendingFormat:@"Accident & Disability Protection : %@<br/>",[dicTemp objectForKey:@"AccidentDisabilityProtection"]];
                emailBody = [emailBody stringByAppendingFormat:@"Coverage Needed : %@<br/>",[dicTemp objectForKey:@"CoverageNeeded"]];
                emailBody = [emailBody stringByAppendingFormat:@"Critical Illness Coverage Need : %@<br/>",[dicTemp objectForKey:@"CriticaIllnessNeed"]];
                emailBody = [emailBody stringByAppendingFormat:@"Critical Illness Covereage : %.0f<br/>",criticalIllnessCov];
                emailBody = [emailBody stringByAppendingFormat:@"Medical and Nursing Care : %.0f<br/>",medAndNursingCare];
                
                emailBody = [emailBody stringByAppendingFormat:@"Need for Health Protection : %@<br/>",[dicTemp objectForKey:@"HealthProtection"]];
                
                emailBody = [emailBody stringByAppendingFormat:@"Notes : %@<br/>",[dicTemp objectForKey:@"Notes"]];
            }
            
            //Estate Planning
            if ([[dicTemp objectForKey:@"dataset"] isEqualToString:kDataset_Estate])
            {
                float incrementValue = 10000;
                
                float funeral = [[dicTemp objectForKey:@"FuneralExp"]floatValue]*incrementValue;
                float judicial = [[dicTemp objectForKey:@"JudicialExp"]floatValue]*incrementValue;
                float insolvency = [[dicTemp objectForKey:@"InsolvencyClaim"]floatValue]*incrementValue;
                float mortgage = [[dicTemp objectForKey:@"UnpaidMortgage"]floatValue]*incrementValue;
                float medicalExp = [[dicTemp objectForKey:@"MedicalExp"]floatValue]*incrementValue;
                float retirement = [[dicTemp objectForKey:@"MedicalExp"]floatValue]*incrementValue;
                float estateClaims = [[dicTemp objectForKey:@"EstateClaims"]floatValue]*incrementValue;
                float spouse = [[dicTemp objectForKey:@"SpouseInterestToEstate"]floatValue]*incrementValue;
                float stdDeduction = [[dicTemp objectForKey:@"StandardDeduction"]floatValue]*incrementValue;
                
                float budget=[[dicTemp objectForKey:@"Budget"]floatValue]*100000;
                
                emailBody = [emailBody stringByAppendingString:@"<h2>Estate Planning</h2><br/>"];
                
                
                 emailBody = [emailBody stringByAppendingFormat:@"Funeral Expense : %.0f<br/>",funeral];
                 emailBody = [emailBody stringByAppendingFormat:@"Judicial Expense : %.0f<br/>",judicial];
                 
                emailBody = [emailBody stringByAppendingFormat:@"Insolvency Claim : %.0f<br/>",insolvency];
                emailBody = [emailBody stringByAppendingFormat:@"Unpaid Mortgage : %.0f<br/>",mortgage];
                 emailBody = [emailBody stringByAppendingFormat:@"Medical Expense : %.0f<br/>",medicalExp];
                emailBody = [emailBody stringByAppendingFormat:@"Estate Claims : %.0f<br/>",estateClaims];
                emailBody = [emailBody stringByAppendingFormat:@"Retirement Benefit : %.0f<br/>",retirement];
                emailBody = [emailBody stringByAppendingFormat:@"Spouse Interest to Estate : %.0f<br/>",spouse];
                emailBody = [emailBody stringByAppendingFormat:@"Standard Deduction : %.0f<br/>",stdDeduction];
            
                emailBody = [emailBody stringByAppendingFormat:@"Net Taxable Estate : %@<br/>",[dicTemp objectForKey:@"NetTaxableEstate"]];
                
                emailBody = [emailBody stringByAppendingFormat:@"Tax Rate : %@<br/>",[dicTemp objectForKey:@"TaxRate"]];
                
                emailBody = [emailBody stringByAppendingFormat:@"Notes : %@<br/>",[dicTemp objectForKey:@"Notes"]];
                emailBody = [emailBody stringByAppendingFormat:@"Budget : %.0f<br/>",budget];
            }
            
        }
    }
    
    
    
    [picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    
    picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [self presentViewController:picker animated:YES completion:NULL];
    [picker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
    // Notifies users about errors associated with the interface
    
    NSString *strMsg = @"";
    BOOL willSaveData = NO;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            strMsg = @"Cancelled";
            break;
        case MFMailComposeResultSaved:
            strMsg = @"Saved";
            willSaveData = YES;
            break;
        case MFMailComposeResultSent:
            strMsg = @"Sent";
            break;
        case MFMailComposeResultFailed:
            strMsg = @"Failed";
            willSaveData = YES;
            break;
            
        default:
        {
            strMsg = @"Sending Failed - Unknown Error :-(";
        }
            
            break;
    }
    
    if(willSaveData)
    {
        NSString *outbox = [Utility filePath:@"outbox.plist"];
        NSLog(@"documentsDirectory : %@",outbox);
        
        NSMutableDictionary *dicOutBox = [NSMutableDictionary dictionary];
        NSMutableArray *arrOutBox = [NSMutableArray array];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:outbox])
        {
            dicOutBox = [NSMutableDictionary dictionaryWithContentsOfFile:outbox];
            arrOutBox = [NSMutableArray arrayWithArray:[dicOutBox objectForKey:@"outbox"]];
        }
        

        [arrOutBox addObjectsFromArray:self.arrData];
        [dicOutBox setObject:arrOutBox forKey:@"outbox"];
        
        [dicOutBox writeToFile:outbox atomically:NO];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:strMsg
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
