# ZQSystemPhoto
访问系统照片的组件

# CocoaPods

``` 
source 'https://github.com/caozhiqiang1002/CZQSpecs.git'

target 'PROJECT_NAME' do
  pod 'ZQSystemPhoto'
end
```

# Use

### 导入头文件

```
  #import <ZQSystemPhoto/ZQSystemPhotoAPI.h>
```

### 调用接口

```
  
  <!-- 默认参数配置 -->
  [[ZQSystemPhotoAPI sharedAPI] showSystemPhoto:self 
                                        handler:^(NSArray<NSDictionary *> *imagesInfo) {
                                            NSLog(@"%@ %@", imagesInfo);
                                        }];
  
  
  <!-- 自定义参数配置 -->
  ZQPhotoItemConfig *config = [ZQPhotoItemConfig createObjectWithCount:0
                                                               itemSpace:0
                                                            sectionSpace:0
                                                        selectedMaxCount:0];
    
  [[ZQSystemPhotoAPI sharedAPI] showSystemPhoto:self
                                         config:config
                                        handler:^(NSArray<NSDictionary *> *imagesInfo) {
                                            NSLog(@"%@", imagesInfo);
                                        }];
```
