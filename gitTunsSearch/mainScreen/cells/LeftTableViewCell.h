//
//  LeftTableViewCell.h
//  gitTunsSearch
//
//  Created by Djinsolobzik on 27.06.2023.
//

#import <UIKit/UIKit.h>
#import "ImageTappedDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeftTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *linkLabel;
@property (nonatomic, strong) UIImageView *imageAvatar;
@property (nonatomic, weak) id <ImageTappedDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
