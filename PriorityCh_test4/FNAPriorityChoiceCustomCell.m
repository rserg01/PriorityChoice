    //
//  FNAPriorityChoiceCustomCell.m
//  FNA
//
//  Created by Justin Limjap on 3/4/12.
//

#import "FNAPriorityChoiceCustomCell.h"

@implementation FNAPriorityChoiceCustomCell

@synthesize imgBackground;
@synthesize imgIcon;
@synthesize lblRank;
@synthesize lblTitle;
@synthesize lblSubTitle1;
@synthesize lblSubTitle2;

- (void)dealloc 
{
	[self.imgBackground release];
	[self.imgIcon release];
	[self.lblRank release];
	[self.lblTitle release];
	[self.lblSubTitle1 release];
	[self.lblSubTitle2 release];
	
    [super dealloc];
}


@end
