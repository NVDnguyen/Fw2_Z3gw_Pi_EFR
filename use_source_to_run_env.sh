#!/bin/bash
if [ -f "myenv/bin/activate" ]; then
    source myenv/bin/activate
    echo "Môi trường ảo đã được kích hoạt."
else
    echo "Đường dẫn tới môi trường ảo không tồn tại."
fi

