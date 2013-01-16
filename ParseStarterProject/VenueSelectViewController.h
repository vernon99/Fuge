//
//  VenueSelectViewController.h
//  SecondCircle
//
//  Created by Mikhail Larionov on 1/6/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface VenueSelectViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_annotations;
}


@property (strong, nonatomic) IBOutlet UIButton *refreshButton;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet NSArray *venues;
@property (strong, nonatomic) IBOutlet NSArray *annotations;
@property (strong, nonatomic) IBOutlet UITableView *tableView;



- (IBAction)refresh:(id)sender;

@end
