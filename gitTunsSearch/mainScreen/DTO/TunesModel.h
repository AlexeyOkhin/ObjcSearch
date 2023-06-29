//
//  TunesModel.h
//  gitTunsSearch
//
//  Created by Djinsolobzik on 29.06.2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TunesModel : NSObject
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artworkUrl100;
@end

NS_ASSUME_NONNULL_END
