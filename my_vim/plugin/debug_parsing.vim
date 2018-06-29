function Debug_search()
    :vimgrep /mlme_\|connect_ind\|wpa_supplicant\|slsi_rx_debug\|fw debug/ **/*
endfunction
noremap <A-a> :call Debug_search()<CR>
