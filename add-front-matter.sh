#!/bin/bash

# 检查是否提供了文件名参数
if [ $# -eq 0 ]; then
    echo "用法: $0 <markdown_file> [title]"
    echo "示例: $0 my-article.md \"我的文章标题\""
    exit 1
fi

# 获取文件名和标题
MARKDOWN_FILE="$1"
TITLE="$2"

# 如果没有提供标题，则使用文件名作为标题
if [ -z "$TITLE" ]; then
    BASENAME=$(basename "$MARKDOWN_FILE" .md)
    TITLE=$(echo "$BASENAME" | sed -E 's/[-_]/ /g' | sed -E 's/\b(.)/\U\1/g')
fi

# 检查文件是否存在
if [ ! -f "$MARKDOWN_FILE" ]; then
    echo "错误: 文件 '$MARKDOWN_FILE' 不存在"
    exit 1
fi

# 创建临时文件
TEMP_FILE=$(mktemp)

# 添加YAML头部
cat > "$TEMP_FILE" << EOF
---
title: "$TITLE"
date: $(date -Iseconds)
draft: false
---

EOF

# 添加原始内容
cat "$MARKDOWN_FILE" >> "$TEMP_FILE"

# 替换原文件
mv "$TEMP_FILE" "$MARKDOWN_FILE"

echo "已为 '$MARKDOWN_FILE' 添加YAML头部"