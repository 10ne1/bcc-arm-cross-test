#!/usr/bin/env python
from bcc import BPF
import time

csrc = """
#include <uapi/linux/bpf.h>
#include <uapi/linux/ptrace.h>

#define fmt "file %s\\n"

int kprobe__do_sys_open(struct pt_regs *ctx)
{
        char file_name[256];

        bpf_probe_read(file_name, sizeof(file_name), (void*)PT_REGS_PARM2(ctx));
        bpf_trace_printk(fmt, sizeof(fmt), &file_name);

        return 0;
}
"""

b = BPF(text=csrc, debug=0xf)
b.attach_kprobe(event="do_sys_open", fn_name="kprobe__do_sys_open")
while True:
    time.sleep(1)
