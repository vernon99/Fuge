//
//  NewEventViewController.m
//  SecondCircle
//
//  Created by Mikhail Larionov on 1/5/13.
//
//

#import "NewMeetupViewController.h"
#import "VenueSelectViewController.h"
#import <Parse/Parse.h>
#import "FSVenue.h"
#import "GlobalData.h"
#import "MeetupInviteViewController.h"
#import "LocationManager.h"

@implementation NewMeetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        meetup = nil;
        invitee = nil;
        datePicker = nil;
        self.navigationItem.leftItemsSupplementBackButton = true;
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillShow:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void) removeDatePicker
{
    if ( datePicker )
    {
        [datePicker removeFromSuperview];
        datePicker = nil;
    }
}

-(void) setMeetup:(Meetup*)m
{
    meetup = m;
    meetupType = m.meetupType;
}

-(void) setInvitee:(Person*)i
{
    invitee = i;
}

-(void) setType:(NSUInteger)t
{
    meetupType = t;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    if ( meetupType == TYPE_MEETUP )
    {
        if (meetup)
            self.title = @"Meetup";
        else
            self.title = @"New meetup";
    }
    else
        self.title = @"Thread";
    
    // Navigation
    [self.navigationController setNavigationBarHidden:false animated:false];
    [self.navigationItem setHidesBackButton:false animated:false];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDown)]];
    
    UIBarButtonItem *button = nil;
    if (meetup) {
        button = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    }else{
        button = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
        
    }
    [self.navigationItem setRightBarButtonItem:button];
    
    if ( meetup )
    {
        [subject setText:meetup.strSubject];
        [notifySwitch setOn:(! meetup.privacy)];
        [location setTitle:meetup.strVenue forState:UIControlStateNormal];
        meetupDate = meetup.dateTime;
        [self dateChanged:nil];
    }
    else
    {
        if ( invitee )  // Private meetup created from user profile, turn off publicity
            [notifySwitch setOn:FALSE];
        
        // Default time
        NSDateComponents* deltaCompsDefault = [[NSDateComponents alloc] init];
        if (meetupType == TYPE_MEETUP)
            [deltaCompsDefault setMinute:30];
        else
            [deltaCompsDefault setDay:7];
        NSDate* dateDefault = [[NSCalendar currentCalendar] dateByAddingComponents:deltaCompsDefault toDate:[NSDate date] options:0];
        meetupDate = dateDefault;
        
        // Set focus on text view
        [subject becomeFirstResponder];
    }
    
    if ( meetupType == TYPE_THREAD )
        dateBtn.hidden = TRUE;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    location.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        datePicker.originY = self.view.height;
    } completion:^(BOOL finished) {
        location.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
        datePicker = nil;
    }];
}

- (void)dateChanged:(UIDatePicker *)picker
{
    if ( picker )
        meetupDate = picker.date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDoesRelativeDateFormatting:TRUE];
    [dateBtn setTitle:[formatter stringFromDate:meetupDate] forState:UIControlStateNormal];
}

- (IBAction)selectDateBtn:(id)sender
{
    if (!datePicker) {
        datePicker = [UIDatePicker new];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
        datePicker.originY = self.view.height;
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.minuteInterval = 15;
        
        NSDateComponents* deltaCompsMin = [[NSDateComponents alloc] init];
        [deltaCompsMin setMinute:15];
        NSDate* dateMin = [[NSCalendar currentCalendar] dateByAddingComponents:deltaCompsMin toDate:[NSDate date] options:0];
        NSDateComponents* deltaCompsMax = [[NSDateComponents alloc] init];
        [deltaCompsMax setDay:7];
        NSDate* dateMax = [[NSCalendar currentCalendar] dateByAddingComponents:deltaCompsMax toDate:[NSDate date] options:0];
        
        [datePicker setMinimumDate:dateMin];
        [datePicker setMaximumDate:dateMax];
        [datePicker setDate:meetupDate];
        
    }
    [self.view endEditing:YES];
    location.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        datePicker.originY = self.view.height - datePicker.height;
    } completion:^(BOOL finished) {
        location.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    }];
}

- (IBAction)venueButton:(id)sender {
//    [self removePopups];
    if (!venueNavViewController) {
        VenueSelectViewController *venueViewController = [[VenueSelectViewController alloc] initWithNibName:@"VenueSelectView" bundle:nil];
        venueViewController.delegate = self;
        venueNavViewController = [[UINavigationController alloc]initWithRootViewController:venueViewController];
    }
    [self presentViewController:venueNavViewController
                       animated:YES completion:nil];
}


/*-(void)hideKeyBoard{
    [subject resignFirstResponder];
}*/

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.selectedVenue) {
        [location setTitle:self.selectedVenue.name forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cancelButtonDown {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)validateForm{
    if ( subject.text.length == 0 )
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Not yet!" message:@"Please, enter the subject of the meetup in the text above!" delegate:nil cancelButtonTitle:@"Sure man!" otherButtonTitles:nil];
        [errorAlert show];
        return NO;
    }
    
    if ( ! self.selectedVenue && ! meetup && ! [locManager getPosition] )
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Not yet!" message:@"We were unable to retrieve your current location, please, select a venue for the meetup." delegate:nil cancelButtonTitle:@"Sure man!" otherButtonTitles:nil];
        [errorAlert show];
        return NO;
    }
    return YES;
}

-(void)populateMeetupWithData{
    meetup.meetupType = meetupType;
    meetup.strOwnerId = (NSString *) [[PFUser currentUser] objectForKey:@"fbId"];
    meetup.strOwnerName = (NSString *) [[PFUser currentUser] objectForKey:@"fbName"];
    meetup.strSubject = subject.text;
    meetup.privacy = notifySwitch.isOn ? MEETUP_PUBLIC : MEETUP_PRIVATE;
    meetup.dateTime = meetupDate;
    
    if ( self.selectedVenue )
    {
        [meetup populateWithVenue:self.selectedVenue];
        [globalData addRecentVenue:self.selectedVenue];
    }
    else
        [meetup populateWithCoords];
}

-(void)save{
    if (![self validateForm])
        return;
    
    // Saving meetup on server
    [self populateMeetupWithData];
    
    [meetup save];
    
    // Creating comment
    [globalData createCommentForMeetup:meetup commentType:COMMENT_SAVED commentText:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextInternal
{
    // Saving meetup on server
    meetup = [[Meetup alloc] init];
    [self populateMeetupWithData];
    Boolean bResult = [meetup save];
    
    // Loading ended
    [activityIndicator stopAnimating];
    
    if ( ! bResult )
        return;
    
    // Adding to the list on client and creating comment
    [globalData addMeetup:meetup];
    [globalData createCommentForMeetup:meetup commentType:COMMENT_CREATED commentText:nil];
    
    // Add to attending list and update meetup attending list (only on client)
    [globalData attendMeetup:meetup];
    [meetup addAttendee:strCurrentUserId];
    
    // Invites
    MeetupInviteViewController *inviteController = [[MeetupInviteViewController alloc]init];
    if ( invitee ) // Add invitee if this window was ivoked from user profile
        [inviteController addInvitee:invitee];
    [inviteController setMeetup:meetup newMeetup:true];
    [self.navigationController pushViewController:inviteController animated:YES];
}

- (void)next {
    if (![self validateForm])
        return;
    
    [activityIndicator startAnimating];
    
    [self performSelector:@selector(nextInternal) withObject:nil afterDelay:0.01f];
}

- (IBAction)privacyChanged:(id)sender {
    if ( [pCurrentUser.createdAt compare:[NSDate date]] == NSOrderedDescending )
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Too early" message:@"Public meetups are available only for experienced users, registered at least a week ago. Try creating private meetup and invite your friends, so you will become familiar with how it works." delegate:self cancelButtonTitle:@"Alright" otherButtonTitles:nil, nil];
        [alert show];
        [notifySwitch setOn:FALSE animated:TRUE];
        notifySwitch.enabled = FALSE;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [subject resignFirstResponder];
    return true;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [subject resignFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
