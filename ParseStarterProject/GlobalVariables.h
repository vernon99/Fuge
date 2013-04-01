//
//  GlobalVariables.h
//  SecondCircle
//
//  Created by Mikhail Larionov on 12/31/12.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define globalVariables [GlobalVariables sharedInstance]

#define RANDOM_PERSON_KILOMETERS    50
#define RANDOM_EVENT_KILOMETERS     50
#define MAX_ANNOTATIONS_ON_THE_MAP  200

@interface GlobalVariables : NSObject
{
    Boolean bNewUser;
    Boolean bSendPushToFriends;
    NSMutableDictionary* settings;
}

- (Boolean)isNewUser;
- (void)setNewUser;

- (Boolean)shouldSendPushToFriends;
- (void)pushToFriendsSent;

- (Boolean)shouldAlwaysAddToCalendar;
- (void)setToAlwaysAddToCalendar;

+ (id)sharedInstance;

@end
