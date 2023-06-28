//
//  GitHubAPIService.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

#import <Foundation/Foundation.h>
#import "GitHubAPIService.h"
#import "GitModel.h"

@implementation GitHubAPIService

- (void)fetchRepositoriesForUser: (NSString *)username completion: (void (^)(NSArray *models, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat: @"https://api.github.com/search/users?q=%@", username];
    NSURL *url = [NSURL URLWithString: urlString];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSError *jsonError;
            NSDictionary *objectJson = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &jsonError];

            NSDictionary *dictJsonModel = [[NSDictionary alloc] init];

            dictJsonModel = [objectJson valueForKey:@"items"];

            NSMutableArray *models = [[NSMutableArray alloc] init];

            for (NSDictionary *dictionaryKey in dictJsonModel) {
                GitModel *gitModel = [[GitModel alloc] init];
                gitModel.login = [dictionaryKey valueForKey:@"login"];
                gitModel.url = [dictionaryKey valueForKey:@"url"];
                gitModel.avatarUrl = [dictionaryKey valueForKey:@"avatar_url"];
                [models addObject: gitModel];
            }

            if (jsonError) {
                completion(nil, jsonError);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(models, nil);
                });

            }
        } else {
            NSError *apiError = [NSError errorWithDomain:@"GitHubAPIErrorDomain" code:httpResponse.statusCode userInfo:nil];
            completion(nil, apiError);
        }
    }];

    [task resume];
}

@end
