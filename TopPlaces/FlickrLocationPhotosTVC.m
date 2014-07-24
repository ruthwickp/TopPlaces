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
    [self updatePhotosInLocation];
}

- (void)updatePhotosInLocation
{
    // If a location has been set, gets photos
    if (self.location) {
        NSURL *urlPhotoLocation = [FlickrFetcher URLforPhotosInPlace:self.location maxResults:MAX_PHOTOS];
        
        NSData *jsonResults = [NSData dataWithContentsOfURL:urlPhotoLocation];
        NSDictionary *locationPhotoResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                             options:0
                                                                               error:NULL];
        NSLog(@"%@", locationPhotoResults);
    }
}

@end
