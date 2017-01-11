//
//  ProductCell.m
//  PriorityCh_test3
//
//  Created by Manulife on 4/12/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

@synthesize imgProduct = _imgProduct;
@synthesize lblProductDesc = _lblProductDesc;
@synthesize lblProductName = _lblProductName;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imgProduct release];
    [_lblProductName release];
    [_lblProductDesc release];
    [imgProduct release];
    [lblProductName release];
    [lblProductDesc release];
    [super dealloc];
}
@end
