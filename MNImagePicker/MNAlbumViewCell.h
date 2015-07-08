//
//  AAPLRootListViewCell.h
//  SamplePhotosApp
//
//  Created by Magic Niu on 15/7/5.
//
//

#import <UIKit/UIKit.h>

@interface MNAlbumViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumCountLabel;

@end
