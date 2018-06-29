function! Add_wlan()
    if has('win32')
        cs add H:\repos\scsc-fw-dev\fw\wlan\cscope.out
    else
        cs add /home/kshah/repos/scsc-fw-dev/fw/wlan/cscope.out
    endif
endfunction
noremap \wl :call Add_wlan()<CR>

function! Add_regs()
    if has('win32')
        cs add H:\repos\scsc-fw-dev\hardware\regs\cscope.out
    else
        cs add /home/kshah/repos/scsc-fw-dev/hardware/regs/cscope.out
    endif
endfunction
noremap \rg :call Add_regs()<CR>

function! Remove_1()
    cs kill 1
endfunction
noremap \r1 :call Remove_1()<CR>

function! Remove_2()
    cs kill 2
endfunction
noremap \r2 :call Remove_2()<CR>
