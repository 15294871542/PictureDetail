//
//  ViewController.m
//  PictureDetail
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ViewController.h"
#import "PictureView.h"
#import "MyTableViewCell.h"

#define DeviceWidth     [UIScreen mainScreen].bounds.size.width
#define DeviceHeight    [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,CYTableViewDelegate,complentDelegate>

{
    NSArray * dataArray;//数据数组
    NSArray * titleArray;//标题数组
    
    UIImageView * creatImageView;//新创建的imageview
}

@property (strong,nonatomic) PictureView * pictureView;//图片背景视图
@property (strong,nonatomic) UITableView * myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self creatData];//创建一些假数据
    [self creatTableView];//创建tableView
    
    //创建图片点击的详情视图
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    self.pictureView=[[PictureView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth, window.frame.size.height)];
    self.pictureView.delegate=self;
    [window addSubview:self.pictureView];
    
}

//创建tableView
-(void)creatTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    self.myTableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    [self.view addSubview:self.myTableView];
}

#pragma mark - tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
    bgView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 100, 30)];
    lable.text=titleArray[section];
    lable.font=[UIFont systemFontOfSize:14];
    [bgView addSubview:lable];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array=dataArray[indexPath.section];
    if ((array.count-1)/3==0 && (array.count-1)%3==0 && array.count!=1) {
        return 10+((DeviceWidth-50)/3+10)*((array.count-1)/3);
    } else {
        return 10+((DeviceWidth-50)/3+10)*((array.count-1)/3+1);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"mytableviewcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.picArray=dataArray[indexPath.section];
    cell.index=indexPath.section;
    cell.delegate=self;
    
    return cell;
}

//图片点击事件
-(void)selectedRow:(NSInteger)row item:(MyCollectionViewCell *)item index:(NSInteger)index
{
    //获取当前点击的图片并创建一模一样的一个
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    creatImageView = [[UIImageView alloc] init];
    CGRect new_rect = [item.theImageView convertRect:item.theImageView.bounds toView:window];
    creatImageView.image = item.theImageView.image;
    creatImageView.frame = new_rect;
    [window addSubview:creatImageView];
    
    //更新图片背景视图
    self.pictureView.frame=CGRectMake(0, 0, DeviceWidth, window.frame.size.height);
    
    //关闭
    __weak typeof (self) weakSelf = self;
    __weak typeof (creatImageView) weakImageView = creatImageView;
    self.pictureView.backBlock = ^ (NSInteger theIndex) {
        
        weakSelf.pictureView.frame=CGRectMake(DeviceWidth, 0, DeviceWidth, window.frame.size.height);
        
        //获取当前图片所在区行
        MyTableViewCell * cell=(MyTableViewCell *)[weakSelf.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        MyCollectionViewCell * theCell=(MyCollectionViewCell *)[cell.myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:theIndex inSection:0]];
        CGRect theRect = [theCell.theImageView convertRect:theCell.theImageView.bounds toView:window];
        weakImageView.image = theCell.theImageView.image;
        
        //放大新创建的图片
        [UIView animateWithDuration:0.3 animations:^{
            
            weakImageView.frame = theRect;
            
        } completion:^(BOOL finished) {
            
            [weakSelf.pictureView.picScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [weakImageView removeFromSuperview];
            
        }];
        
    };
    
    float imageHeight=creatImageView.image.size.height/creatImageView.image.size.width*DeviceWidth;
    
    //放大新创建的图片
    [UIView animateWithDuration:0.3 animations:^{
        
        creatImageView.bounds = CGRectMake(0, 0, DeviceWidth, imageHeight);
        creatImageView.center=CGPointMake(DeviceWidth/2, window.frame.size.height/2);
        
    } completion:^(BOOL finished) {
        
        //要展示的图片数组
        self.pictureView.picArray=dataArray[index];
        self.pictureView.currentIndex=row;
        
    }];
}

-(void)complent
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    [window bringSubviewToFront:self.pictureView];
}


//创建一些假数据
-(void)creatData
{
    titleArray = @[@"风景",@"人物",@"动漫",@"植物",@"星空"];
    dataArray = @[@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657909398&di=52ae204c30eff656efdd49e9de626c20&imgtype=0&src=http%3A%2F%2Ftupian.enterdesk.com%2F2013%2Fmxy%2F12%2F10%2F15%2F10.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657909397&di=68d850382631a0d5e8b4a20ab5bd08e7&imgtype=0&src=http%3A%2F%2Fpic38.nipic.com%2F20140228%2F8821914_204428973000_2.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657909397&di=c6990b515cbe5eb537ac3dd742529826&imgtype=0&src=http%3A%2F%2Fpic23.nipic.com%2F20120911%2F10698203_203445892000_2.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657909397&di=c60c0c7652545bd3ddf5898f8bf5abc8&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2Fuploadfilepic%2Fsheying%2F2009-01-17%2F58PIC_tunyuntuwu_20090117459dd9532ff590a2.jpg"],@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657960025&di=2f005225953ea32c6adf6187e74aec5b&imgtype=0&src=http%3A%2F%2Fwww.wsxz.cn%2Fylzx%2Fuploads%2Fallimg%2F170504%2F00523Q211-0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657960025&di=43e431bdc82d52276b9529485f7c0ca7&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201512%2F03%2F20151203160917_sBJAC.thumb.700_0.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657960024&di=5ae1efd7e0cef664527ec25d5f4d1d1f&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201507%2F30%2F20150730145412_vCm5A.thumb.700_0.jpeg"],@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657986177&di=a74d1c4f8333732d483bebd732d5ad24&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F1f178a82b9014a90e7eb9d17ac773912b21bee47.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657986177&di=41e75a5683f46ebee0bde502320a77aa&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd788d43f8794a4c22fe6ab9408f41bd5ac6e3943.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657986176&di=d70a9cc9ab7ae2d0fca545598cb8bd45&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3Dca1fd2eb054f78f0805e92f74c012663%2Fbd3eb13533fa828b97ecd15cfb1f4134960a5a45.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657986175&di=553b0c80e91e3ff2f90f4cbc39deab95&imgtype=0&src=http%3A%2F%2Fwww.bz55.com%2Fuploads%2Fallimg%2F120913%2F1-120913151Z6.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657986175&di=6b43fff70ccbffcbca25e6d7be36bee5&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3D65d49821a70f4bfb8c859650367f54c6%2Fcdbf6c81800a19d85be873bb30fa828ba71e46a1.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496657986174&di=6781c372030718c93b06d74b10757f3f&imgtype=0&src=http%3A%2F%2Fpic5.qiyipic.com%2Fcommon%2F20130524%2F7dc5679567cd4243a0a41e5bf626ad77.jpg%3Fsrc%3Dfocustat_4_20130527_7"],@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032729&di=1d54a4ea4e796047088a0d70cc2ad80b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fblog%2F201401%2F13%2F20140113142644_S3RPP.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032728&di=26ff025dd22bd2ef9a9d9a6327bae308&imgtype=0&src=http%3A%2F%2Fphotocdn.sohu.com%2F20160223%2Fmp60107766_1456203432430_4.png",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032728&di=8fea902036be6c3bcffe9779a19fc9b8&imgtype=0&src=http%3A%2F%2Fstaticqn.qizuang.com%2Fimg%2F20170420%2F58f86280562cd-s3.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032727&di=68ce156196a56cbedc2eb46e0c42f5ec&imgtype=0&src=http%3A%2F%2Fcdn.duitang.com%2Fuploads%2Fitem%2F201508%2F19%2F20150819083157_JGzH4.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032727&di=968c8fb3a279ce055e782a67d9c2569f&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201601%2F09%2F20160109113714_PyezY.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032727&di=d507303469c5305e5c1d8c3afdfa851a&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201504%2F26%2F201504262129_xnRuW.jpeg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032726&di=4e4b5f9ff4cb21ce1f15e82a02a000b5&imgtype=0&src=http%3A%2F%2Fstaticqn.qizuang.com%2Fimg%2F20170518%2F591d5ebd2ef01-s3.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032726&di=0b25eedfdd7fabbc0d6ff4cebce6fddf&imgtype=0&src=http%3A%2F%2Fwww.cd-pa.com%2Fbbs%2Fdata%2Fattachment%2Fforum%2F201606%2F08%2F202531w8zvcfpfweefve29.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658032724&di=2868ebb85f40338939a924780765e45d&imgtype=0&src=http%3A%2F%2Fwww.cqtsmm.com%2Fdata%2Fimages%2Fproduct%2F20151223165531_496.jpg"],@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496658091448&di=3d1cedf78825be22c7a460bb4c4f9aee&imgtype=0&src=http%3A%2F%2Fpic36.photophoto.cn%2F20150707%2F0047045135399298_b.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
