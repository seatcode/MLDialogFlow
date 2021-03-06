/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#import "AIResponseParameterConstants.h"


NSString *const kDateOnlyFormat = @"yyyy-MM-dd";
NSString *const kTimeOnlyFormat = @"HH:mm:ss";
NSString *const kDateTimeFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";


NSString *const timeZoneAbbreviation = @"GMT";
NSString *const localeIdentifier = @"en_US";

@interface AIResponseParameterConstants()

@property(nonatomic, copy) NSDate *defaultDate;
@property(nonatomic, copy) NSTimeZone *timeZone;
@property(nonatomic, copy) NSLocale *locale;

@property(nonatomic, copy) NSArray AI_GENERICS_1(NSString *) *allDateFormats;
@property(nonatomic, copy) NSArray AI_GENERICS_1(NSDateFormatter *) *dateFormatters;
@property(nonatomic, copy) NSArray AI_GENERICS_1(AIDatePeriodFormatter *) *datePeriodFormatters;

@property(nonatomic, copy) NSNumberFormatter *numberFormatter;

@property(nonatomic, strong) NSMutableDictionary *dateFormattersCache;

@end

@implementation AIResponseParameterConstants

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultDate = [NSDate dateWithTimeIntervalSince1970:0];
        self.timeZone = [NSTimeZone timeZoneWithAbbreviation:timeZoneAbbreviation];
        self.locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
        
        self.allDateFormats = @[
                                kDateOnlyFormat,
                                kTimeOnlyFormat,
                                kDateTimeFormat
                                ];
        
        self.dateFormattersCache = [NSMutableDictionary dictionary];
        
        NSMutableArray AI_GENERICS_1(NSDateFormatter *) *dateFormatters = [NSMutableArray array];
        
        [self.allDateFormats enumerateObjectsUsingBlock:^(NSString * __AI_NONNULL dateFormat, NSUInteger idx, BOOL * __AI_NONNULL stop) {
            [dateFormatters addObject:[self dateFormatterForFormat:dateFormat]];
        }];
        
        self.dateFormatters = dateFormatters;
        
        NSMutableArray AI_GENERICS_1(AIDatePeriodFormatter *) *datePeriodFormatters = [NSMutableArray array];
        
        [self.dateFormatters enumerateObjectsUsingBlock:^(NSDateFormatter * __AI_NONNULL dateFormatter, NSUInteger idx, BOOL * __AI_NONNULL stop) {
            AIDatePeriodFormatter *formatter = [[AIDatePeriodFormatter alloc] init];
            
            formatter.toDateFormatter = dateFormatter;
            formatter.fromDateFormatter = dateFormatter;
            
            [datePeriodFormatters addObject:formatter];
        }];
        
        self.datePeriodFormatters = datePeriodFormatters;
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        numberFormatter.locale = self.locale;
        
        self.numberFormatter = numberFormatter;
    }
    return self;
}

- (NSDateFormatter *)dateFormatterForFormat:(NSString *)dateFormat {
    NSDateFormatter *cached = self.dateFormattersCache[dateFormat];
    if (cached) {
        return cached;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:self.locale];
        
        dateFormatter.defaultDate = self.defaultDate;
        dateFormatter.timeZone = self.timeZone;
        
        [dateFormatter setDateFormat:dateFormat];
        
        self.dateFormattersCache[dateFormat] = dateFormatter;
        
        return dateFormatter;
    }
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static AIResponseParameterConstants *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AIResponseParameterConstants alloc] init];
    });
    
    return instance;
}

@end
