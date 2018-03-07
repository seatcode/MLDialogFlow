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

#import "AINullabilityDefines.h"

@class AIResponseContext;
@class AIResponseFulfillment;
@class AIResponseMetadata;
@class AIResponseParameter;

/**
 `AIResponseResult` is class containing result of server response.
*/

@interface AIResponseResult : NSObject

- (instancetype __AI_NONNULL)init __unavailable;

/**
 Source of processing request. Can be 'agent', 'domain'
 */
@property(nonatomic, copy, readonly, AI_NULLABLE) NSString *source;

/**
 The query that was used to produce this result.
 */
@property(nonatomic, copy, readonly, AI_NULLABLE) NSString *resolvedQuery;

/**
 'actionIncomplete'
 */

@property(nonatomic, copy, readonly, AI_NULLABLE) NSNumber *actionIncomplete;

/**
 Action.
 */
@property(nonatomic, copy, readonly, AI_NULLABLE) NSString *action;

/**
 The list of parameters for the action.
 */
@property(nonatomic, copy, readonly, AI_NONNULL) NSDictionary AI_GENERICS_2(NSString *, AIResponseParameter *) *parameters;

/**
 Array of `AIResponseContext` object.
 
 @see `AIResponseContext`
 */
@property(nonatomic, copy, readonly, AI_NONNULL) NSArray AI_GENERICS_1(AIResponseContext *) *contexts;

/**
 Fulfillment.
 
 @see `AIResponseFulfillment`
 */
@property(nonatomic, strong, readonly, AI_NONNULL) AIResponseFulfillment *fulfillment;

/**
 Metadata object.
 
 @see `AIResponseMetadata`
 */
@property(nonatomic, strong, readonly, AI_NONNULL) AIResponseMetadata *metadata;

@end
