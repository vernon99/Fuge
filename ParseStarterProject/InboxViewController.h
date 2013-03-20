//
//  InboxViewController.h
//  SecondCircle
//
//  Created by Mikhail Larionov on 2/11/13.
//
//

#import "MainViewController.h"

// TODO: move all this stuff to InboxViewItem file
enum EInboxItemType
{
    INBOX_ITEM_INVITE   = 0,
    INBOX_ITEM_MESSAGE  = 1,
    INBOX_ITEM_COMMENT  = 2,
    INBOX_ITEM_NEWUSER  = 3
};

@class AsyncImageView;
@interface InboxViewItem : NSObject
@property (nonatomic) NSUInteger type;
@property (strong, nonatomic) id data;
//@property (strong, nonatomic) AsyncImageView *iconImage;
//@property (strong, nonatomic) AsyncImageView *mainImage;
@property (strong, nonatomic) NSString *fromId;
@property (strong, nonatomic) NSString *toId;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *misc;   // TODO: rename to status
@property (strong, nonatomic) NSDate *dateTime;
@end

@interface InboxViewController : MainViewController {
    
    NSMutableDictionary *inbox;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) reloadData;

- (void) dismissMeetup;

//@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end