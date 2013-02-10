//
//  Meetup.m
//  SecondCircle
//
//  Created by Mikhail Larionov on 1/6/13.
//
//

#import "Meetup.h"
#import "GlobalVariables.h"

@implementation Meetup

@synthesize strId,strOwnerId,strOwnerName,strSubject,dateTime,privacy,location,strVenue,strAddress,meetupData;

-(id) init
{
    if (self = [super init]) {
        meetupData = nil;
        strAddress = @"";
    }
    
    return self;
}

- (void) save
{
    NSNumber* timestamp = [[NSNumber alloc] initWithDouble:[dateTime timeIntervalSince1970]];
    
    if ( ! meetupData )
    {
        meetupData = [[PFObject alloc] initWithClassName:@"Meetup"];
        
        // Id, fromStr, fromId
        strId = [[NSString alloc] initWithFormat:@"%d_%@", [timestamp integerValue], strOwnerId];
        [meetupData setObject:strId forKey:@"meetupId"];
        [meetupData setObject:strOwnerId forKey:@"userFromId"];
        [meetupData setObject:strOwnerName forKey:@"userFromName"];
        
        // Is read? TODO: it is p2a so it won't work at all
        [meetupData setObject:[NSNumber numberWithBool:FALSE] forKey:@"isRead"];
    }
    
    // Subject, privacy, date, timestamp, location
    [meetupData setObject:strSubject forKey:@"subject"];
    [meetupData setObject:[NSNumber numberWithInt:privacy] forKey:@"privacy"];
    [meetupData setObject:dateTime forKey:@"meetupDate"];
    [meetupData setObject:timestamp forKey:@"meetupTimestamp"];
    [meetupData setObject:location forKey:@"location"];
    [meetupData setObject:strVenue forKey:@"venue"];
    [meetupData setObject:strAddress forKey:@"address"];
    
    // Save
    [meetupData saveInBackground];
}

-(void) unpack:(PFObject*)data
{
    meetupData = data;
    
    strId = [meetupData objectForKey:@"meetupId"];
    strOwnerId = [meetupData objectForKey:@"userFromId"];
    strOwnerName = [meetupData objectForKey:@"userFromName"];
    strSubject = [meetupData objectForKey:@"subject"];
    privacy = [[meetupData objectForKey:@"privacy"] integerValue];
    dateTime = [meetupData objectForKey:@"meetupDate"];
    location = [meetupData objectForKey:@"location"];
    strVenue = [meetupData objectForKey:@"venue"];
    strAddress = [meetupData objectForKey:@"address"];
}



static UIViewController* tempController = nil;

- (void)presentEventEditViewControllerWithEventStore:(EKEventStore*)eventStore
{
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = [strSubject stringByAppendingFormat:@" at %@", strVenue];
    event.startDate = dateTime;
    event.endDate   = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:event.startDate];
    event.location = strAddress;
    
    /*EKCalendarChooser* chooser = [[EKCalendarChooser alloc] initWithSelectionStyle:EKCalendarChooserSelectionStyleSingle displayStyle:EKCalendarChooserDisplayWritableCalendarsOnly entityType:EKEntityTypeEvent eventStore:eventStore];
     
     [self.navigationController pushViewController:chooser animated:YES];*/
    
    EKEventEditViewController* eventView = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    [eventView setEventStore:eventStore];
    [eventView setEvent:event];
    
    if ( tempController )
    {
        [tempController presentModalViewController:eventView animated:YES];
    }
    
    eventView.editViewDelegate = self;
    
    //    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    //    NSError *err;
    //    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
    
    NSError *error = nil;
    EKEvent *thisEvent = controller.event;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            break;
            
        case EKEventEditViewActionSaved:
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            break;
            
        case EKEventEditViewActionDeleted:
            [controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            break;
            
        default:
            break;
    }
    // Dismiss the modal view controller
    [controller dismissModalViewControllerAnimated:YES];
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
/*- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
 //EKCalendar *calendarForEdit = self.defaultCalendar;
 return calendarForEdit;
 }*/

- (void) addToCalendarInternal
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    // iOS 6 introduced a requirement where the app must
    // explicitly request access to the user's calendar. This
    // function is built to support the new iOS 6 requirement,
    // as well as earlier versions of the OS.
    if([eventStore respondsToSelector:
        @selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore
         requestAccessToEntityType:EKEntityTypeEvent
         completion:^(BOOL granted, NSError *error) {
             // If you don't perform your presentation logic on the
             // main thread, the app hangs for 10 - 15 seconds.
             [self performSelectorOnMainThread:
              @selector(presentEventEditViewControllerWithEventStore:)
                                    withObject:eventStore
                                 waitUntilDone:NO];
         }];
    } else {
        // iOS 5
        [self presentEventEditViewControllerWithEventStore:eventStore];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // No
    if ( buttonIndex == 2 )
        return;
    
    // Always
    if ( buttonIndex == 0 )
        [globalVariables setToAlwaysAddToCalendar];
    
    // Yes
    [self addToCalendarInternal];
}

-(void) addToCalendar:(UIViewController*)controller shouldAlert:(Boolean)alert
{
    tempController = controller;
    
    // Already added
    if ( [self addedToCalendar] )
    {
        if ( alert )
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Calendar" message:@"This meetup is already added to your calendar." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [message show];
        }
        return;
    }
    
    // Ask yes/no/always question
    if ( ! [globalVariables shouldAlwaysAddToCalendar] )
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Calendar" message:@"Would you like to add this event to your calendar?" delegate:self cancelButtonTitle:@"Always" otherButtonTitles:@"Yes",@"No",nil];
        [message show];
    }
    else
        [self addToCalendarInternal];
}

-(Boolean) addedToCalendar
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    NSDate* dateEnd = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:dateTime];
    NSPredicate *predicateForEvents = [eventStore predicateForEventsWithStartDate:dateTime endDate:dateEnd calendars:nil];
    
    NSArray *eventsFound = [eventStore eventsMatchingPredicate:predicateForEvents];
    
    for (EKEvent *eventToCheck in eventsFound)
    {
        if ([eventToCheck.location isEqualToString:strAddress])
            return true;
    }
    
    return false;
}

@end
