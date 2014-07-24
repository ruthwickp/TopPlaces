//
//  RecentlyViewedFlickrPhotosTVC.m
//  TopPlaces
//
//  Created by Ruthwick Pathireddy on 7/24/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "RecentlyViewedFlickrPhotosTVC.h"

@interface RecentlyViewedFlickrPhotosTVC ()

@end

@implementation RecentlyViewedFlickrPhotosTVC

#define MAX_RECENT_PHOTOS 20

// Displays recently viewed photos
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self displayRecentlyViewedPhotos];
}

// Displays a maximum of the top 20 recently viewed photos
- (void)displayRecentlyViewedPhotos
{
    NSArray *recentPhotos = [[[NSUserDefaults standardUserDefaults] objectForKey:@"RecentlyViewed"] mutableCopy];
    int numberOfRecentPhotos = [recentPhotos count] > MAX_RECENT_PHOTOS ? MAX_RECENT_PHOTOS : [recentPhotos count];
    self.photos = [recentPhotos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfRecentPhotos)]];
}


@end
