//
//  GitHubAPIService.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

#import <Foundation/Foundation.h>
#import "GitHubAPIService.h"

@implementation GitHubAPIService

- (void)fetchRepositoriesForUser: (NSString *)username completion: (void (^)(NSArray *repositories, NSError *error))completion {
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
            NSArray *repositories = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &jsonError];
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                completion(repositories, nil);
            }
        } else {
            NSError *apiError = [NSError errorWithDomain:@"GitHubAPIErrorDomain" code:httpResponse.statusCode userInfo:nil];
            completion(nil, apiError);
        }
    }];

    [task resume];
}

@end
