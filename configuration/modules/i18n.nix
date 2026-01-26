{ config, pkgs, lib, ... }:
let
  locales = {
    zhCN = "zh_CN.UTF-8";
    enUS = "en_US.UTF-8";
  };
  
  supportedLocalesList = [
    "${locales.zhCN}/UTF-8"
    "${locales.enUS}/UTF-8"
  ];
in
{
  i18n = {
    defaultLocale = locales.zhCN;
    extraLocaleSettings = {
      LC_ADDRESS = locales.zhCN;
      LC_IDENTIFICATION = locales.zhCN;
      LC_MEASUREMENT = locales.zhCN;
      LC_MONETARY = locales.zhCN;
      LC_NAME = locales.zhCN;
      LC_NUMERIC = locales.zhCN;
      LC_PAPER = locales.zhCN;
      LC_TELEPHONE = locales.zhCN;
      LC_TIME = locales.zhCN;
    };
    supportedLocales = supportedLocalesList;
  };
}