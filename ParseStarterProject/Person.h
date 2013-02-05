
#import "CoreLocation/CLLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@class PersonView;

@interface Person : NSObject {
    PFUser* object;
    
    NSString *strId;
    NSString *strName;
    NSString *strAge;
    NSString *strGender;
    NSString *strDistance;
    NSString *strRole;
    NSString *strArea;
    NSString *strCircle;
    
    CLLocationCoordinate2D location;
    
	UIImage *image;
    NSMutableData* imageData;
    NSURLConnection *urlConnection;
    NSURL *pictureURL;
    NSMutableURLRequest *urlRequest;
    PersonView* pParent;
}

@property (nonatomic, retain) NSString *strId;
@property (nonatomic, retain) NSString *strName;
@property (nonatomic, retain) NSString *strAge;
@property (nonatomic, retain) NSString *strGender;
@property (nonatomic, retain) NSString *strDistance;
@property (nonatomic, retain) NSString *strRole;
@property (nonatomic, retain) NSString *strArea;
@property (nonatomic, retain) NSString *strCircle;

@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSURL *pictureURL;
@property (nonatomic, retain) NSMutableURLRequest *urlRequest;

@property (nonatomic, retain) PersonView* pParent;

// TODO: change it to more secure init
- init:(NSArray*)nameComponents;
- (void)addParent:(PersonView*)parent;
- (UIImage *) getImage;

- (void) setLocation:(CLLocationCoordinate2D) loc;
- (CLLocationCoordinate2D) getLocation;

@end
