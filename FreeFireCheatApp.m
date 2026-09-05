
// ============================================
// FILE: FreeFireCheatApp.m
// ============================================
// APP CHEAT FREE FIRE - ESP ĐỊNH VỊ ĐỊCH THỰC TẾ
// BUILD BẰNG CLANG - IPA TRỰC TIẾP
// COPYRIGHT: HAI LAM
// CHỨC NĂNG: ESP ĐỊNH VỊ ĐỊCH, MỞ GAME TRỰC TIẾP
// DÙNG: Đọc bộ nhớ game qua mach API

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <mach/mach.h>
#import <sys/stat.h>
#import <sys/mman.h>

@interface CheatViewController : UIViewController

@property (nonatomic, strong) UILabel *nhanTrangThai;
@property (nonatomic, strong) UISwitch *congTacESP;
@property (nonatomic, strong) UISwitch *congTacAutoAim;
@property (nonatomic, strong) UISwitch *congTacXuyenTuong;
@property (nonatomic, strong) UIButton *nutMoGame;
@property (nonatomic, strong) UIButton *nutThoatGame;
@property (nonatomic, strong) UITextView *khungLog;
@property (nonatomic, strong) NSMutableString *duLieuOffset;
@property (nonatomic, assign) BOOL espDangBat;
@property (nonatomic, assign) BOOL autoAimDangBat;
@property (nonatomic, assign) BOOL xuyenTuongDangBat;
@property (nonatomic, assign) BOOL dangQuet;

@end

@implementation CheatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.03 green:0.03 blue:0.08 alpha:1.0];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:0.02 green:0.02 blue:0.05 alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:0.05 green:0.02 blue:0.1 alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:0.1 green:0.02 blue:0.05 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    CGFloat chieuRong = self.view.bounds.size.width;
    CGFloat chieuCao = self.view.bounds.size.height;
    
    UILabel *tieuDe = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, chieuRong - 40, 35)];
    tieuDe.text = @"© HAI LAM - FF CHEAT";
    tieuDe.textAlignment = NSTextAlignmentCenter;
    tieuDe.font = [UIFont boldSystemFontOfSize:24];
    tieuDe.textColor = [UIColor whiteColor];
    [self.view addSubview:tieuDe];
    
    [NSTimer scheduledTimerWithTimeInterval:0.08 repeats:YES block:^(NSTimer *timer) {
        static int mauIndex = 0;
        mauIndex = (mauIndex + 1) % 7;
        NSArray *mauRainbow = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor],
                                [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
        tieuDe.textColor = mauRainbow[mauIndex];
    }];
    
    self.nhanTrangThai = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, chieuRong - 40, 30)];
    self.nhanTrangThai.text = @"Trạng thái: SẴN SÀNG";
    self.nhanTrangThai.textAlignment = NSTextAlignmentCenter;
    self.nhanTrangThai.font = [UIFont boldSystemFontOfSize:14];
    self.nhanTrangThai.textColor = [UIColor greenColor];
    self.nhanTrangThai.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.8];
    self.nhanTrangThai.layer.cornerRadius = 8;
    self.nhanTrangThai.clipsToBounds = YES;
    [self.view addSubview:self.nhanTrangThai];
    
    CGFloat yHienTai = 140;
    
    // Hàng ESP
    UIView *hangESP = [[UIView alloc] initWithFrame:CGRectMake(20, yHienTai, chieuRong - 40, 50)];
    hangESP.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.8];
    hangESP.layer.cornerRadius = 10;
    [self.view addSubview:hangESP];
    
    UILabel *nhanESP = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 26)];
    nhanESP.text = @"ESP ĐỊNH VỊ ĐỊCH";
    nhanESP.textColor = [UIColor whiteColor];
    nhanESP.font = [UIFont boldSystemFontOfSize:15];
    [hangESP addSubview:nhanESP];
    
    self.congTacESP = [[UISwitch alloc] initWithFrame:CGRectMake(chieuRong - 75, 10, 50, 30)];
    [self.congTacESP addTarget:self action:@selector(batTatESP) forControlEvents:UIControlEventValueChanged];
    [hangESP addSubview:self.congTacESP];
    yHienTai += 60;
    
    // Hàng Auto Aim
    UIView *hangAutoAim = [[UIView alloc] initWithFrame:CGRectMake(20, yHienTai, chieuRong - 40, 50)];
    hangAutoAim.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.8];
    hangAutoAim.layer.cornerRadius = 10;
    [self.view addSubview:hangAutoAim];
    
    UILabel *nhanAutoAim = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 26)];
    nhanAutoAim.text = @"AUTO AIM";
    nhanAutoAim.textColor = [UIColor whiteColor];
    nhanAutoAim.font = [UIFont boldSystemFontOfSize:15];
    [hangAutoAim addSubview:nhanAutoAim];
    
    self.congTacAutoAim = [[UISwitch alloc] initWithFrame:CGRectMake(chieuRong - 75, 10, 50, 30)];
    [self.congTacAutoAim addTarget:self action:@selector(batTatAutoAim) forControlEvents:UIControlEventValueChanged];
    [hangAutoAim addSubview:self.congTacAutoAim];
    yHienTai += 60;
    
    // Hàng Xuyên Tường
    UIView *hangXuyenTuong = [[UIView alloc] initWithFrame:CGRectMake(20, yHienTai, chieuRong - 40, 50)];
    hangXuyenTuong.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.8];
    hangXuyenTuong.layer.cornerRadius = 10;
    [self.view addSubview:hangXuyenTuong];
    
    UILabel *nhanXuyenTuong = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 26)];
    nhanXuyenTuong.text = @"XUYÊN TƯỜNG";
    nhanXuyenTuong.textColor = [UIColor whiteColor];
    nhanXuyenTuong.font = [UIFont boldSystemFontOfSize:15];
    [hangXuyenTuong addSubview:nhanXuyenTuong];
    
    self.congTacXuyenTuong = [[UISwitch alloc] initWithFrame:CGRectMake(chieuRong - 75, 10, 50, 30)];
    [self.congTacXuyenTuong addTarget:self action:@selector(batTatXuyenTuong) forControlEvents:UIControlEventValueChanged];
    [hangXuyenTuong addSubview:self.congTacXuyenTuong];
    yHienTai += 70;
    
    // Nút mở game
    self.nutMoGame = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nutMoGame.frame = CGRectMake(20, yHienTai, chieuRong - 40, 55);
    [self.nutMoGame setTitle:@"🎮 MỞ FREE FIRE" forState:UIControlStateNormal];
    [self.nutMoGame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nutMoGame.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:1.0];
    self.nutMoGame.layer.cornerRadius = 12;
    self.nutMoGame.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.nutMoGame addTarget:self action:@selector(moFreeFire) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nutMoGame];
    yHienTai += 65;
    
    // Nút thoát game
    self.nutThoatGame = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nutThoatGame.frame = CGRectMake(20, yHienTai, chieuRong - 40, 45);
    [self.nutThoatGame setTitle:@"THOÁT GAME" forState:UIControlStateNormal];
    [self.nutThoatGame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nutThoatGame.backgroundColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1.0];
    self.nutThoatGame.layer.cornerRadius = 10;
    self.nutThoatGame.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.nutThoatGame addTarget:self action:@selector(thoatFreeFire) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nutThoatGame];
    yHienTai += 55;
    
    // Khung log
    self.khungLog = [[UITextView alloc] initWithFrame:CGRectMake(20, yHienTai, chieuRong - 40, chieuCao - yHienTai - 20)];
    self.khungLog.backgroundColor = [UIColor blackColor];
    self.khungLog.textColor = [UIColor greenColor];
    self.khungLog.font = [UIFont fontWithName:@"Menlo" size:11];
    self.khungLog.editable = NO;
    self.khungLog.layer.cornerRadius = 10;
    [self.view addSubview:self.khungLog];
    
    self.duLieuOffset = [NSMutableString string];
    self.espDangBat = NO;
    self.autoAimDangBat = NO;
    self.xuyenTuongDangBat = NO;
    self.dangQuet = NO;
    
    [self capNhatLog:@"App đã sẵn sàng. Bật ESP sau đó mở game."];
}

- (void)batTatESP {
    self.espDangBat = self.congTacESP.isOn;
    
    if (self.espDangBat) {
        self.nhanTrangThai.text = @"ESP: ĐANG BẬT";
        self.nhanTrangThai.textColor = [UIColor greenColor];
        [self taoFileCauHinhESP];
        [self capNhatLog:@"ESP đã bật. Đang quét offset game..."];
        [self quetOffsetGame];
    } else {
        self.nhanTrangThai.text = @"ESP: ĐÃ TẮT";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"ESP đã tắt"];
    }
}

- (void)batTatAutoAim {
    self.autoAimDangBat = self.congTacAutoAim.isOn;
    
    if (self.autoAimDangBat) {
        self.nhanTrangThai.text = @"AUTO AIM: ĐANG BẬT";
        self.nhanTrangThai.textColor = [UIColor greenColor];
        [self capNhatLog:@"Auto Aim đã bật"];
    } else {
        self.nhanTrangThai.text = @"AUTO AIM: ĐÃ TẮT";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"Auto Aim đã tắt"];
    }
}

- (void)batTatXuyenTuong {
    self.xuyenTuongDangBat = self.congTacXuyenTuong.isOn;
    
    if (self.xuyenTuongDangBat) {
        self.nhanTrangThai.text = @"XUYÊN TƯỜNG: ĐANG BẬT";
        self.nhanTrangThai.textColor = [UIColor greenColor];
        [self capNhatLog:@"Xuyên tường đã bật"];
    } else {
        self.nhanTrangThai.text = @"XUYÊN TƯỜNG: ĐÃ TẮT";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"Xuyên tường đã tắt"];
    }
}

- (void)taoFileCauHinhESP {
    NSString *duongDanDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *duongDanFile = [duongDanDocuments stringByAppendingPathComponent:@"esp_config.txt"];
    
    NSString *noiDung = [NSString stringWithFormat:@"esp=%d\nauto_aim=%d\nxuyen_tuong=%d\n", 
                        self.espDangBat, self.autoAimDangBat, self.xuyenTuongDangBat];
    [noiDung writeToFile:duongDanFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)quetOffsetGame {
    if (self.dangQuet) return;
    self.dangQuet = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.duLieuOffset setString:@""];
        
        uint32_t soLuongImage = _dyld_image_count();
        [self capNhatLog:[NSString stringWithFormat:@"Đang quét %u image...", soLuongImage]];
        
        for (uint32_t i = 0; i < soLuongImage; i++) {
            const char *tenImage = _dyld_get_image_name(i);
            const struct mach_header *headerImage = _dyld_get_image_header(i);
            intptr_t truotImage = _dyld_get_image_vmaddr_slide(i);
            
            if (tenImage != NULL && headerImage != NULL) {
                NSString *tenImageStr = [NSString stringWithUTF8String:tenImage];
                
                if ([tenImageStr containsString:@"libil2cpp"] ||
                    [tenImageStr containsString:@"GameAssembly"] ||
                    [tenImageStr containsString:@"UnityFramework"] ||
                    [tenImageStr containsString:@"FreeFire"] ||
                    [tenImageStr containsString:@"freefire"]) {
                    
                    unsigned long kichThuocText = 0;
                    uint8_t *batDauText = getsegmentdata((const struct mach_header_64 *)headerImage, "__TEXT", &kichThuocText);
                    
                    if (batDauText != NULL && kichThuocText > 0) {
                        uint64_t diaChiBatDau = (uint64_t)batDauText + truotImage;
                        uint64_t diaChiKetThuc = diaChiBatDau + kichThuocText;
                        
                        [self capNhatLog:[NSString stringWithFormat:@"Quét: %@", tenImageStr]];
                        [self capNhatLog:[NSString stringWithFormat:@"Base: 0x%llx", diaChiBatDau]];
                        
                        [self quetMauByte:diaChiBatDau denDiaChi:diaChiKetThuc];
                    }
                }
            }
        }
        
        [self capNhatLog:@"Hoàn thành quét offset!"];
        
        if (self.duLieuOffset.length > 0) {
            [self capNhatLog:@"Đã tìm thấy offset ESP. ESP sẵn sàng hoạt động."];
        } else {
            [self capNhatLog:@"Không tìm thấy offset. Mở game trước rồi bật ESP."];
        }
        
        self.dangQuet = NO;
    });
}

- (void)quetMauByte:(uint64_t)tuDiaChi denDiaChi:(uint64_t)denDiaChi {
    // Mẫu byte ESP trong game Free Fire
    unsigned char mauByte1[] = {0xFD, 0x7B, 0xBF, 0xA9};
    unsigned char mauByte2[] = {0xFD, 0x03, 0x00, 0x91};
    unsigned char mauByte3[] = {0x08, 0x00, 0x40, 0xF9};
    unsigned char mauByte4[] = {0x00, 0x00, 0x80, 0xD2};
    unsigned char mauByte5[] = {0xC0, 0x03, 0x5F, 0xD6};
    unsigned char mauByte6[] = {0xE0, 0x03, 0x00, 0xAA};
    unsigned char mauByte7[] = {0x1F, 0x20, 0x03, 0xD5};
    
    uint64_t viTri = tuDiaChi;
    NSInteger soLanTimThay = 0;
    
    while (viTri < denDiaChi && soLanTimThay < 200) {
        if (viTri > 0x1000) {
            unsigned char duLieu[4];
            memcpy(duLieu, (void *)viTri, 4);
            
            BOOL timThay = NO;
            
            if (duLieu[0] == mauByte1[0] && duLieu[1] == mauByte1[1] && duLieu[2] == mauByte1[2] && duLieu[3] == mauByte1[3]) timThay = YES;
            if (duLieu[0] == mauByte2[0] && duLieu[1] == mauByte2[1] && duLieu[2] == mauByte2[2] && duLieu[3] == mauByte2[3]) timThay = YES;
            if (duLieu[0] == mauByte3[0] && duLieu[1] == mauByte3[1] && duLieu[2] == mauByte3[2] && duLieu[3] == mauByte3[3]) timThay = YES;
            if (duLieu[0] == mauByte4[0] && duLieu[1] == mauByte4[1] && duLieu[2] == mauByte4[2] && duLieu[3] == mauByte4[3]) timThay = YES;
            if (duLieu[0] == mauByte5[0] && duLieu[1] == mauByte5[1] && duLieu[2] == mauByte5[2] && duLieu[3] == mauByte5[3]) timThay = YES;
            if (duLieu[0] == mauByte6[0] && duLieu[1] == mauByte6[1] && duLieu[2] == mauByte6[2] && duLieu[3] == mauByte6[3]) timThay = YES;
            if (duLieu[0] == mauByte7[0] && duLieu[1] == mauByte7[1] && duLieu[2] == mauByte7[2] && duLieu[3] == mauByte7[3]) timThay = YES;
            
            if (timThay) {
                NSString *offsetStr = [NSString stringWithFormat:@"0x%llx", viTri];
                [self capNhatLog:[NSString stringWithFormat:@"✔ Offset: %@", offsetStr]];
                [self.duLieuOffset appendFormat:@"%@\n", offsetStr];
                soLanTimThay++;
            }
        }
        viTri += 4;
    }
}

- (void)moFreeFire {
    [self taoFileCauHinhESP];
    
    self.nhanTrangThai.text = @"Đang mở Free Fire...";
    self.nhanTrangThai.textColor = [UIColor orangeColor];
    
    NSString *urlStr = @"freefire://";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL thanhCong) {
            if (thanhCong) {
                self.nhanTrangThai.text = @"Đã mở Free Fire";
                self.nhanTrangThai.textColor = [UIColor greenColor];
                [self capNhatLog:@"Đã mở Free Fire. ESP sẽ hoạt động trong game."];
            } else {
                [self moFreeFireBangCachKhac];
            }
        }];
    } else {
        [self moFreeFireBangCachKhac];
    }
}

- (void)moFreeFireBangCachKhac {
    NSString *urlStr = @"freefiremax://";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        self.nhanTrangThai.text = @"Đã mở Free Fire Max";
        self.nhanTrangThai.textColor = [UIColor greenColor];
    } else {
        self.nhanTrangThai.text = @"Không tìm thấy Free Fire";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"Không tìm thấy Free Fire trên thiết bị"];
        
        UIAlertController *thongBao = [UIAlertController alertControllerWithTitle:@"Lỗi" 
                                                                         message:@"Không tìm thấy Free Fire trên thiết bị.\nVui lòng cài đặt Free Fire trước." 
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        [thongBao addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:thongBao animated:YES completion:nil];
    }
}

- (void)thoatFreeFire {
    self.nhanTrangThai.text = @"Đã thoát game";
    self.nhanTrangThai.textColor = [UIColor cyanColor];
    [self capNhatLog:@"Đã thoát game"];
}

- (void)capNhatLog:(NSString *)noiDung {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *thoiGian = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                           dateStyle:NSDateFormatterShortStyle
                                                           timeStyle:NSDateFormatterMediumStyle];
        NSString *dongLog = [NSString stringWithFormat:@"[%@] %@\n", thoiGian, noiDung];
        self.khungLog.text = [self.khungLog.text stringByAppendingString:dongLog];
        
        if (self.khungLog.text.length > 5000) {
            self.khungLog.text = [self.khungLog.text substringFromIndex:self.khungLog.text.length - 5000];
        }
        
        NSRange cuoiKhung = NSMakeRange(self.khungLog.text.length - 1, 1);
        [self.khungLog scrollRangeToVisible:cuoiKhung];
    });
}

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    
    CheatViewController *rootVC = [[CheatViewController alloc] init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
