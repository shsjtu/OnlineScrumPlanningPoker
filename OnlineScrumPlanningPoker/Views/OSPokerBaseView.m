//
//  OSPokerBaseView.m
//  OnlineScrumPlanningPoker
//
//  Created by SunHan on 4/16/15.
//  Copyright (c) 2015 SunHan. All rights reserved.
//

#import "OSPokerBaseView.h"
#import "OSConstants.h"
#import "UIColor+More.h"

@interface OSPokerBaseView () <UIPickerViewDataSource, UIPickerViewDelegate>
//@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic, strong) UIPickerView* picker;
//@property (nonatomic) OSEstimationSize size;
@end

@implementation OSPokerBaseView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self=[super initWithCoder:aDecoder]){
        self.picker = [[UIPickerView alloc] init];
        self.picker.frame = self.bounds;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.picker.showsSelectionIndicator = YES;
        [self.picker selectRow:(kOSEstimationSize_M-1) inComponent:0 animated:NO];
        [self addSubview:self.picker];
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (NSString*)pointString {
    return kOSEstimationSizePointSet[[self.picker selectedRowInComponent:0]+1];
}

#pragma mark - UIPickerViewDataSource / UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kOSEstimationSize_5XL;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* label = (UILabel*)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor logoColor];
    }
    label.text = kOSEstimationSizePointSet[row+1];
    return label;
}

@end
