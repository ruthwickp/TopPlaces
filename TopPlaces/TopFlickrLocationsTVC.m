//
//  TopFlickrLocationsTVC.m
//  TopPlaces
//
//  Created by Ruthwick Pathireddy on 7/23/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TopFlickrLocationsTVC.h"
#import "FlickrFetcher.h"
#import "FlickrLocationPhotosTVC.h"

@interface TopFlickrLocationsTVC ()
@property (nonatomic, strong) NSMutableDictionary *topLocations;
@property (nonatomic, strong) NSArray *countries;
@property (nonatomic, strong) NSMutableArray *photoDetails;
@end

@implementation TopFlickrLocationsTVC

#pragma mark - Property setters and getters

// Lazy instantiation
- (NSMutableDictionary *)topLocations
{
    if (!_topLocations) {
        _topLocations = [[NSMutableDictionary alloc] init];
    }
    return _topLocations;
}

// Lazy instantiation
- (NSArray *)countries
{
    if (!_countries) {
        _countries = [[NSArray alloc] init];
    }
    return _countries;
}

// Lazy instantiation
- (NSMutableArray *)photoDetails
{
    if (!_photoDetails) {
        _photoDetails = [[NSMutableArray alloc] init];
    }
    return _photoDetails;
}


#pragma mark - Flickr Top Places Data

// Updates tableView when view appears
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLocationSpots];
}

// Updates top photo locations through Flickr
- (void)updateLocationSpots
{
    // Retrieves top places for Flickr photos
    NSURL *locations = [FlickrFetcher URLforTopPlaces];
    NSData *jsonLocationResults = [NSData dataWithContentsOfURL:locations];
    NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:jsonLocationResults
                                                                    options:0
                                                                      error:NULL];
    NSArray *photoPlaces = [locationResults valueForKeyPath:FLICKR_RESULTS_PLACES];
    
    // Goes through all the photo locations and store them in a dictionary
    // according to country
    [photoPlaces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Retrieves country for the top places
        NSArray *locationDetails = [[obj valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
        NSString *country = [locationDetails lastObject];
        
        // Adds the object photo details to its corresponding country
        NSMutableArray *countryPhotoLocations = [self.topLocations objectForKey:country];
        if (countryPhotoLocations) {
            [countryPhotoLocations addObject:obj];
        }
        else {
            NSMutableArray *allLocation = [[NSMutableArray alloc] initWithObjects:obj, nil];
            [self.topLocations setValue:allLocation forKey:country];
        }
    }];
    [self sortCountriesAndCities];

    // Reloads tableview data when locations get updated
    [self.tableView reloadData];
}

// Stores the sorted countries and cities in the toplocation dictionary
- (void)sortCountriesAndCities
{
    // Sorts the country
    self.countries = [[self.topLocations allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSCaseInsensitiveSearch];
    }];
    // Sorts the cities whitin a country
    for (NSString *country in self.countries) {
        [self.photoDetails addObject:[[self.topLocations valueForKey:country] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *city1 = [[[obj1 valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] firstObject];
            NSString *city2 = [[[obj2 valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] firstObject];
            return [city1 compare:city2 options:NSCaseInsensitiveSearch];
        }]];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.topLocations count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photoDetails[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location Cell" forIndexPath:indexPath];
    // Gets location details for a particular photo
    NSDictionary *photo = self.photoDetails[indexPath.section][indexPath.row];
    NSArray *photoLocationDetails = [[photo valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    
    // Configure the cell...
    cell.textLabel.text = [photoLocationDetails firstObject];
    cell.detailTextLabel.text = photoLocationDetails[1];
    
    return cell;
}

// Displays country as section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.countries[section];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *cellIndex = [self.tableView indexPathForCell:sender];
        if (cellIndex) {
            if ([segue.identifier isEqualToString:@"Display Location Photos"]) {
                if ([segue.destinationViewController isKindOfClass:[FlickrLocationPhotosTVC class]]) {
                    // Gets details on photo's location id
                    NSDictionary *photo = self.photoDetails[cellIndex.section][cellIndex.row];
                    NSArray *photoLocationDetails = [[photo valueForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];

                    // Sets up destination view controller
                    FlickrLocationPhotosTVC *flptvc = segue.destinationViewController;
                    flptvc.title = [photoLocationDetails firstObject];
                    flptvc.location = [photo valueForKeyPath:FLICKR_PLACE_ID];
                }
            }
        }
    }
}


@end
