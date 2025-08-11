#!/bin/bash

# 批量为目录中的Markdown文件添加YAML头部
CONTENT_DIR="content/managerial"

# 检查目录是否存在
if [ ! -d "$CONTENT_DIR" ]; then
    echo "错误: 目录 '$CONTENT_DIR' 不存在"
    exit 1
fi

# 处理目录中的所有.md文件（不包括已带有头部的）
for file in "$CONTENT_DIR"/*.md; do
    # 检查文件是否存在且不是目录
    if [ -f "$file" ]; then
        # 检查是否已经有YAML头部（简单检查前几行是否包含---）
        if ! head -n 3 "$file" | grep -q "^---"; then
            filename=$(basename "$file")
            echo "正在处理: $filename"
            
            # 创建临时文件
            temp_file=$(mktemp)
            
            # 添加YAML头部
            cat > "$temp_file" << EOF
---
title: "$(echo "$filename" | sed 's/\.md$//' | sed -E 's/[-_]/ /g' | sed -E 's/\b(.)/\U\1/g')"
date: $(date -Iseconds)
draft: false
---

EOF
            
            # 添加原始内容
            cat "$file" >> "$temp_file"
            
            # 替换原文件
            mv "$temp_file" "$file"
            
            echo "已为 '$filename' 添加YAML头部"
        else
            echo "跳过 '$filename'（已包含YAML头部）"
        fi
    fi
done

echo "处理完成！"