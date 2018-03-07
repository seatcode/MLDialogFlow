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
 
#import <Foundation/Foundation.h>

#import "AIConfiguration.h"
#import "AIRequest.h"
#import "AITextRequest.h"
#import "AIDefaultConfiguration.h"

#if __has_include("AIResponse.h")
    #import "AIResponse.h"
#endif

#if __has_include("AIUserEntitiesRequest.h")
    #import "AIUserEntitiesRequest.h"
#endif

#if __has_include("AIEventRequest.h")
    #import "AIEventRequest.h"
#endif

/*!
 
 @enum AIRequestType enum
 
 @discussion Requst type (Text).
 
 */
typedef NS_ENUM(NSUInteger, AIRequestType) {
    /*! Simple text request type */
    AIRequestTypeText
};

/*!
 
 @class ApiAI
 
 @discussion ApiAI endpoint for ApiAi SDK
 */
@interface ApiAI : NSObject

+ (ApiAI * __AI_NONNULL)sharedApiAI;

+ (NSArray * __AI_NONNULL)supportedLanguages;

/*!
 
 @property lang language
 
 @discussion configuration language, default using first system ([NSLocale preferredLanguages]) 
 cantaining in [ApiAI supportedLanguages]. Can be:
                             @"en",
                             @"es",
                             @"ru",
                             @"de",
                             @"pt",
                             @"pt-BR",
                             @"es",
                             @"fr",
                             @"it",
                             @"ja",
                             @"ko",
                             @"zh-CN",
                             @"zh-HK",
                             @"zh-TW",
 */

@property(nonatomic, copy, AI_NONNULL) NSString *lang;

/*!
 
 @property version string
 
 @discussion configuration version property, default use latest version, not recommended use it.
 
 */

@property(nonatomic, copy, AI_NONNULL) NSString *version;

/*!
 
 @property ApiAI enum
 
 @discussion configuration property, cannot be NULL.
 
 */
@property(nonatomic, strong) id <AIConfiguration> __AI_NONNULL configuration;

#if __has_include("AITextRequest.h")
- (AITextRequest * __AI_NONNULL)textRequest;
#endif

#if __has_include("AIUserEntitiesRequest.h")
- (AIUserEntitiesRequest * __AI_NONNULL)userEntitiesRequest;
#endif


#if __has_include("AIEventRequest.h")
- (AIEventRequest * __AI_NONNULL)eventRequest;
#endif

/*!
 
 @method enqueue
 
 @discussion using this method for send request.
 
 */
- (void)enqueue:(NSOperation<AIRequest> * __AI_NONNULL)request;

/*!
 
 @method cancellAllRequests
 
 @discussion using this method for cancell all performing requests.
 
 */

- (void)cancellAllRequests;

@end
