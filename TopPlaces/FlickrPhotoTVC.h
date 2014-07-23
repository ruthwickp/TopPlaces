//
//  FlickrPhotoTVC.h
//  TopPlaces
//
//  Created by Ruthwick Pathireddy on 7/22/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <UIKit/UIKit.h>

// Displays a list of photos in a table view
@interface FlickrPhotoTVC : UITableViewController

// Dictionaries containing information about photos
@property (nonatomic, strong) NSArray *photos;

@end
