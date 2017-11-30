//
//  Notification.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-11-20.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.notiID = [attributes valueForKeyPath:@"noti_id"];
    self.notiContent = [attributes valueForKeyPath:@"noti_con"];
    self.notiKind = [attributes valueForKeyPath:@"noti_kind"];
    
    return self;
}

@end

@implementation Notification (NSCoding)

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.notiID forKey:@"noti_id"];
    [aCoder encodeObject:self.notiContent forKey:@"noti_con"];
    [aCoder encodeObject:self.notiKind forKey:@"noti_kind"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.notiID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"noti_id"];
    self.notiContent = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"noti_con"];
    self.notiID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"noti_kind"];
    
    return self;
}

@end
