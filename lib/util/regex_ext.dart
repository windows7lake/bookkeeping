class RegexExt {
  /// 校验函数
  static bool verify(String content, String regex) {
    if (content == null || content.isEmpty) return false;
    return RegExp(regex).hasMatch(content);
  }

  /// 是否全部为数字
  static bool isNumber(String content) {
    return verify(content, r"^\d*$");
  }

  /// 是否全部为汉字
  static bool isChinese(String content) {
    return verify(content, r"^[\u4e00-\u9fa5]*$");
  }

  /// 是否为汉字加字母
  static bool isChineseAndEnglish(String content) {
    return verify(content, r"^[a-zA-Z\u4e00-\u9fa5]+$");
  }

  /// 是否为URL
  static bool isUrl(String content) {
    return verify(content,
        r"^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");
  }

  /// 是否存在特殊字符
  static bool isSpecialChar(String content) {
    return verify(content, r"[^\w\s]+");
  }

  /// 是否为金额（精确到小数点后两位）
  static bool isMoney(String content) {
    return verify(content, r"^(([1-9]{1}\d*)|(0{1}))(\.\d{0,2})?$");
  }
}
