class StringExt {
  /// 判断是否为null或者空字符串
  static bool isNullOrEmpty(String content) {
    if (content == null) return true;
    if (content.length <= 0) return true;
    return false;
  }

  /// ------------------- 增加 -------------------

  /// 添加字符串至末尾
  static String addEnd(String content, String sub, {String separator = ""}) {
    if (isNullOrEmpty(content)) return "";
    if (isNullOrEmpty(sub)) return "";
    return (content += (separator + sub));
  }

  /// 添加字符串至开头
  static String addStart(String content, String sub, {String separator = ""}) {
    if (isNullOrEmpty(content)) return "";
    if (isNullOrEmpty(sub)) return "";
    return (content = sub + separator + content);
  }

  /// ------------------- 删除 -------------------

  /// 删除一个范围的子字符串
  static String delRange(String content, int index, {int end}) {
    if (isNullOrEmpty(content)) return "";
    if (content.length <= index) return content;
    if (end == null) end = content.length - 1;
    if (content.length <= end) return content;
    return content.replaceRange(index, end, "");
  }

  /// 删除一个子字符串
  static String delSub(String content, String sub,
      {bool isAll = true, int index = 0}) {
    if (isNullOrEmpty(content)) return "";
    if (isNullOrEmpty(sub)) return "";
    String result = "";
    if (isAll)
      result = content.replaceAll(sub, "");
    else
      result = content.replaceFirst(sub, "", index);
    return result;
  }

  /// ------------------- 替换 -------------------

  static String replace(String content, String sub, String to,
      {bool isAll = true, int index = 0}) {
    if (isNullOrEmpty(content)) return "";
    if (isNullOrEmpty(sub)) return "";
    if (to.length <= 0) return content;
    String result = "";
    if (isAll)
      result = content.replaceAll(sub, to);
    else
      result = content.replaceFirst(sub, to, index);
    return result;
  }

  /// ------------------- 查找 -------------------

  /// 是否包含子字符串
  static bool isContains(String content, String sub) {
    if (isNullOrEmpty(content)) return false;
    if (isNullOrEmpty(sub)) return false;
    return content.contains(sub);
  }

  /// 是否以子字符串
  static bool isStart(String content, String sub, {int index = 0}) {
    if (isNullOrEmpty(content)) return false;
    if (isNullOrEmpty(sub)) return false;
    return content.startsWith(sub, index);
  }

  /// 是否以子字符串结尾
  static bool isEnd(String content, String sub) {
    if (isNullOrEmpty(content)) return false;
    if (isNullOrEmpty(sub)) return false;
    return content.endsWith(sub);
  }

  /// 查找子串 找到返回第一个字符的下标，找不到返回-1
  static int indexFind(String content, String sub,
      {int index = 0, bool reverse = false}) {
    if (isNullOrEmpty(content)) return -1;
    if (isNullOrEmpty(sub)) return -1;
    if (reverse) // 倒序
      return content.indexOf(sub, index);
    else // 正序
      return content.lastIndexOf(sub, index);
  }

  /// 查找子串
  static String subFind(String content, int start, {int end}) {
    if (isNullOrEmpty(content)) return "";
    if (end == null) end = content.length - 1;
    return content.substring(start, end);
  }
}
