//
//  Notification.h
//  PicRaffle
//
//  Created by jessy hansen on 2017-11-20.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, strong) NSString *notiID;
@property (nonatomic, strong) NSString *notiContent;
@property (nonatomic, strong) NSString *notiKind;

@end
