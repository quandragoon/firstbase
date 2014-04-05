//
//  Resources.m
//  FirstBase
//
//  Created by Changping Chen on 4/5/14.
//  Copyright (c) 2014 Quan Nguyen. All rights reserved.
//

#import "Resources.h"
#import "ObjectNameConstants.h"

@implementation Resources

+ (UIImage *)iconForBasketball
{
    return [UIImage imageNamed:@"basketball_icon.png"];
}

+ (UIImage *)iconForFrisbee
{
    return [UIImage imageNamed:@"frisbee_icon.jpg"];
}

+ (UIImage *)iconForSportType:(NSString *)type
{
    if ([type isEqualToString:kGameTypeBasketball]) {
        return [self iconForBasketball];
    }
    if ([type isEqualToString:kGameTypeFrisbee]) {
        return [self iconForFrisbee];
    }
    return nil;
}

@end
