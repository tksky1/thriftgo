# Copyright 2023 CloudWeGo Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/bin/bash

set -e

basic_file_dir="test_cases"
basic_files=($(find "$basic_file_dir" -name "*.thrift" -type f -print))
basic_total=${#basic_files[@]}

rm -rf trimmer_test
mkdir trimmer_test

cd trimmer_test
go mod init trimmer

for i in "${!basic_files[@]}"; do
    echo "Test [$(($i+1))/$basic_total]:   ${basic_files[$i]}"
    rm -rf gen-go

    cd ..
    go run ../../. -g go:trim_idl,package_prefix=trimmer/gen-go -o trimmer_test/gen-go -r ${basic_files[$i]}
    cd trimmer_test

    go mod edit -replace=github.com/apache/thrift=github.com/apache/thrift@v0.13.0
    go mod tidy
    go build ./...
done

echo "success"