//
//  FNAPriorityChoiceCustomCell.h
//  FNA
//
//  Created by Justin Limjap on 3/4/12.
//

#import <UIKit/UIKit.h>


@interface FNAPriorityChoiceCustomCell : UITableViewCell 
{
	UIImageView *imgBackground;
	UIImageView *imgIcon;
	UILabel *lblRank;
	UILabel *lblTitle;
	UILabel *lblSubTitle1;
	UILabel *lblSubTitle2;	
}

@property (nonatomic, retain) IBOutlet UIImageView *imgBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imgIcon;
@property (nonatomic, retain) IBOutlet UILabel *lblRank;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblSubTitle1;
@property (nonatomic, retain) IBOutlet UILabel *lblSubTitle2;

@end
