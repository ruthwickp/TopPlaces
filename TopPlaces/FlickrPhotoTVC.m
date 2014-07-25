//
//  FlickrPhotoTVC.m
//  TopPlaces
//
//  Created by Ruthwick Pathireddy on 7/22/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotoTVC ()

@end

@implementation FlickrPhotoTVC

// Updates tableview when photos are set
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *title = [self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *description = [self.photos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    // Configures title and description accordingly
    title = ![title isEqualToString:@""] ? title : description;
    if ([title isEqualToString:@""] && [description isEqualToString:@""]) {
        title = @"Unknown";
        description = @"Unknown";
    }
    
    // Sets title and descriptions of cell
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Displays row at index on detail view controller on ipad
    UIViewController *vc = self.splitViewController.viewControllers[1];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).viewControllers[0];
    }
    if ([vc isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:(ImageViewController *)vc toDisplayPhoto:self.photos[indexPath.row]];
    }
}

// Helper method to display and set info for image view controller
- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
    // Adds photo to recentlyViewed
    [self addPhotoToRecentlyViewed:photo];
    NSString *title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    ivc.title = [title isEqualToString:@""] ? @"Unknown" : title ;
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
}

// Adds photo to NSUserDefaults storage
- (void)addPhotoToRecentlyViewed:(NSDictionary *)photo
{
    // Gets current list of recently viewed photos
    NSMutableArray *recentlyViewed = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RecentlyViewed"] mutableCopy];
    if ([recentlyViewed containsObject:photo]) {
        [recentlyViewed removeObject:photo];
    }
    // Adds the photo to storage
    [recentlyViewed insertObject:photo atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:recentlyViewed forKey:@"RecentlyViewed"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            NSDictionary *photo = self.photos[indexPath.row];
            // Makes sure segue is valid
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:photo];
                }
            }
        }
    }
    
}


@end
