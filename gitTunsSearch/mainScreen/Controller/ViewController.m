//
//  ViewController.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

#import "ViewController.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "NetworkService.h"
#import "GitModel.h"
#import "TunesModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataModels;
@property (nonatomic, strong) NetworkService *networkService;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) UIImageView *expandedImageView;

@end

@implementation ViewController

// MARK: - Init

- (void)awakeFromNib {
    [super awakeFromNib];

    self.searchString = @"";
    self.networkService = [[NetworkService alloc] init];
}

// MARK: - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingTableView];
    [self settingSearchBar];
}

// MARK: - Private Methods

-(void)settingTableView {
    self.tableView = [[UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    [self.view addSubview: self.tableView];
    [self.tableView registerClass: [LeftTableViewCell class] forCellReuseIdentifier: @"LeftImageCellIdentifier"];
    [self.tableView registerClass: [RightTableViewCell class] forCellReuseIdentifier: @"RightImageCellIdentifier"];
}

-(void)settingSearchBar {
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchBar.delegate = self;
    searchController.searchBar.showsCancelButton = NO;
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.navigationItem.searchController.hidesNavigationBarDuringPresentation = NO;
}

// MARK: - Switch search

- (IBAction)segmentSearchAction:(UISegmentedControl *)sender {
    NSInteger selectedSegmentIndex = sender.selectedSegmentIndex;
    switch (selectedSegmentIndex) {
        case 0: {
            [self.networkService fetchRepositoriesForGitHub: _searchString completion: ^(NSArray *repositories, NSError *error) {
                self.dataModels = repositories;
                [self.tableView reloadData];
            }];
            break;
        }
        case 1: {
            [self.networkService fetchRepositoriesForTunes: _searchString completion: ^(NSArray *models, NSError *error) {
                self.dataModels = models;
                [self.tableView reloadData];
            }];
            break;
        }
    }
}

// MARK: - SearchBarDelegate

- (void)searchBar: (UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    NSLog(@"%@", searchText);
    _searchString = searchText;
}

- (void)searchBarCancelButtonClicked: (UISearchBar *)searchBar {
    _searchString = @"";
    self.dataModels = nil;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {


}

- (void)loadImageFromURL:(NSURL *)url completion:(void (^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (void)imageTappedWithImage:(UIImage *)image {
    self.expandedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.expandedImageView.image = image;
    self.expandedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.expandedImageView.backgroundColor = [UIColor blackColor];
    self.expandedImageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandedImageTapped:)];
    [self.expandedImageView addGestureRecognizer:tapGesture];

    [self.view addSubview:self.expandedImageView];
}

- (void)expandedImageTapped:(UITapGestureRecognizer *)gesture {
    [self.expandedImageView removeFromSuperview];
}

//MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_dataModels[0] isKindOfClass:[GitModel class]]) {
        GitModel *model = [[GitModel alloc] init];
        model = self.dataModels[indexPath.row];
        if (indexPath.row % 2 == 0) {
            LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LeftImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.login;
            cell.linkLabel.text = model.url;
            NSURL *imageURL = [NSURL URLWithString: model.avatarUrl];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;
                [cell setNeedsLayout];

            }];

            cell.delegate = self;
            return cell;

        } else {
            RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RightImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.login;
            cell.linkLabel.text = model.url;
            NSURL *imageURL = [NSURL URLWithString: model.avatarUrl];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;
                [cell setNeedsLayout];

            }];

            cell.delegate = self;
            return cell;
        }
    } else {
        TunesModel *model = [[TunesModel alloc] init];
        model = self.dataModels[indexPath.row];
        if (indexPath.row % 2 == 0) {
            LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LeftImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.trackName;
            cell.linkLabel.text = model.artistName;
            NSURL *imageURL = [NSURL URLWithString: model.artworkUrl100];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;
                [cell setNeedsLayout];

            }];

            cell.delegate = self;
            return cell;

        } else {
            RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RightImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.trackName;
            cell.linkLabel.text = model.artistName;
            NSURL *imageURL = [NSURL URLWithString: model.artworkUrl100];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;
                [cell setNeedsLayout];

            }];

            cell.delegate = self;
            return cell;
        }
    }

}

@end
