keyboardSolution
================

ios 提供一个管理键盘的方案

监听键盘出现和消失的notification，为self.view添加一个手势，该手势结束编辑状态，放下键盘。
提供一个protocol，protocol有三个属性，来控制键盘，属性均为runtime时实现，这些操作都放在一个category中，
使得用户只要引用这个category，然后注册键盘事件和卸载键盘事件就能方便应用。
