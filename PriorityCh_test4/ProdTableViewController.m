//
//  ProdTableViewController.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/12/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ProdTableViewController.h"
#import "ProductCell.h"
#import "BrochureViewController.h"
#import "FNASession.h"
#import "FnaConstants.h"
#import "Utility.h"

@interface ProdTableViewController ()

@end

@implementation ProdTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    
    
    listOfProducts = [[NSMutableArray alloc] init];
    
    //affluenceGold, affluenceMaxGold, Affluence builder, wealth premier
    
    if ([[Utility getUserDefaultsValue:@"CHANNEL"] isEqualToString:@"MBCL"]) {
        
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
       
    } else {
        
        
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_AffluenceGold_trans", @"image",
                                   kAffluenceGold_WriteUp, @"productDesc",
                                   kImage_Brochure_AffluenceGold, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_AffluenceMaxGold_trans", @"image",
                                   kAffluenceMaxGold_WriteUp, @"productDesc",
                                   kImage_Brochure_AffluenceMaxGold, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_AffluenceBuilder2014_trans", @"image",
                                   kAffluenceBuilder_WriteUp, @"productDesc",
                                   kImage_Brochure_AffluenceBuilder, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_Horizons_trans", @"image",
                                   kHorizons_WriteUp, @"productDesc",
                                   kImage_Brochure_Horizons, @"brochureFileName", nil]];
        [listOfProducts addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"edited_AfflunceIncome_trans", @"image",
                                   kAffluenceIncome_WriteUp, @"productDesc",
                                   kImage_Brochure_AffluenceIncome, @"brochureFileName", nil]];
    }
    
}

- (void) initNavigationBar
{
    [self.navigationController.navigationBar.topItem setTitle:@"Investment Products"];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     static NSString *CellIdentifier = @"Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     // Configure the cell...
     
     return cell;*/
    
    /*  Method 1
     
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     cell.textLabel.text = [listOfMovies objectAtIndex:indexPath.row];
     cell.detailTextLabel.text = [listOfMoviesDescription objectAtIndex:indexPath.row];
     
     return cell;*/
    
    
    // Method 2
    
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
