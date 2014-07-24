//
//  FlickrLocationPhotosTVC.m
//  TopPlaces
//
//  Created by Ruthwick Pathireddy on 7/23/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "FlickrLocationPhotosTVC.h"
#import "FlickrFetcher.h"

@interface FlickrLocationPhotosTVC ()

@end

@implementation FlickrLocationPhotosTVC

#define MAX_PHOTOS 50

// If the location becomes set, updates photos for that corresponding location
- (void)setLocation:(id)location
{
    _location = location;
    [self updatePhotosInLocation];
}

// When view loads, updates photos in tableview
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.bounds.size.height)
                            animated:YES];
    [self updatePhotosInLocation];
}

// Updates photos from a location
- (IBAction)updatePhotosInLocation
{
    // If a location has been set, gets photos from it
    if (self.location) {
        [self.refreshControl beginRefreshing];
        dispatch_queue_t locationPhotosQ = dispatch_queue_create("Location Photos", NULL);
        dispatch_async(locationPhotosQ, ^{
            NSURL *urlPhotoLocation = [FlickrFetcher URLforPhotosInPlace:self.location maxResults:MAX_PHOTOS];
            
            NSData *jsonResults = [NSData dataWithContentsOfURL:urlPhotoLocation];
            NSDictionary *locationPhotoResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                 options:0
                                                                                   error:NULL];
            // Sets the photos from the location on the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                self.photos = [locationPhotoResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
            });
        });
    }
}

@end
