

#import "Circle.h"
#import "Person.h"

@implementation Circle

@synthesize idCircle;

- (id)init:(NSUInteger)circle
{
    idCircle = circle;
	persons = [[NSMutableArray alloc] initWithCapacity:30];
    return self;
}

- (void)addPerson:(Person *)person {
    personsSortedByRank = nil;
	[persons addObject:person];    
}

- (void)removePerson:(Person *)person{
    personsSortedByRank = nil;
    [persons removeObject:person];
}

- (id)addPersonWithData:(PFUser*)data {
    personsSortedByRank = nil;
	Person *person = [[Person alloc] init:data circle:idCircle];
	[persons addObject:person];
    return person;
}

- (void)sort
{
    NSString* strKey = @"distance";
    if ( idCircle == CIRCLE_FBOTHERS )
        strKey = @"strFirstName";
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:strKey ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[persons sortUsingDescriptors:sortDescriptors];
}

- (NSMutableArray*) getPersons
{
    return persons;
}

- (NSMutableArray*) getPersonsSortedByRank
{
    if ( ! personsSortedByRank )
    {
        personsSortedByRank = [NSMutableArray arrayWithArray:persons];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"matchesRank" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [personsSortedByRank sortUsingDescriptors:sortDescriptors];

    }
    return personsSortedByRank;
}

+ (NSString*) getPersonType:(NSUInteger)circle
{
    switch (circle)
    {
        case CIRCLE_FB: return @"Facebook friend";
        case CIRCLE_2O: return @"Friend of a friend";
        case CIRCLE_RANDOM: return @"Random encounter";
        case CIRCLE_FBOTHERS: return @"Facebook friend";
    }
    return @"";
}

+ (NSString*) getCircleName:(NSUInteger)circle
{
    switch (circle)
    {
        case CIRCLE_FB: return @"First circle";
        case CIRCLE_2O: return @"Second circle";
        case CIRCLE_RANDOM: return @"Random connections";
        case CIRCLE_FBOTHERS: return @"Facebook friends";
    }
    return @"";
}

-(NSString*)description{
    return [NSString stringWithFormat:@"%@ :%d persons",[Circle getCircleName:self.idCircle],persons.count];
}

@end
