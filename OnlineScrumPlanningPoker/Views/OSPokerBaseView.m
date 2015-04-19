//
//  OSPokerBaseView.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/16/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSPokerBaseView.h"
#import "Constants.h"
#import "UIColor+More.h"

@interface OSPokerBaseView ()
@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic) OSEstimationSize size;
@end

@implementation OSPokerBaseView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self=[super initWithCoder:aDecoder]){
        //init size
        self.size = kOSEstimationSize_M;
        //init label view
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:60];
        self.textLabel.textColor = [UIColor logoColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.text = kOSEstimationSizeStringSet[self.size];
        //add label
        [self addSubview:self.textLabel];
        //add gesture
        UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
        leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftGestureRecognizer];
        UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
        rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightGestureRecognizer];
    }
    return self;
}

- (OSEstimationSize)point{
    return self.size;
}

-(void)onSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self onSwipe:recognizer];
}

-(void)onSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    [self onSwipe:recognizer];
}

-(void)onSwipe:(UISwipeGestureRecognizer *)recognizer {
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.size < kOSEstimationSize_5XL) {
            self.size ++;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^(void) {
                                 self.textLabel.alpha = 0.0;
                                 self.textLabel.text = kOSEstimationSizeStringSet[self.size];
                                 self.textLabel.alpha = 1.0;
                             }
                             completion:nil];
        }
    }else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.size > kOSEstimationSize_XS) {
            self.size --;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^(void) {
                                 self.textLabel.alpha = 0.0;
                                 self.textLabel.text = kOSEstimationSizeStringSet[self.size];
                                 self.textLabel.alpha = 1.0;
                             }
                             completion:nil];
        }
    }else {
        NSLog(@"OSPokerBaseView swipe gesture direction unrecognized: %@",recognizer);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
