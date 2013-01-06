//
//  GlobalVariables.h
//  SecondCircle
//
//  Created by Mikhail Larionov on 12/31/12.
//
//

#import <Foundation/Foundation.h>

#define globalVariables [GlobalVariables sharedInstance]

#define RANDOM_PERSON_KILOMETERS    50000
#define RANDOM_EVENT_KILOMETERS    50000

@interface GlobalVariables : NSObject
{
    Boolean bNewUser;
    Boolean bSendPushToFriends;
}

- (Boolean)isNewUser;
- (void)setNewUser;

- (Boolean)shouldSendPushToFriends;
- (void)pushToFriendsSent;

+ (id)sharedInstance;

@end