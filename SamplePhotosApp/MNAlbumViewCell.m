//
//  AAPLRootListViewCell.m
//  SamplePhotosApp
//
//  Created by Magic Niu on 15/7/5.
//
//

#import "MNAlbumViewCell.h"

@implementation MNAlbumViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
