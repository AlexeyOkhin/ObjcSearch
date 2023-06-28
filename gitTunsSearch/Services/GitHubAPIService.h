//
//  GitHubAPIService.h
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

@interface GitHubAPIService : NSObject

- (void)fetchRepositoriesForUser: (NSString *)username completion: (void (^)(NSArray *repositories, NSError *error))completion;

@end
