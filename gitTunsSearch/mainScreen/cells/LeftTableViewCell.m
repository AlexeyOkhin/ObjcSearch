//
//  LeftTableViewCell.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 27.06.2023.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageAuthor = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self.contentView addSubview:self.imageView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, CGRectGetWidth(self.contentView.frame) - 100, 30)];
        [self.contentView addSubview:self.titleLabel];

        self.linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, CGRectGetWidth(self.contentView.frame) - 100, 30)];
        [self.contentView addSubview:self.linkLabel];
    }
    return self;
}

@end
