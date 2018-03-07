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

#import "AIRequestEntity.h"
#import "AIRequestEntry.h"
#import "AIRequestContext.h"

@class AIDataService;
@class AIRequest;

/*!
 * Succesfull handler definition for AIRequest.
 *
 * @param request The request called handler.
 * @param response Server responce (Serialized JSON).
 */
typedef void(^SuccesfullResponseBlock)(AIRequest * __AI_NONNULL request, id __AI_NONNULL response);

/*!
 * Failure handler definition for AIRequest.
 *
 * @param request The request called handler.
 * @param error The response error.
 */
typedef void(^FailureResponseBlock)(AIRequest * __AI_NONNULL request, NSError * __AI_NONNULL error);

@protocol AIRequest <NSObject>

/*!
 
 @property dataTask
 
 @discussion NSURLSessionDataTask.
 
 */
@property(nonatomic, strong, AI_NULLABLE) NSURLSessionDataTask *dataTask;

/*!
 
 @property dataService
 
 @discussion private property, don't use it.
 
 */
@property(nonatomic, weak, AI_NULLABLE) AIDataService *dataService;

@end

@interface AIRequest : NSOperation <AIRequest>

/*!
 
 @property error
 
 @discussion Contain error (optional) after getting response
 
 */
@property(nonatomic, copy, AI_NULLABLE) NSError *error;

/*!
 
 @property response
 
 @discussion Contain server response.
 
 */
@property(nonatomic, strong, AI_NULLABLE) id response;

/**
 Set completion handlers.
 @param succesfullBlock A block object to be executed when the task finishes successfully.
 @param failureBlock A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data.
 */
- (void)setCompletionBlockSuccess:(SuccesfullResponseBlock __AI_NONNULL)succesfullBlock failure:(FailureResponseBlock __AI_NULLABLE)failureBlock;

- (instancetype __AI_NONNULL)init __unavailable;

@end
