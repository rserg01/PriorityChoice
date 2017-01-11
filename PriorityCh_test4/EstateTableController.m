//
//  EstateTableController.m
//  PriorityCh_test4
//
//  Created by Manulife on 5/27/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "EstateTableController.h"
#import "ProductCell.h"
#import "BrochureViewController.h"
#import "FNASession.h"
#import "FnaConstants.h"
#import "Utility.h"

@interface EstateTableController ()

@end

@implementation EstateTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];

    listOfProducts = [[NSMutableArray alloc]init];
    
    if ([[Utility getUserDefaultsValue:@"CHANNEL"]isEqualToString:@"MBCL"]) {
        
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_MoneyMax15", @"image",
                                   kMcblMoneyMax15_WriteUp, @"productDesc",
                                   kImage_Brochure_McblMoneyMax15, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_MoneyMax20", @"image",
                                   kMcblMoneyMax20_WriteUp, @"productDesc",
                                   kImage_Brochure_McblMoneyMax20, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_MoneyMax65", @"image",
                                   kMcblMoneyMax65_WriteUp, @"productDesc",
                                   kImage_Brochure_McblMoneyMax65, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_Enrich2012", @"image",
                                   kMcblEnrich_WriteUp, @"productDesc",
                                   kImage_Brochure_McblEnrich, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_Enrich", @"image",
                                   kMcblEnrichMax_WriteUp, @"productDesc",
                                   kImage_Brochure_McblEnrichMax, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_PlatinumInvestElite_trans", @"image",
                                   kMcblPlatinumInvest_WriteUp, @"productDesc",
                                   kImage_Brochure_McblPlatinumInvest, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_LegacyProtect100", @"image",
                                   kMcblLegacy100_WriteUp, @"productDesc",
                                   kImage_Brochure_McblLegacy100, @"brochureFileName", nil]];
    }
    else {
        
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_Seasons100", @"image",
                                   kSeasons100_WriteUp, @"productDesc",
                                   kImage_Brochure_Seasons100, @"brochureFileName", nil]];
    }
}

- (void) initNavigationBar
{
    [self.navigationController.navigationBar.topItem setTitle:@"Estate Planning Products"];
    
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(gotoHome)];
    
    self.navigationItem.leftBarButtonItem = homeButton;
    [homeButton release];
    homeButton = nil;
}

- (void) gotoHome {
    
    [FNASession sharedSession].selectedMainMenu = @"Main";
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [listOfMovies count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listOfProducts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *item = [listOfProducts objectAtIndex:indexPath.row];
    
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.imgProduct.image = [UIImage imageNamed:[item objectForKey:@"image"]];
    cell.lblProductName.text = @"";
    [cell.lblProductDesc setText:[item objectForKey:@"productDesc"]];
    
    return cell;
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [listOfProducts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *item = [listOfProducts objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showBrochure" sender:[item objectForKey:@"brochureFileName"]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showBrochure"])
    {
        BrochureViewController *vc = (BrochureViewController *)[segue destinationViewController];
        vc.productName = sender;
    }
    
}

#pragma mark - Memory Management

- (void) viewDidUnload
{
    [listOfProducts release];
}

- (void) dealloc
{
    listOfProducts = nil;
    [super dealloc];
}

@end
