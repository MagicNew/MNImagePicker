/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A collection view cell that displays a thumbnail image.
  
 */

#import "MNGridViewCell.h"

@interface MNGridViewCell ()
@property (strong) IBOutlet UIImageView *imageView;
@end

@implementation MNGridViewCell

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (IBAction)imageCheckButtonPressed:(id)sender {
    UIButton *imageCheckButton = (UIButton *)sender;
    imageCheckButton.selected = !imageCheckButton.selected;
}
@end
