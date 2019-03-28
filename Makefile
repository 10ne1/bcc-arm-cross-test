SHELL=/bin/bash -o pipefail
LINUX_SRC_ROOT="/home/adi/workspace/linux"
FILENAME="open-example"

ebpf-build: clean go-build
	clang \
		--target=armv7a-linux-gnueabihf \
		-D__KERNEL__ -fno-stack-protector -Wno-int-conversion \
		-O2 -emit-llvm -c "src/${FILENAME}.c" \
		-I ${LINUX_SRC_ROOT}/include \
		-I ${LINUX_SRC_ROOT}/tools/testing/selftests \
		-I ${LINUX_SRC_ROOT}/arch/arm/include \
		-o - | llc -march=bpf -filetype=obj -o "${FILENAME}.o"

go-build:
	GOOS=linux GOARCH=arm CGO_ENABLED=1 CC=arm-linux-gnueabihf-gcc \
		go build -ldflags="-s -w" -o ${FILENAME} src/${FILENAME}.go

clean:
	rm -f ${FILENAME}*
