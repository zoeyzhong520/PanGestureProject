# PanGestureProject
拖动手势&amp;图片放大

练习pan拖拽手势的使用，根据拖拽偏移量计算一些相关数值以实现实时的动画效果，同时也复习了动画的简单使用
将imageView嵌套在ScrollView中，以此实现图片放大的效果

有两个小知识点需要注意：

实现父视图半透明而子试图不透明的效果，可以通过设置
view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
来实现
如果要对UIImageView添加点击、拖拽等手势，需要先设置
imageView.isUserInteractionEnabled = true


