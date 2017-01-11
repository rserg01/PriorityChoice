//
//  ModalActivationViewController.m
//  PriorityCh_test4
//
//  Created by Mateo on 7/16/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ModalActivationViewController.h"
#import "FNASession.h"

@interface ModalActivationViewController ()

@property (nonatomic, retain) NSMutableArray *arrErrors;

@end

@implementation ModalActivationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setArrErrors:[FNASession sharedSession].activationErrors];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[FNASession sharedSession].activationErrors count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NSDictionary *item = [_arrErrors objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setText:[item objectForKey:@"Error"]];
    [cell.textLabel setNumberOfLines:3];
	//[cell.imageView setImage:[UIImage imageNamed:[item objectForKey:@"image"]]];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 82;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tblView release];
    [_navButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTblView:nil];
    [self setNavButton:nil];
    [super viewDidUnload];
}
- (IBAction)closeModal:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
