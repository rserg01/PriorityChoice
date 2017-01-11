    //
//  FNAOutBoxViewController.m
//  FNA
//
//  Created by Justin Limjap on 3/30/12.
//  Copyright 2012 iGen Dev Center, Inc. All rights reserved.
//

#import "FNAOutBoxViewController.h"
#import "Utility.h"
#import "FNAEmailSenderViewController.h"
#import "FNASession.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "AESCrypt.h"

@interface FNAOutBoxViewController()

@property(nonatomic, assign) NSString *clientEmail;
@property(nonatomic, assign) NSString *agentEmail;

- (void)getAgentEmailAdd;
- (void)getClientEmailAdd;
- (NSString *)getClientName: (NSString *)clientId;

@end


@implementation FNAOutBoxViewController
@synthesize imgTemplate;

@synthesize arrData, tblView, clientEmail, agentEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Send Data" style:UIBarButtonItemStylePlain target:self action:@selector(sendData:)];
    [self.navigationItem setRightBarButtonItem:send];
    [send release];
}

- (IBAction) sendData:(id)sender
{    
    NSMutableArray *arr = [NSMutableArray array];
    
    for(int i = 0; i < [arrData count]; i++)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[arrData objectAtIndex:i]];
        if([[dic objectForKey:@"check"] isEqualToString:@"1"])
        {
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"tableName"],@"tableName",[dic objectForKey:@"dataSetName"],@"dataSetName",[dic objectForKey:@"clientID"],@"clientID", nil]];
        }
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //- very important step if you want feedbacks on what the user did with your email sheet
    
    [picker setSubject:@"Priority Choice"];
    
    [self getAgentEmailAdd];
    [self getClientEmailAdd];
    
    NSArray *arrTo = [NSArray arrayWithObjects:clientEmail,agentEmail, nil];
    [picker setToRecipients:arrTo];
    
    // Fill out the email body text        
    NSString *emailBody = @"";
    
    for(int j = 0; j < [arr count]; j++)
    {
        NSDictionary *dicData = [NSDictionary dictionaryWithDictionary:[arr objectAtIndex:j]];
        
        NSArray *arrFieldnames = [NSArray arrayWithArray:[Utility getColumnNamesForTable:[dicData objectForKey:@"tableName"]]];
        NSDictionary *dicResult = [NSDictionary dictionaryWithDictionary:[Utility getDataSetFromFieldNames:arrFieldnames withTable:[dicData objectForKey:@"tableName"] withClientID:[dicData objectForKey:@"clientID"] withDataSetName:[dicData objectForKey:@"dataSetName"]]];
        NSArray *tempResult = [NSArray arrayWithArray:[dicResult objectForKey:@"result"]];
        NSDictionary *dicTemp = [NSDictionary dictionaryWithDictionary:[tempResult objectAtIndex:j]];
        
        //EducFunding
        if ([[dicTemp objectForKey:@"dataset"] isEqualToString:@"educDataSet"])
        {
            float allocatedPersonalAsset = [[dicTemp objectForKey:@"AllocatedPersonalAsset"]floatValue]*50000;
            float budget = [[dicTemp objectForKey:@"EducBudget"]floatValue]*5000;
            float presentAnnUnivCost = [[dicTemp objectForKey:@"PresentAnnualCost"]floatValue]*500;
            
            emailBody = [emailBody stringByAppendingString:@"<h2>Education Funding</h2><br/>"];
            emailBody = [emailBody stringByAppendingFormat:@"Present Annual Cost of University : %@<br/>",[NSString stringWithFormat:@"%.0f", presentAnnUnivCost]];
            emailBody = [emailBody stringByAppendingFormat:@"Year of Entry : %@<br/>",[dicTemp objectForKey:@"YearOfEntry"]];
            emailBody = [emailBody stringByAppendingFormat:@"Allocated Personal Asset : %.0f<br/>",allocatedPersonalAsset];
            emailBody = [emailBody stringByAppendingFormat:@"Education Savings Goal : %@<br/>",[dicTemp objectForKey:@"EducSavingsGoal"]];
            emailBody = [emailBody stringByAppendingFormat:@"Insurance Importance : %@<br/>",[dicTemp objectForKey:@"InsImportance"]];
            emailBody = [emailBody stringByAppendingFormat:@"Budget : %.0f<br/>",budget];
        }
        
        //Income Protection
        if ([[dicTemp objectForKey:@"dataset"] isEqualToString:@"incomeDataSet"])
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
        if ([[dicTemp objectForKey:@"dataset"] isEqualToString:@"retirementDataSet"])
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
        if ([[dicTemp objectForKey:@"dataset"] isEqualToString:@"investmentDataSet"])
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
        if ([[dicTemp objectForKey:@"dataset"] isEqualToString:@"healthDataSet"])
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
        if ([[dicTemp objectForKey:@"dataset"] isEqualToString:@"estateDataSet"])
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
        
        /*for (NSString *str in [dicTemp allKeys]) 
         {
         Log(@"str = %@", str);
         emailBody = [emailBody stringByAppendingFormat:@"%@ : %@<br>",str,[dicTemp objectForKey:str]];
         
         }*/
    }

    
    /*for(int i = 0; i < [arr count]; i++)
    {
        NSDictionary *dicData = [NSDictionary dictionaryWithDictionary:[arr objectAtIndex:i]];
        
        NSArray *arrFieldnames = [NSArray arrayWithArray:[Utility getColumnNamesForTable:[dicData objectForKey:@"tableName"]]];
        NSDictionary *dicResult = [NSDictionary dictionaryWithDictionary:[Utility getDataSetFromFieldNames:arrFieldnames withTable:[dicData objectForKey:@"tableName"] withClientID:[dicData objectForKey:@"clientID"] withDataSetName:[dicData objectForKey:@"dataSetName"]]];
        NSArray *tempResult = [NSArray arrayWithArray:[dicResult objectForKey:@"result"]];
        
        for(int j = 0; j < [tempResult count]; j++)
        {
            NSDictionary *dicTemp = [NSDictionary dictionaryWithDictionary:[tempResult objectAtIndex:j]];
            NSLog(@"dicTemp : %@",dicTemp);
            for (NSString *str in [dicTemp allKeys]) 
            {
                emailBody = [emailBody stringByAppendingFormat:@"%@ : %@<br>",str,[dicTemp objectForKey:str]];
            }
        }
    }*/
    
    
    
    [picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    
    picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.

    [self presentViewController:picker animated:YES completion:NULL];
    [picker release];
}

- (void)getClientEmailAdd
{
	sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""]) 
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"Email "
								   @"FROM tProfile_Personal WHERE _Id=%@", profileId];
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
				{
					clientEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
				}
			}
            
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);	
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
			
		}
		else 
		{
			//[FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i", [[Utility getUserDefaultsValue:@"tProfile_Personal_Id"] intValue] + 1];
		}
        
	}
	else 
	{
		[Utility showAlerViewWithTitle:@"Database Error" 
						   withMessage:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]] 
				 withCancelButtonTitle:@"Ok" 
				  withOtherButtonTitle:nil 
						   withSpinner:NO 
						  withDelegate:nil];
	}
    
}

- (void)getAgentEmailAdd
{
	sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *agentCode = [FNASession sharedSession].agentCode;
		if (![agentCode isEqualToString:@""]) 
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"Email "
								   @"FROM tAgentInfo WHERE AgentCode=\"%@\"", agentCode];
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
				{
					agentEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
				}
			}

			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);	
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
			
		}
		else 
		{
			//[FNASession sharedSession].profileId = [NSString stringWithFormat:@"%i", [[Utility getUserDefaultsValue:@"tProfile_Personal_Id"] intValue] + 1];
		}
        
	}
	else 
	{
		[Utility showAlerViewWithTitle:@"Database Error" 
						   withMessage:[NSString stringWithFormat:@"Failed to open database '%@'", [SQLiteManager databaseName]] 
				 withCancelButtonTitle:@"Ok" 
				  withOtherButtonTitle:nil 
						   withSpinner:NO 
						  withDelegate:nil];
	}
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
            break;
        case MFMailComposeResultSent:
            strMsg = @"Sent";            
            willSaveData = YES;
            break;
        case MFMailComposeResultFailed:
            strMsg = @"Failed";
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
        
        for(int i = 0; i < [arrData count]; i++)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[arrData objectAtIndex:i]];
            if([[dic objectForKey:@"check"] isEqualToString:@"1"])
            {
                [arrData removeObjectAtIndex:i];
                i--;
            }
        }
        
        
        [arrOutBox addObjectsFromArray:self.arrData];
        [dicOutBox setObject:arrOutBox forKey:@"outbox"];
        
        [dicOutBox writeToFile:outbox atomically:NO];
    } 
    
    [self.tblView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *outbox = [Utility filePath:@"outbox.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outbox])
    {
        NSDictionary *dicOutBox = [NSMutableDictionary dictionaryWithContentsOfFile:outbox];
        //arrData = [NSMutableArray arrayWithArray:[dicOutBox objectForKey:@"outbox"]];
        [arrData removeAllObjects];
        [arrData setArray:[NSArray arrayWithArray:[dicOutBox objectForKey:@"outbox"]]];
        NSLog(@"arrDataOutbox : %@",arrData);
        for(int i = 0; i < [arrData count]; i++)
        {
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[arrData objectAtIndex:i]];
            [dic setObject:@"0" forKey:@"check"];
            
            [arrData replaceObjectAtIndex:i withObject:dic];
        }
    }
    [tblView reloadData];
    
    NSString *strChannel = [Utility getUserDefaultsValue:@"CHANNEL"];
    
    UIImage *mcblTemplate = [UIImage imageNamed: @"LifeCompass5_templateWithMcbl.png"];
    
    //change images per sales channel
    if ([strChannel isEqualToString:@"MCBL"])
    {
        [imgTemplate setImage:mcblTemplate];
    }
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSLog(@"arrData : %@",arrData);
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[arrData objectAtIndex:indexPath.row]];
    
    //get client name from clientId from array
    NSString *clientName = [self getClientName:[dic objectForKey:@"clientID"]];
    cell.textLabel.text = [NSString stringWithFormat:@"Client Name : %@",clientName];
    
    //set correct label for tableName
    NSLog(@"tablename = %@", [dic objectForKey:@"tableName"]);
    NSString *strTableName = @"";
    if ([[dic objectForKey:@"tableName"] isEqualToString:@"tEducFunding"])
    {
        strTableName = @"Education Funding";
    }
    if ([[dic objectForKey:@"tableName"] isEqualToString:@"tEstatePlanning"])
    {
        strTableName = @"Estate Planning";
    }
    if ([[dic objectForKey:@"tableName"] isEqualToString:@"tFundAccumulation"])
    {
        strTableName = @"Fund Accumulation & Investments";
    }
    if ([[dic objectForKey:@"tableName"] isEqualToString:@"tImpairedHealth"])
    {
        strTableName = @"Impaired Health";
    }
    if ([[dic objectForKey:@"tableName"] isEqualToString:@"tIncomeProtection"])
    {
        strTableName = @"Income Protection";
    }
    if ([[dic objectForKey:@"tableName"] isEqualToString:@"tRetirementPlanning"])
    {
        strTableName = @"Retirement Planning";
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Table Name : %@",strTableName];
    
    NSString *check = [dic objectForKey:@"check"];
    if([check isEqualToString:@"0"])
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (NSString *)getClientName: (NSString *)clientId
{
    NSString *strClientName = @"";
    
    if(![[FNASession sharedSession].profileId isEqualToString:@""])
	{
		sqlite3 *database = nil;
		if ([SQLiteManager openDatabase:&database]) //open database
		{
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT _Id, "
                                   @"FirstName, MiddleName, LastName, "
								   @"AddressHome1, AddressHome2, AddressHome3 "
								   @"FROM tProfile_Personal WHERE _Id=%@", [FNASession sharedSession].profileId ];
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK) 
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW) 
				{
                    NSString *strFirst = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)] password:[FNASession sharedSession].agentCode];
                    NSString *strMiddle = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)] password:[FNASession sharedSession].agentCode];
                    NSString *strLast = [AESCrypt decrypt:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)] password:[FNASession sharedSession].agentCode];
                    strClientName = [NSString stringWithFormat:@"%@ %@ %@",strFirst, strMiddle, strLast];
				}
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);	
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
		}		
	}
    
    
    return strClientName;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[arrData objectAtIndex:indexPath.row]];
    NSString *strCheck = [dic objectForKey:@"check"];
    if([strCheck isEqualToString:@"0"])
    {
        strCheck = @"1";
    }
    else if([strCheck isEqualToString:@"1"])
    {
        strCheck = @"0";
    }
    
    [dic setObject:strCheck forKey:@"check"];
    
    [arrData replaceObjectAtIndex:indexPath.row withObject:dic];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setImgTemplate:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [imgTemplate release];
    [super dealloc];
}


@end

