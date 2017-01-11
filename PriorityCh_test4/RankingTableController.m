//
//  RankingTableController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/17/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "RankingTableController.h"
#import "FNAPriorityChoiceCustomCell.h"
#import "Utility.h"
#import "SQLiteManager.h"
#import <sqlite3.h>
#import "FNAEmailSenderViewController.h"
#import "FNASession.h"
#import "MainSwitchViewController.h"
#import "FnaConstants.h"
#import "EmailSender.h"
#import "GetPersonalProfile.h"

@interface RankingTableController ()
@property(nonatomic, retain) NSMutableArray *arrChoices;
@end

@implementation RankingTableController

#pragma mark -
#pragma mark View lifecycle

@synthesize arrChoices;
@synthesize tblView;
@synthesize priorityTap;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Priority Choice";
	arrChoices = [[NSMutableArray alloc] init];
    
    [arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           kImageRanking_Income, @"cellBackgroundImage",
                           kSelectedController_Income, @"selectedController", nil]];
	[arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           kImageRanking_Education, @"cellBackgroundImage",
                           kSelectedController_Education, @"selectedController", nil]];
	[arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           kImageRanking_Retirement, @"cellBackgroundImage",
                           kSelectedController_Retirement, @"selectedController", nil]];
	[arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           kImageRanking_Investment, @"cellBackgroundImage",
                           kSelectedController_Investment, @"selectedController", nil]];
	[arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           kImageRanking_Health, @"cellBackgroundImage",
                           kSelectedController_Health, @"selectedController", nil]];
	[arrChoices addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           kImageRanking_Estate, @"cellBackgroundImage",
                           kSelectedController_Estate, @"selectedController", nil]];
    
	self.navigationItem.title = @"Rankings";
	self.navigationController.navigationBar.translucent = YES;
    
    UIAlertView *alertView = [Utility showAlerViewWithTitle:@"Loading Information"
												withMessage:@""
									  withCancelButtonTitle:nil
									   withOtherButtonTitle:nil
												withSpinner:YES
											   withDelegate:nil];
    
    [self loadPriorityRankInformation:alertView];
    
    if ([[FNASession sharedSession].profileId length] == 0) {
        
        [self sendErrorMessage:kNoProfileActive];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addTopButtons];
}

- (void) addTopButtons
{
    
    UIBarButtonItem *setProfile = [[UIBarButtonItem alloc] initWithTitle:@"Set Active Profile" style:UIBarButtonItemStylePlain target:self action:@selector(setActiveProfile)];
    
    //UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Send to Email" style:UIBarButtonItemStylePlain target:self action:@selector(sendData:)];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    UIBarButtonItem *newProfile = [[UIBarButtonItem alloc] initWithTitle:@"New Profile" style:UIBarButtonItemStylePlain target:self action:@selector(newProfile)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[self editButtonItem], setProfile, newProfile, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:homeButton, nil];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void) setActiveProfile
{
    [self performSegueWithIdentifier:@"toProfilesModal" sender:self];
}

- (void) newProfile
{
    [self performSegueWithIdentifier:@"toRankingNewProfile" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toProfilesModal"]) {
        [[segue destinationViewController] setRankingDelegate:self];
        ProfilesTableViewController *modal = [[[ProfilesTableViewController alloc]init]autorelease];
        modal.rankingDelegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toRankingNewProfile"]) {
        [[segue destinationViewController] setProfile_delegate:self];
        ModalProfileViewController *modal = [[[ModalProfileViewController alloc]init]autorelease];
        modal.profile_delegate = self;
    }
}

-(void)finishedDoingMyThing:(NSString *)labelString
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([labelString isEqualToString:@"success"]) {
        
        [GetPersonalProfile GetPersonalProfile:[FNASession sharedSession].profileId];

        UIAlertView *alertView = [Utility showAlerViewWithTitle:@"Loading Information"
                                                    withMessage:@""
                                          withCancelButtonTitle:nil
                                           withOtherButtonTitle:nil
                                                    withSpinner:YES
                                                   withDelegate:nil];
        
        [self loadPriorityRankInformation:alertView];
    }
}

- (void) sendData:(id)sender
{
    NSLog(@"%@", [FNASession sharedSession].profileId);
    
    if ([[FNASession sharedSession].profileId length] == 0) {
        
        [self sendErrorMessage:kNoProfileActive];
    }
    else {
       
        UIViewController *viewController = [EmailSender sendEmailArray:[FNASession sharedSession].profileId tableName:kTableName_PriorityRank dataSet:kDataset_PriorityRank];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
   
}

- (void) gotoHome {
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];

}

- (void) sendErrorMessage: (NSString *)errorMessage
{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Priority Choice"
                          message:errorMessage
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release]; // if you are not using ARC
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[self navigationItem] setLeftBarButtonItem:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark Class Custom Methods

- (void) loadPriorityRankInformation:(UIAlertView*)alertView
{
	sqlite3 *database = nil;
	if ([SQLiteManager openDatabase:&database]) //open database
	{
		NSString *profileId = [FNASession sharedSession].profileId;
		if (![profileId isEqualToString:@""])
		{
			BOOL checkIfExist = NO;
            NSString *income	= @"0";
			NSString *educ		= @"0";
			NSString *retire	= @"0";
			NSString *fund		= @"0";
			NSString *health	= @"0";
			NSString *estate	= @"0";
			
			NSString *sqlSelect = [NSString stringWithFormat:@"SELECT "
								   @"IncomeProt,EducFund,Retirement,"
								   "Investment,Health,EstatePlan "
								   @"FROM tPriorityRank WHERE _Id=%@", profileId];
			
			sqlite3_stmt *sqliteStatement;
			
			if(sqlite3_prepare_v2(database, [sqlSelect UTF8String], -1, &sqliteStatement, NULL) == SQLITE_OK)
			{
				while(sqlite3_step(sqliteStatement) == SQLITE_ROW)
				{
					checkIfExist = YES;
					educ = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 1)];
					income = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 0)];
					retire = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 2)];
					fund = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 3)];
					health = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 4)];
					estate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqliteStatement, 5)];

				}
			}
			else
			{
				//NSLog(@"failed to execute statement: %@", sqlQuery);
				NSLog(@"failed to execute statement : %@",sqlSelect);
			}
			
			// Release the compiled statement from memory
			sqlite3_finalize(sqliteStatement);
			
			[SQLiteManager closeDatabase:&database]; //make sure to close the database
			
			if(checkIfExist)
			{
				NSMutableArray *arrTemp = [NSMutableArray arrayWithArray:arrChoices];
				
				for(int i = 0; i < [arrTemp count]; i++)
				{
					NSDictionary *dicChoices = [NSDictionary dictionaryWithDictionary:[arrTemp objectAtIndex:i]];
					int newIndex;
					NSString *strTitle = [dicChoices objectForKey:@"selectedController"];
					
                    if ([strTitle isEqualToString:kSelectedController_Income])
					{
						newIndex = [income intValue];
					}
					else if([strTitle isEqualToString:kSelectedController_Education])
					{
						newIndex = [educ intValue];
					}
					else if([strTitle isEqualToString:kSelectedController_Retirement])
					{
						newIndex = [retire intValue];
					}
					else if([strTitle isEqualToString:kSelectedController_Investment])
					{
						newIndex = [fund intValue];
					}
					else if([strTitle isEqualToString:kSelectedController_Health])
					{
						newIndex = [health intValue];
					}
                    else if ([strTitle isEqualToString:kSelectedController_Estate])
                    {
						newIndex = [estate intValue];
					}
                    else{
                        
                        newIndex = [income intValue];
                    }
					
					[arrChoices replaceObjectAtIndex:newIndex withObject:dicChoices];
				}
				
                [tblView reloadData];
                [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
			}
			else
			{
				[self savePriorityRank:alertView];
			}
            
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

- (void) savePriorityRank:(UIAlertView*)alertView
{
	NSString *educ		= @"0";
	NSString *income	= @"0";
	NSString *retire	= @"0";
	NSString *fund		= @"0";
	NSString *health	= @"0";
	NSString *estate	= @"0";
	
	for(int i = 0; i < [arrChoices count];i++)
	{
		NSDictionary *dicChoices = [NSDictionary dictionaryWithDictionary:[arrChoices objectAtIndex:i]];
		NSString *strTitle = [dicChoices objectForKey:@"selectedController"];
        NSLog(@"%@", strTitle);
		if ([strTitle isEqualToString:kSelectedController_Income])
		{
			income = [NSString stringWithFormat:@"%i",i];
		}
		else if([strTitle isEqualToString:kSelectedController_Education])
		{
			educ = [NSString stringWithFormat:@"%i",i];
		}
		else if([strTitle isEqualToString:kSelectedController_Retirement])
		{
			retire = [NSString stringWithFormat:@"%i",i];
		}
		else if([strTitle isEqualToString:kSelectedController_Investment])
		{
			fund = [NSString stringWithFormat:@"%i",i];
		}
		else if([strTitle isEqualToString:kSelectedController_Health])
		{
			health = [NSString stringWithFormat:@"%i",i];
		}
		else if([strTitle isEqualToString:kSelectedController_Estate])
		{
			estate = [NSString stringWithFormat:@"%i",i];
		}
	}
    
    if ([priorityTap isEqual:nil]) {
        priorityTap = @"";
    }
    
    NSLog(@"priorityTap = %@", priorityTap);
	
    if ([[FNASession sharedSession].profileId length] > 0) {
        NSString *profileId = [FNASession sharedSession].profileId;
        NSString *sqlInsert = [NSString stringWithFormat:@"REPLACE INTO tPriorityRank ("
                               @"_Id, ClientId,"
                               @"EducFund, IncomeProt, Retirement,"
                               @"Investment, Health, EstatePlan, McblPriority "
                               @") VALUES (%@,%@, %@,%@,%@ ,%@,%@,%@, %@ )",
                               profileId,
                               profileId,
                               educ,
                               income,
                               retire,
                               fund,
                               health,
                               estate,
                               priorityTap];
        
        NSError *error = nil;
        NSLog(@"sqlInsert: %@", sqlInsert);
        [SQLiteManager sqliteExec:sqlInsert error:&error];
        [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
        
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else
        {
            NSLog(@"Pririoty Rank information successfully saved!");
        }
        
    }
    
    
}

#pragma mark -
#pragma mark Table view data source

- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated
{
    [tblView setEditing:editing
               animated:animated];
	[super setEditing:editing
             animated:animated];
	
	if(!editing)
	{
		NSLog(@"reload data");
		UIAlertView *alertView = [Utility showAlerViewWithTitle:@"Saving Information"
													withMessage:@""
										  withCancelButtonTitle:nil
										   withOtherButtonTitle:nil
													withSpinner:YES
												   withDelegate:nil];
		
		
		[tblView reloadData];
		
		[self savePriorityRank:alertView];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrChoices count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    FNAPriorityChoiceCustomCell *cell = (FNAPriorityChoiceCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FNAPriorityChoiceCustomCell" owner:self options:nil];
	for (id _cell in nib)
	{
		if ([_cell isKindOfClass:[FNAPriorityChoiceCustomCell class]])
		{
			cell = (FNAPriorityChoiceCustomCell *)_cell;
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			break;
		}
	}
	
	NSDictionary *item = [arrChoices objectAtIndex:indexPath.row];
	//TODO: Set the cell background image here - [item objectForKey:@"cellBackgroundImage"]
	
	NSString *strRank = @"";
	switch (indexPath.row) {
		case 0:
			strRank = @"1st";
			break;
		case 1:
			strRank = @"2nd";
			break;
		case 2:
			strRank = @"3rd";
			break;
		case 3:
			strRank = @"4th";
			break;
		case 4:
			strRank = @"5th";
			break;
		case 5:
			strRank = @"6th";
			break;
		default:
			break;
	}
	[cell.lblRank setText:strRank];
	[cell.imgBackground setImage:[UIImage imageNamed:[item objectForKey:@"cellBackgroundImage"]]];
    
    cell.showsReorderControl = YES;
	
    return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 109;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	if (fromIndexPath.row != toIndexPath.row)
    {
		NSDictionary *item = [[arrChoices objectAtIndex:fromIndexPath.row] retain];
		[arrChoices removeObjectAtIndex:fromIndexPath.row];
		[arrChoices insertObject:item atIndex:toIndexPath.row];
		[item release];
	}
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicItem = [arrChoices objectAtIndex:indexPath.row];
    if([[dicItem objectForKey:@"selectedController"] isEqualToString:kSelectedController_Income])
    {
        
        [FNASession sharedSession].selectedController = kSelectedController_Income;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PriorityCalcStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PriorityCalcStoryboard"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
        
    }
    else if ([[dicItem objectForKey:@"selectedController"] isEqualToString:kSelectedController_Education])
    {
        [FNASession sharedSession].selectedController = kSelectedController_Education;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PriorityCalcStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PriorityCalcStoryboard"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else if([[dicItem objectForKey:@"selectedController"] isEqualToString:kSelectedController_Retirement])
    {
        [FNASession sharedSession].selectedController = kSelectedController_Retirement;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PriorityCalcStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PriorityCalcStoryboard"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else if([[dicItem objectForKey:@"selectedController"] isEqualToString:kSelectedController_Investment])
    {
        [FNASession sharedSession].selectedController = kSelectedController_Investment;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PriorityCalcStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PriorityCalcStoryboard"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];        }
    else if([[dicItem objectForKey:@"selectedController"] isEqualToString:kSelectedController_Health])
    {
        [FNASession sharedSession].selectedController = kSelectedController_Health;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PriorityCalcStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PriorityCalcStoryboard"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else if([[dicItem objectForKey:@"selectedController"] isEqualToString:kSelectedController_Estate])
    {
        [FNASession sharedSession].selectedController = kSelectedController_Estate;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PriorityCalcStoryboard" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PriorityCalcStoryboard"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc animated:YES completion:NULL];
    }
}

@end
