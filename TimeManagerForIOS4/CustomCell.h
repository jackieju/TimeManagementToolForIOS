//
//  CustomCell.h
//  TimeManagerForIOS4
//
//  Created by juweihua on 12/17/12.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbTime;
@property (strong, nonatomic) IBOutlet UILabel *lbEvent;
@property (strong, nonatomic) IBOutlet UIImageView *ivImage;
@property (strong, nonatomic) IBOutlet UILabel *lbDuration;

@end
