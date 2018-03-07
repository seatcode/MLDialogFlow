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
 
#import "AIRequest.h"
@class AIResponse;

/*!
 * Succesfull handler definition for AIRequest.
 *
 * @param request The request called handler.
 * @param response Server responce (Serialized JSON).
 */
typedef void(^SuccesfullMappedResponseBlock)(AIRequest * __AI_NONNULL request, AIResponse * __AI_NONNULL response);

@interface AIRequest (AIMappedResponse)

/**
 Set completion handlers. That method processing response and mapping it to AIResponse.
 @param succesfullBlock A block object to be executed when the task finishes successfully.
 @param failureBlock A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data.
 */

- (void)setMappedCompletionBlockSuccess:(SuccesfullMappedResponseBlock __AI_NONNULL)succesfullBlock failure:(FailureResponseBlock __AI_NULLABLE)failureBlock;

@end
