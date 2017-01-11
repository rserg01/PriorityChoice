//
//  ProductCell.h
//  PriorityCh_test3
//
//  Created by Manulife on 4/12/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell {
    
    IBOutlet UIImageView *imgProduct;
    IBOutlet UILabel *lblProductName;
    IBOutlet UILabel *lblProductDesc;
    
}

@property (retain, nonatomic) IBOutlet UIImageView *imgProduct;
@property (retain, nonatomic) IBOutlet UILabel *lblProductName;
@property (retain, nonatomic) IBOutlet UILabel *lblProductDesc;


@end
