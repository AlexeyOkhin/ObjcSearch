//
//  NetworkService.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

#import <Foundation/Foundation.h>
#import "NetworkService.h"
#import "GitModel.h"
#import "TunesModel.h"

@implementation NetworkService

- (void)fetchRepositoriesForGitHub: (NSString *)username completion: (void (^)(NSArray *models, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat: @"https://api.github.com/search/users?q=%@", username];
    NSURL *url = [NSURL URLWithString: urlString];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, jsonError);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(models, nil);
                });

            }
        } else {
            NSError *apiError = [NSError errorWithDomain:@"GitHubAPIErrorDomain" code:httpResponse.statusCode userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, apiError);
            });
        }
    }];

    [task resume];
}

- (void)fetchRepositoriesForTunes: (NSString *)searchText completion: (void (^)(NSArray *models, NSError *error))completion {
    NSString *urlString = [NSString stringWithFormat: @"https://itunes.apple.com/search?term=%@&limit=25", searchText];
    NSURL *url = [NSURL URLWithString: urlString];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSError *jsonError;
            NSDictionary *objectJson = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];

            NSDictionary *dictJsonModel = [[NSDictionary alloc] init];

            dictJsonModel = [objectJson valueForKey:@"results"];

            NSMutableArray *models = [[NSMutableArray alloc] init];

            for (NSDictionary *dictionaryKey in dictJsonModel) {
                TunesModel *tunesModel = [[TunesModel alloc] init];
                tunesModel.trackName = [dictionaryKey valueForKey:@"trackName"];
                tunesModel.artistName = [dictionaryKey valueForKey:@"artistName"];
                tunesModel.artworkUrl100 = [dictionaryKey valueForKey:@"artworkUrl100"];
                [models addObject: tunesModel];
            }

            if (jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, jsonError);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(models, nil);
                });

            }
        } else {
            NSError *apiError = [NSError errorWithDomain:@"iTunesAPIErrorDomain" code:httpResponse.statusCode userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, apiError);
            });
        }
    }];

    [task resume];
}

@end
