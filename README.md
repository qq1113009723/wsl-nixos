# NixOS WSL 开发环境

一个为 **Windows Subsystem for Linux 2 (WSL2)** 精心打造的**声明式 NixOS 开发环境**配置模板，开箱即用，零折腾。

## 🎯 核心特性

### 系统与包管理
- **NixOS 25.11** 稳定版本 + WSL2 深度集成
- **Nix Flakes** 现代化包管理与依赖锁定
- **Home Manager** 用户环境与 dotfiles 声明式管理
- **WSLg** 原生图形支持（无需 X11 额外配置）

### 桌面环境（二选一）
- **Niri** - 现代平铺式 Wayland 合成器，流畅动画、开发友好
- **Sway** - i3 风格的轻量级平铺窗口管理器
- **Waybar** - 顶部状态栏（CPU、内存、磁盘、时钟实时显示）
- **XWayland** 完整支持传统 X11 应用兼容

### 开发工具链
- **JeezyVim** - 开箱即用的 Neovim 开发环境
- **Rust** - 完整工具链（rustup、cargo-expand）
- **Language Servers** - Nix、HTML/CSS/JSON、YAML 等多语言支持
- **Git** - 私有仓库访问支持（GitHub/GitLab tokens）
- **Fish Shell** - 现代化友好的 Shell，开启高效终端体验

### 本地化与输入法
- **中文优先** - 默认时区（Asia/Shanghai）、区域设置
- **Fcitx5 + Rime** - 高效输入法框架
- **多字体支持** - JetBrains Mono、Noto CJK Sans/Serif 等

### 终端增强
- **Starship** - 美观智能的命令行提示符
- **Fzf** - 模糊搜索增强（命令、文件、历史）
- **Zoxide** - 智能目录跳转
- **Lsd** - 彩色 ls 替代品
- **Direnv** - 自动项目环境加载

### 便捷功能
- **双向剪贴板同步** - Linux ↔ Windows 无缝协作
- **WSL 互操作** - 直接调用 Windows 程序
- **私有仓库认证** - 支持 GitHub/GitLab token 配置

---

## 📁 项目结构

```
configuration/
├── flake.nix              # 项目依赖与输入源声明
├── wsl.nix                # WSL 系统配置
├── home.nix               # 用户环境与包管理
├── secrets.json           # 敏感信息（token 等）
├── modules/               # 系统级模块
│   ├── default.nix        # 模块导入入口
│   ├── font.nix           # 字体配置
│   ├── i18n.nix           # 国际化设置
│   ├── desktop.nix        # 桌面环境入口
│   ├── niri.nix           # Niri 图形合成器
│   ├── sway.nix           # Sway 平铺管理器
│   ├── fcitx5.nix         # 输入法框架
│   └── patch/             # 上游补丁
└── home-modules/          # Home Manager 用户配置
    ├── niri-cfg.nix       # Niri 配置文件生成
    ├── sway-cfg.nix       # Sway 配置文件生成
    ├── waybar-cfg.nix     # 状态栏配置
    └── scripts/           # 启动脚本
        ├── start-niri.sh
        ├── start-sway.sh
        └── wsl-clipboard-sync.sh
```

---

## 🚀 快速开始

### 1. 克隆配置
```bash
git clone <repo> ~/configuration
cd ~/configuration
```

### 2. 个性化配置
编辑以下文件中的 `FIXME:` 注释部分：
- [flake.nix](#flake.nix) - 修改用户名
- [wsl.nix](#wsl.nix) - 时区、Shell、SSH 等
- [home.nix](#home.nix) - 添加/移除包、Git 配置
- [secrets.json](#secrets.json) - GitHub/GitLab token（可选）

### 3. 应用配置
```bash
sudo nixos-rebuild switch --flake ~/configuration
```

### 4. 启动桌面环境
```bash
start-niri    # 或 start-sway
```

---

## ⚠️ 已知问题与解决方案

### Niri 双鼠标指针问题

**现象**：启动 Niri 时出现两个光标指针。

**根本原因**：WSLg 的鼠标指针与 Niri 的指针渲染冲突，Sway 可以正确初始化鼠标状态，Niri 启动前需要这个初始化。

**解决步骤**：
1. 执行启动 Sway：
   ```bash
   start-sway
   ```
2. 按 `Alt+Shift+E` 退出 Sway
3. 再次启动 Niri：
   ```bash
   start-niri
   ```

**原理**：Sway 的启动过程会正确初始化 WSLg 的鼠标指针状态，之后 Niri 能够正确识别并只显示一个指针。

---

## 🔧 常见定制

### 添加新包
在 [home.nix](#home.nix) 中的 `stable-packages` 或 `unstable-packages` 列表添加：
```nix
stable-packages = with pkgs; [
  your-package-here
  # 使用 https://search.nixos.org 查找包名
];
```

### 修改系统设置
编辑 [wsl.nix](#wsl.nix)：
- 时区：`time.timeZone = "Asia/Shanghai"`
- 用户 Shell：`shell = pkgs.fish`
- Docker：`virtualisation.docker.enable`

### 更新依赖版本
```bash
cd ~/configuration
nix flake update
sudo nixos-rebuild switch --flake .
```

---

## 📚 技术栈

| 组件 | 工具 |
|------|------|
| **包管理** | Nix Flakes |
| **Shell** | Fish |
| **编辑器** | JeezyVim (Neovim) |
| **窗口管理** | Niri / Sway |
| **输入法** | Fcitx5 + Rime |
| **终端** | Kitty / Alacritty |
| **提示符** | Starship |
| **系统** | NixOS 25.11 on WSL2 |

---

## 💡 提示

- 所有 `FIXME:` 注释都标记了需要个性化的配置点
- 使用 `nixos-rebuild switch` 应用配置（无需重启 WSL）
- 查看 [https://search.nixos.org](https://search.nixos.org/packages) 查找包
- 运行 `nix flake update` 更新所有依赖到最新版本

---

**享受无缝的声明式开发环境！**