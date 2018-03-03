#!/bin/bash
#监控文件操作并记录日志
watchDir=""
outputFile=""
inotifywait -rde move,moved_to,moved_from,delete,delete_self --outfile ${outputFile} --format "%T %w%f--%:e" --timefmt "%Y-%m%d:%H:%M:%S" ${watchDir}