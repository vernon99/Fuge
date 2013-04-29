//
//  UserProfileController.h
//  SecondCircle
//
//  Created by Mikhail Larionov on 12/2/12.
//
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "GrowingTextViewExampleViewController.h"

@class AsyncImageView;
@interface UserProfileController : GrowingTextViewExampleViewController <UIAlertViewDelegate>
{
    Person* personThis;
    IBOutlet UITextView *messageHistory;
    IBOutlet AsyncImageView *profileImage;
    UIBarButtonItem *buttonProfile;
    IBOutlet UILabel *labelDistance;
    IBOutlet UILabel *labelCircle;
    
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *ignoreButton;
    
    NSUInteger  messagesCount;
}

@property (nonatomic, strong) UIBarButtonItem *buttonProfile;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) setPerson:(Person*)person;

- (IBAction)addButtonDown:(id)sender;
- (IBAction)ignoreButtonDown:(id)sender;
- (IBAction)meetButtonDown:(id)sender;

@end