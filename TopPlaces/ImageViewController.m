//
//  ImageViewController.m
//  TopPlaces
//
//  Created by Ruthwick Pathireddy on 7/22/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
// Display and store view and image
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

// Outlet to store image view
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Spinner for loading page
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ImageViewController

#pragma mark - Downloading Images

// Sets the image url and fetches the image from it
- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self fetchImage];
}

// Fetches the image from the url stores it.
// Method runs in a different thread to not block the main thread duing fetching
- (void)fetchImage
{
    self.image = nil;
    if (self.imageURL) {
        [self.activityIndicator startAnimating];
        // Forms a request and session from the image url
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        // Creates a download task for the request
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                            if (!error) {
                                                                // Double checks to see if the url we asked for still stayed the same
                                                                if ([request.URL isEqual:self.imageURL]) {
                                                                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                                                                    
                                                                    // Perform UI related task on main queue
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        self.image = [UIImage imageWithData:imageData];
                                                                    });
                                                                }
                                                            }
                                                        }];
        // Starts the task
        [task resume];
    }
}

#pragma mark - Scrolling and ImageView properties

// Sets the image view when image is set
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Resets scroll view zooming and size
    self.scrollView.zoomScale = 1.0;
    [self.scrollView setContentSize: self.image ? self.image.size : CGSizeZero];
    [self.activityIndicator stopAnimating];
}

// Zooms the image view
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// Sets scroll view options
- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = .2;
    self.scrollView.maximumZoomScale = 2.0;
    [self.scrollView setContentSize: self.image ? self.image.size : CGSizeZero];
}

#pragma mark - Image Getters and Setters

// Returns image from imageView
- (UIImage *)image
{
    return self.imageView.image;
}

// Lazy instantiation
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - View Controller Lifecycle

// Adds imageview to scroll view
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

#pragma mark - UISplitViewDelegate

// Removes master view in portrait mode
- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

// Adds button to master view controller
- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = [((UINavigationController *)aViewController) title];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

// Removes button when master view controller appears
- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
