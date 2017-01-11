//
//  FinCalcCustomCell.h
//  FNA_20120319
//
//  Created by Manulife on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinCalcCustomCell : UITableViewCell

{
    UILabel *lblyear;
    UILabel *lblAge;
    UILabel *lblAcctValue;
    UILabel *lblDeathBen;
}

@property (retain, nonatomic) IBOutlet UILabel *lblYear;
@property (retain, nonatomic) IBOutlet UILabel *lblAge;
@property (retain, nonatomic) IBOutlet UILabel *lblAcctValue;
@property (retain, nonatomic) IBOutlet UILabel *lblDeathBen;



@end
