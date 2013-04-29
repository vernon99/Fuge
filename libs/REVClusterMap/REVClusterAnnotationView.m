//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterAnnotationView.h"
#import "MainStyle.h"
#import "REVClusterPin.h"


@implementation REVClusterAnnotationView

@synthesize coordinate;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.frame = CGRectMake(0, 0, 49, 49);
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_backgroundImageView];
        
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"Helvetica" size:18];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}

- (void) setClusterNum:(NSUInteger)num
{
    _label.hidden = NO;
    [_label setText:[NSString stringWithFormat:@"%d",num]];
}

-(void)setColor:(PinColor)color{
    switch (color) {
        case PinBlue:
            _backgroundImageView.image = [UIImage imageNamed:@"blue-comb.png"];
            break;
        case PinGray:
            _backgroundImageView.image = [UIImage imageNamed:@"grey-comb.png"];
            break;
        case PinOrange:
            _backgroundImageView.image = [UIImage imageNamed:@"orange-comb.png"];
            break;
            
        default:
            break;
    }
}

-(void)prepareForAnnotation:(REVClusterPin*)annotation{
    [self setClusterNum:annotation.nodeCount];
    [self setColor:annotation.pinColor];
}


@end
