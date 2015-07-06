/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The view controller displaying the root list of the app.
  
 */

#import "MNImagePickerViewController.h"

#import "MNAssetGridViewController.h"

#import "MNAlbumViewCell.h"

@import Photos;


@interface MNImagePickerViewController () <PHPhotoLibraryChangeObserver>
@property (strong) NSArray *collectionsFetchResults;
@property (strong) NSArray *collectionsLocalizedTitles;
@end

@implementation MNImagePickerViewController

static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";
static NSString * const CollectionSegue = @"showCollection";

- (void)awakeFromNib
{
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHFetchResult *favoriteAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    PHFetchResult *recentAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    self.collectionsFetchResults = @[userAlbums, favoriteAlbums, recentAlbums, topLevelUserCollections];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - UIViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:CollectionSegue]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            if (assetsFetchResult.count == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相册为空哦" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alertView show];
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CollectionSegue]) {
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];

            MNAssetGridViewController *assetGridViewController = segue.destinationViewController;
            assetGridViewController.assetsFetchResults = assetsFetchResult;
            assetGridViewController.assetCollection = assetCollection;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.collectionsFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PHFetchResult *fetchResult = self.collectionsFetchResults[section];
    return fetchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNAlbumViewCell *cell = (MNAlbumViewCell *)[tableView dequeueReusableCellWithIdentifier:CollectionCellReuseIdentifier forIndexPath:indexPath];
    PHFetchResult *fetchResult = self.collectionsFetchResults[indexPath.section];
    PHCollection *collection = fetchResult[indexPath.row];
    cell.albumNameLabel.text = collection.localizedTitle;
    
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        cell.albumCountLabel.text = [NSString stringWithFormat:@"%@", @(assetsFetchResult.count)];
        
        if (assetsFetchResult.count > 0) {
            PHAsset *asset = [assetsFetchResult lastObject];
            PHImageManager *imageManager = [[PHImageManager alloc] init];
            [imageManager requestImageForAsset:asset
                                    targetSize:CGSizeMake(100, 100)
                                   contentMode:PHImageContentModeAspectFill
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
                                     cell.thumbImageView.image = result;
                                 }];
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .0f;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *updatedCollectionsFetchResults = nil;
        
        for (PHFetchResult *collectionsFetchResult in self.collectionsFetchResults) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            if (changeDetails) {
                if (!updatedCollectionsFetchResults) {
                    updatedCollectionsFetchResults = [self.collectionsFetchResults mutableCopy];
                }
                [updatedCollectionsFetchResults replaceObjectAtIndex:[self.collectionsFetchResults indexOfObject:collectionsFetchResult] withObject:[changeDetails fetchResultAfterChanges]];
            }
        }
        
        if (updatedCollectionsFetchResults) {
            self.collectionsFetchResults = updatedCollectionsFetchResults;
            [self.tableView reloadData];
        }
        
    });
}

#pragma mark - Actions

- (IBAction)handleAddButtonItem:(id)sender
{
    // Prompt user from new album title.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Album", @"") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:NULL]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Album Name", @"");
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Create", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSString *title = textField.text;

        // Create new album.
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error creating album: %@", error);
            }
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end
