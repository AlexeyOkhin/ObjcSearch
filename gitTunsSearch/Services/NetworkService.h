//
//  NetworkService.h
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

@interface NetworkService : NSObject

- (void)fetchRepositoriesForGitHub: (NSString *)username completion: (void (^)(NSArray *models, NSError *error))completion;
- (void)fetchRepositoriesForTunes: (NSString *)searchText completion: (void (^)(NSArray *models, NSError *error))completion;

@end
