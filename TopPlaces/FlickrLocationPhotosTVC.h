//
//  FlickrLocationPhotosTVC.h
//  TopPlaces
//
//  Created by Ruthwick Pathireddy on 7/23/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "FlickrPhotoTVC.h"

// Class displays tableview of top Flickr photos from a
// specific location
@interface FlickrLocationPhotosTVC : FlickrPhotoTVC

// Location of photos (place_id)
@property (nonatomic, strong) id location;
@end
