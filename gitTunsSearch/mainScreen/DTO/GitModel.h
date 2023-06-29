//
//  GitModel.h
//  gitTunsSearch
//
//  Created by Djinsolobzik on 28.06.2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GitModel : NSObject 
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
