"------------------------
" 基本設定
"------------------------

"色設定
syntax on
colorscheme mycolor

"タブの設定
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set autoindent

"検索
set incsearch
set ignorecase
set smartcase
set nohlsearch

"行数表示
set number

"対応する括弧表示しない
set noshowmatch

"コマンドラインの高さ
set cmdheight=1

"バックスペースで何でも消したい
set backspace=indent,eol,start

"タブバー常に表示
set showtabline=2 

"タブ文字可視化
set list
set listchars=tab:>\ 

"swapファイル作らない
set noswapfile

"backupしない
set nobackup

"他で編集されたら読み込み直す
set autoread

"ステータスラインの表示設定
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'}%=%l,%c%V%8P

"exモードの補完
set wildmenu
set wildmode=list:longest,full

"補完
set complete=.,w,b,u,k
"set completeopt=menu,preview,longest
set pumheight=20

"ftplugin有効
filetype plugin on

" 新規windowを右側に開く
nnoremap <C-w>v :<C-u>belowright vnew<CR>

" set filetype
"nnoremap <Space>sp :<C-u>set filetype=perl<CR>
"nnoremap <Space>sh :<C-u>set filetype=php<CR>
"nnoremap <Space>sj :<C-u>set filetype=javascript<CR>

"windwowの高さ、幅
"set winheight=100
set winwidth=78

" 下に開く
set splitbelow

"-----------------------
" autocmd
"------------------------

augroup MyAutoCmd
  autocmd!
augroup END

"mtとttをhtmlに
autocmd MyAutoCmd BufNewFile,BufReadPost *.mt,*.tt,*.ejs set filetype=html

"psgiとtはperl
autocmd MyAutoCmd BufNewFile,BufReadPost *.psgi,*.t set filetype=perl

"ruをrubyに
autocmd MyAutoCmd BufNewFile,BufReadPost *.ru set filetype=ruby

"asをactionscriptに
autocmd MyAutoCmd BufNewFile,BufReadPost *.as set filetype=actionscript

"markdownのfiletypeをセット
autocmd MyAutoCmd BufNewFile,BufReadPost *.md,*.txt set filetype=md

"なぜかnoexpandtabになることがあるので
"autocmd MyAutoCmd BufNewFile,BufReadPost * set expandtab

"ディレクト自動移動
autocmd MyAutoCmd BufNewFile,BufReadPost *
\ execute ":lcd " . substitute(expand("%:p:h"), ' ', '\\ ', 'g')

" カレントバッファのファイルを再読み込み。filetypeがvimかsnippetsのときだけ。
nnoremap <silent> <Space>r :<C-u>
\ if &ft == 'vim' <Bar>
\     source % <Bar>
\ elseif &ft == 'snippet' <Bar>
\     call SnipMateReload() <Bar>
\ endif<CR>

" s:snippetsを外からunletできないので以下の関数をplugin/snipMate.vimに書く
"fun! ResetSnippet(ft)
"	if has_key(g:did_ft, ft) | unlet g:did_ft[ft] | endif
"	if has_key(s:snippets, ft) | unlet s:snippets[ft] | endif
"endif
function! SnipMateReload()
    if &ft == 'snippet'
        let ft = substitute(expand('%'), '.snippets', '', '')
        call ResetSnippet(ft)
        silent! call GetSnippets(g:snippets_dir, ft)
    endif
endfunction

"grepとかmakeのあとにエラーがあればQuickFixだす
"autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep
"    \ if len(getqflist()) != 0 | copen | endif

" オレオレgrep
command! -complete=file -nargs=+ Grep call s:grep(<q-args>)
function! s:grep(args)
    execute 'vimgrep' '/' . a:args . '/j **/*'
    if len(getqflist()) != 0 | copen | endif
endfunction

"-----------------------
" 文字コードとかの設定
"------------------------
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"改行コード
set fileformats=unix,dos,mac

" タブラインの設定
" from :help setting-tabline
set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " 強調表示グループの選択
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " タブページ番号の設定 (マウスクリック用)
    let s .= '%' . (i + 1) . 'T'

    " ラベルは MyTabLabel() で作成する
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセッ
  " トする
  let s .= '%#TabLineFill#%T'

  " カレントタブページを閉じるボタンのラベルを右添えで作成
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return expand("#".buflist[winnr - 1].":t")
endfunction

" 開いてるファイルにのディレクトリに移動
command! -nargs=0 CD :execute 'lcd ' . expand("%:p:h")

"------------------------
" キーバインド
"------------------------
"leader設定
let mapleader = ','

"; to :
nnoremap ; :

"エスケープキー
inoremap <C-j> <esc>
vnoremap <C-j> <esc>

"保存
nnoremap <Space>w :<C-u>write<CR>

"終了
nnoremap <Space>q :<C-u>quit<CR>

"上下移動
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"改行
"nnoremap <CR> o<ESC>
"nnoremap <S-CR> O<ESC>

"単語検索
nnoremap * g*
nnoremap # g#

"サーチハイライトトグル
nnoremap <silent> <Space>th :set hlsearch!<CR>

"タブ切り替え
nnoremap <C-l> gt
nnoremap <C-h> gT

"タブ文字（\t）を入力
inoremap <C-Tab> <C-v><Tab>

"ビジュアルモードで選択して検索
vnoremap * "zy:let @/ = @z<CR>n

"ビジュアルモードで選択して置換。とりあえず/だけエスケープしとく
vnoremap <C-s> "zy:%s/<C-r>=escape(@z,'/')<CR>/

"入力モードで削除
inoremap <C-d> <Del>
inoremap <C-h> <BackSpace>

"コマンドモードでemacsチックに
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BackSpace>

"コマンドモードの履歴
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"コマンドモードでペースト
cnoremap <C-y> <C-r>"

"文字コード変更して再読み込み
nnoremap <silent> eu :<C-u>e ++enc=utf-8<CR>
nnoremap <silent> ee :<C-u>e ++enc=euc-jp<CR>
nnoremap <silent> es :<C-u>e ++enc=cp932<CR>

"pasteモードトグル
nnoremap <Space>tp :<C-u>set paste!<CR>


"help
nnoremap <Space>h :<C-u>vert bel h<Space>

"git
nnoremap <Space>g :<C-u>!git<Space>

"行末まで削除
inoremap <C-k> <C-o>D

"補完候補があってもEnterは改行
inoremap <expr> <CR> pumvisible() ? "\<C-e>\<CR>" : "\<CR>"

"スクロール
nnoremap <C-e> <C-e>j
nnoremap <C-y> <C-y>k
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

"function! SmoothScroll(action)
"   let l:h=winheight(0) / 6
"   let l:i=0
"   while l:i < l:h
"      let l:i = l:i + 1
"      if a:action=="down"
"         execute "normal 3\<C-e>"
"      elseif a:action=="up"
"         execute "normal 3\<C-y>"
"      end
"      redraw
"      sleep 1m
"   endwhile 
"endfunction
"
"nnoremap <silent> <C-d> :<C-u>call SmoothScroll("down")<CR>
"nnoremap <silent> <C-u> :<C-u>call SmoothScroll("up")<CR>

" <C-u>とかのundo
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>

" \ って遠いよね
inoremap <C-]> \
cnoremap <C-]> \

" 行末までyank
nnoremap Y y$

" text object
"onoremap aa  a>
"vnoremap aa  a>
"onoremap ia  i>
"vnoremap ia  i>
"
"onoremap ar  a]
"vnoremap ar  a]
"onoremap ir  i]
"vnoremap ir  i]
 
nnoremap gc `[v`]
onoremap gc :normal gc<CR>

onoremap <silent> q
\      :for i in range(v:count1)
\ <Bar>   call search('.\&\(\k\<Bar>\_s\)\@!', 'W')
\ <Bar> endfor<CR>

" コピペ
nnoremap y "xy
vnoremap y "xy
nnoremap d "xd
vnoremap d "xd
nnoremap c "xc
vnoremap c "xc
vnoremap p "xp
nnoremap <C-p> :<C-u>set opfunc=OverridePaste<CR>g@
nnoremap <C-p><C-p> :<C-u>set opfunc=OverridePaste<CR>g@g@

function! OverridePaste(type, ...)
    if a:0
        silent execute "normal! `<" . a:type . "`>\"xp"
    elseif a:type == 'line'
        silent execute "normal! '[V']\"xp"
    elseif a:type == 'block'
        silent execute "normal! `[\<C-V>`]\"xp"
    else
        silent execute "normal! `[v`]\"xp"
    endif
endfunction

" インデント選択
function! VisualCurrentIndentBlock(type)
    let current_indent = indent('.')
    let current_line   = line('.')
    let current_col    = col('.')
    let last_line      = line('$')

    let start_line = current_line
    while start_line != 1 && current_indent <= indent(start_line) || getline(start_line) == ''
        let start_line -= 1
    endwhile
    if a:type ==# 'i'
        let start_line += 1
    endif

    let end_line = current_line
    while end_line != last_line && current_indent <= indent(end_line) || getline(end_line) == ''
        let end_line += 1
    endwhile
    if a:type ==# 'i'
        let end_line -= 1
    endif

    call cursor(start_line, current_col)
    normal! V
    call cursor(end_line, current_col)
endfunction

nnoremap vii :call VisualCurrentIndentBlock('i')<CR>
nnoremap vai :call VisualCurrentIndentBlock('a')<CR>
onoremap ii :normal vii<CR>
onoremap ai :normal vai<CR>

nnoremap gs :<C-u>setf<Space>

"------------------------
" プラグインの設定
"------------------------

call pathogen#runtime_append_all_bundles()


" symfony.vim
" nnoremap <Space>sv :<C-u>Sview<CR>
" nnoremap <Space>sa :<C-u>Saction<CR>
" nnoremap <Space>sm :<C-u>Smodel<CR>
" nnoremap <Space>sp :<C-u>Spartial<CR>
" nnoremap <Space>ss :<C-u>Symfony
" nnoremap <Space>sc :<C-u>Sconfig
" nnoremap <Space>sl :<C-u>Slib

" ku.vim
nnoremap <silent> <Space>kb :<C-u>Ku buffer<CR>
nnoremap <silent> <Space>kf :<C-u>Ku file<CR>
nnoremap <silent> <Space>kh :<C-u>Ku history<CR>
nnoremap <silent> <Space>kc :<C-u>Ku cmd_mru/cmd<CR>
nnoremap <silent> <Space>ks :<C-u>Ku cmd_mru/search<CR>
nnoremap <silent> <Space>km :<C-u>Ku file_mru<CR>
nnoremap <silent> <Space>kp :<C-u>Ku ref/perldoc<CR>

function! Ku_my_keymappings()
    inoremap <buffer> <silent> <Tab> /
    inoremap <buffer> <C-w>n <Esc>:<C-u>KuDoAction tab-Right<CR>
    inoremap <buffer> <C-w>p <Esc>:<C-u>KuDoAction tab-Left<CR>
    inoremap <buffer> <C-w>h <Esc>:<C-u>KuDoAction left<CR>
    inoremap <buffer> <C-w>l <Esc>:<C-u>KuDoAction right<CR>
    inoremap <buffer> <C-w>j <Esc>:<C-u>KuDoAction below<CR>
    inoremap <buffer> <C-w>k <Esc>:<C-u>KuDoAction above<CR>
    inoremap <buffer> <C-w>H <Esc>:<C-u>KuDoAction Left<CR>
    inoremap <buffer> <C-w>L <Esc>:<C-u>KuDoAction Right<CR>
    inoremap <buffer> <C-w>J <Esc>:<C-u>KuDoAction Bottom<CR>
    inoremap <buffer> <C-w>K <Esc>:<C-u>KuDoAction Top<CR>
endfunction

augroup KuSetting
autocmd!
autocmd FileType ku call ku#default_key_mappings(1)
    \ | call Ku_my_keymappings()
augroup END

call ku#custom_prefix('common', '~', $HOME)

autocmd FileType perl nnoremap <Space>pr :Prove<CR>

" jslint
function! Jslint()
    let msg = system('/usr/local/bin/jsl -process ' . expand('%:p'))
    let m = matchlist(msg, '\(\d\+\) error(s), \(\d\+\) warning(s)')
    let error = m[1]
    let warn  = m[2]
    if (error == 0 && warn == 0)
        echo 'syntax ok'
    else
        let msgs = split(msg, '\n')
        let errors = []
        for line in msgs
            let m = matchlist(line, expand('%:p').'(\(\d\+\)): \(.*\)')
            if len(m) != 0
                call add(errors, printf('%s:%s: %s',
                \                        expand('%:p'), m[1], m[2]))
            endif
        endfor
        setlocal errorformat=%f:%l:%m
        cgetexpr join(errors, "\n")
        copen
    endif
endfunction
autocmd! FileType javascript nnoremap <Space>jl :<C-u>call Jslint()<CR>

" 絶対パスで開く
"let s:htdocs_dirs = [$HOME.'/dev/site/localhost/test']
"function! GotoAbsFile()
"    let fname = expand('<cfile>')
"    let filepass = fname
"    if (match(fname, '^/') != -1)
"        for dir in s:htdocs_dirs
"            if match(expand("%:p:h"), dir) != -1 && isdirectory(dir) == 1
"                let filepass = dir . fname
"                break
"            endif
"        endfor
"    endif
"    if filereadable(filepass)
"        execute 'edit ' . filepass
"    else
"        echohl ErrorMsg
"        echo 'no such file ' . fname
"        echohl None
"    endif
"endfunction
"nnoremap gaf :<C-u>call GotoAbsFile()<CR>

"http://hail2u.net/blog/software/support-slash-started-relative-url-in-vim-gf.html
autocmd FileType html :setlocal includeexpr=substitute(v:fname,'^\\/','','')
autocmd FileType html :setlocal path+=;/

" クリップボード連携 
if has('mac')
    function! Pbcopy(type, ...)
        let reg_save = @@
        if a:0
            silent execute "normal! `<" . a:type . "`>y"
        elseif a:type == 'line'
            silent execute "normal! '[V']y"
        elseif a:type == 'block'
            silent execute "normal! `[\<C-V>`]y"
        else
            silent execute "normal! `[v`]y"
        endif
        call system('iconv -f utf-8 -t shift-jis | pbcopy', @@)
        let @@ = reg_save
    endfunction
    nnoremap <silent> <Space>y :<C-u>set opfunc=Pbcopy<CR>g@
    nnoremap <silent> <Space>yy :<C-u>set opfunc=Pbcopy<CR>g@g@
    vnoremap <silent> <Space>y :<C-u>call Pbcopy(visualmode(), 1)<CR>
    nnoremap <silent> <Space>pp :<C-u>r !pbpaste<CR>
endif

" align.vimのおぺれーた
"function! AlignTSP(type, ...)
"    let reg_save = @@
"    silent execute "normal! '[V']\<leader>tsp"
"    let @@ = reg_save
"endfunction
"nnoremap <silent> <Space>a :<C-u>set opfunc=AlignTSP<CR>g@
vmap <Space>a <leader>tsp
vnoremap <Space>= :Align =><CR>

" ウインドウ単位で開いたファイルの履歴をたどる
" なんかvimgrepでバグる
function! FileJumpPush()
    if !exists('w:histories')
        let w:histories = []
    endif
    let buf = bufnr('%')
    if count(w:histories, buf) == 0
        call add(w:histories, buf)
    endif
endfunction

function! FileJumpPrev()
    if exists('w:histories')
        let buf = bufnr('%')
        let current = match(w:histories, '^'.buf.'$')
        if current != 0 && exists('w:histories[current - 1]')
            execute 'buffer ' . w:histories[current - 1]
        endif
    endif
endfunction

function! FileJumpNext()
    if exists('w:histories')
        let buf = bufnr('%')
        let current = match(w:histories, '^'.buf.'$')
        if exists('w:histories[current + 1]')
            execute 'buffer ' . w:histories[current + 1]
        endif
    endif
endfunction

augroup FileJumpAutoCmd
    autocmd!
augroup END

"autocmd FileJumpAutoCmd BufReadPre * call FileJumpPush()
"nnoremap <silent> ,p :<C-u>call FileJumpPrev()<CR>
"nnoremap <silent> ,n :<C-u>call FileJumpNext()<CR>


" acp.vim
let g:acp_behaviorSnipmateLength = 1

" see http://vim-users.jp/2009/11/hack96/
autocmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif

" perl-completion.vim
"let g:def_perl_comp_bfunction = 1
"let g:def_perl_comp_packagen  = 1
"let g:acp_behaviorPerlOmniLength = 0

" smartchr.vim
"inoremap <expr> = smartchr#one_of(' = ', ' == ', ' === ', '=')
"inoremap <expr> => smartchr#one_of(' => ', '=>')

" rename
function! DoRename(file)
    execute "file " . a:file
    call delete(expand('#'))
    write!
endfunction
function! Rename(file, bang)
    if filereadable(a:file)
        if a:bang == '!'
            call DoRename(a:file)
        else
            echohl ErrorMsg
            echomsg 'File exists (add ! to override)'
            echohl None
        endif
    else
        call DoRename(a:file)
    endif
endfunction
command! -nargs=1 -bang -complete=file Rename call Rename(<q-args>, "<bang>")


"zen-coding
let g:user_zen_leader_key = '<C-f>'
let g:user_zen_settings = {
\  'indentation' : '    ',
\  'html': {
\     'close_empty_element': 0,
\     'snippets': {
\        'html:5': "<!DOCTYPE html>\n"
\                ."<html lang=\"${lang}\">\n"
\                ."<head>\n"
\                ."    <meta charset=\"${charset}\">\n"
\                ."    <title></title>\n"
\                ."</head>\n"
\                ."<body>\n\t${child}|\n</body>\n"
\                ."</html>"
\     }
\  }
\}

set virtualedit+=block

" プロジェクト毎に読み込む設定ファイル
augroup vimrc-project
    autocmd!
    autocmd BufNewFile,BufReadPost * call s:vimrc_project(expand('<afile>:p:h'))
augroup END

function! s:vimrc_project(loc)
    let files = findfile('.vimrc.project', escape(a:loc, ' ') . ';', -1)
    for i in reverse(filter(files, 'filereadable(v:val)'))
        source `=i`
    endfor
endfunction

" package名チェック
function! s:get_package_name()
  let mx = '^\s*package\s\+\([^ ;]\+\)'
  for line in getline(1, 5)
    if line =~ mx
      return substitute(matchstr(line, mx), mx, '\1', '')
    endif
  endfor
  return ""
endfunction

function! s:check_package_name()
  let path = substitute(expand('%:p'), '\\', '/', 'g')
  let name = substitute(s:get_package_name(), '::', '/', 'g') . '.pm'
  if path[-len(name):] != name
    echohl WarningMsg
    echomsg "ぱっけーじめいと、ほぞんされているぱすが、ちがうきがします！"
    echomsg "ちゃんとなおしてください＞＜"
    echohl None
  endif
endfunction

au! BufWritePost *.pm call s:check_package_name()

" ref.vim
let g:ref_phpmanual_path = $HOME.'/Documents/php-chunked-xhtml'
let g:ref_perldoc_complete_head = 1
let g:ref_use_vimproc = 0
let g:ref_jquery_use_cache = 1
let g:ref_alc_use_cache = 1
nnoremap <silent> <Space>rl :<C-u>call ref#jump('normal', 'alc')<CR>
vnoremap <silent> <Space>rl :<C-u>call ref#jump('visual', 'alc')<CR>
nnoremap <silent> <Space>rp :<C-u>call ref#jump('normal', 'perldoc')<CR>
vnoremap <silent> <Space>rp :<C-u>call ref#jump('visual', 'perldoc')<CR>
nnoremap <C-f><C-f> :<C-u>Ref<Space>
nnoremap <C-f><C-p> :<C-u>Ref perldoc<Space>
nnoremap <C-f><C-l> :<C-u>Ref alc<Space>
nnoremap <C-f><C-h> :<C-u>Ref phpmanual<Space>
nnoremap <C-f><C-j> :<C-u>Ref jquery<Space>

"let g:prove_debug = 1

" Capture
command! -nargs=1 -complete=command Capture call Capture(<f-args>)

function! Capture(cmd)
  redir => result
  silent execute a:cmd
  redir END

  let bufname = 'Capture: ' . a:cmd
  new
  setlocal bufhidden=unload
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal noswapfile
  silent file `=bufname`
  silent put =result
  1,2delete _
endfunction

" パスの追加
let s:paths = split($PATH, ':')
function! g:insert_path(path)
    let index = index(s:paths, a:path)
    if index != -1
        call remove(s:paths, index)
    endif
    call insert(s:paths, a:path)
    let $PATH = join(s:paths, ':')
endfunction

" local設定ファイル
let local_vimrc = $HOME."/.vimrc.local"
if (filereadable(local_vimrc))
    execute "source " . local_vimrc
endif


" こういうHTMLがあったときに
" <div id="hoge" class="fuga">
" ...
" </div>
"
" 実行するとこうなる
" <div id="hoge" class="fuga">
" ...
" <!-- /div#hoge.fuga --></div>

function! Endtagcomment()
    let reg_save = @@

    try
        silent normal vaty
    catch
        execute "normal \<Esc>"
        echohl ErrorMsg
        echo 'no match html tags'
        echohl None
        return
    endtry

    let html = @@

    let start_tag = matchstr(html, '\v(\<.{-}\>)')
    let tag_name  = matchstr(start_tag, '\v([a-zA-Z]+)')

    let id = ''
    let id_match = matchlist(start_tag, '\vid\=["'']([^"'']+)["'']')
    if exists('id_match[1]')
        let id = '#' . id_match[1]
    endif

    let class = ''
    let class_match = matchlist(start_tag, '\vclass\=["'']([^"'']+)["'']')
    if exists('class_match[1]')
        let class = '.' . join(split(class_match[1], '\v\s+'), '.')
    endif

    execute "normal `>va<\<Esc>`<"

    let comment = g:endtagcommentFormat
    let comment = substitute(comment, '{%tag_name}', tag_name, 'g')
    let comment = substitute(comment, '{%id}', id, 'g')
    let comment = substitute(comment, '{%class}', class, 'g')
    let @@ = comment

    normal ""P

    let @@ = reg_save
endfunction
let g:endtagcommentFormat = '<!-- /{%tag_name}{%id}{%class} -->'
nnoremap ,t :<C-u>call Endtagcomment()<CR>

" DBICのプレースホルダーで出力されたSQLを実行できるかたちに直して
" クリップボードにコピる
function! PlaceholderReplace()
    let matchs = matchlist(getline('.'), '\v^(.{-}):(.*)$')
    let value_str = matchs[2]
    let values = split(value_str, ',')
    let sql = matchs[1]
    while match(sql, '?') != -1
        let value = values[0]
        let sql = substitute(sql, '?', value, '')
        unlet values[0]
    endwhile
    call system('pbcopy', sql.';')
    echo 'copy: ' . sql
endfunction
nnoremap ,p :<C-u>call PlaceholderReplace()<CR>

" neocon
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_enable_auto_select = 1
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()


" ディレクトリが存在しなくてもディレクトリつくってファイル作成
function! s:newFileOpen(file)
    let dir = fnamemodify(a:file, ':h')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
    execute 'edit ' . a:file
endfunction
command! -nargs=1 -complete=file New call s:newFileOpen(<q-args>)

" MarkdownをHTMLにする
function! s:markdown(line1, line2)
    let markdown_insalled = s:exec_perl('
    \   eval { require Text::Markdown };
    \   print $@ ? 0 : 1;
    \')

    if !markdown_insalled
        call s:error('Text::Markdown not installed')
        return
    endif

    let md_text = join(getline(a:line1, a:line2), "\n")
    let md_text = substitute(md_text, "'", "\\\\'", 'g')
    let perl_code = "
    \   use Text::Markdown qw/markdown/;
    \   my $html;
    \   eval { $html = markdown('" . md_text . "'); };
    \   print $@ ? '' : $html;
    \"

    try
        let html = s:exec_perl(perl_code)
        if html == ''
            throw 'parse error'
        endif
    catch /shell error/
        call s:error('perl code invalid')
        return
    catch /parse error/
        call s:error('parse error')
        return
    endtry

    let html = substitute(html, "\n</code></pre>", "</code></pre>", 'g')

    " replace
    "silent execute a:line1 . ',' . a:line2 . 'delete _'
    "call append(a:line1 - 1, split(html, "\n"))

    " scratch window
    execute 'new'
    setlocal bufhidden=unload
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal noswapfile
    nnoremap <buffer> <silent> q <C-w>c
    call append(0, split(html, "\n"))
    1
endfunction

function! s:exec_perl(perl_code)
    let ret = system('perl', a:perl_code)
    if v:shell_error
        throw 'shell error'
    endif

    return ret
endfunction

function! s:error(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

command! -range=% -nargs=? Markdown
\ :call s:markdown(<line1>, <line2>)


let s:markdown2inao_script_path = $HOME.'/local/bin/markdown2inao.pl'

function! s:markdown2inao()
    return system(s:markdown2inao_script_path .' '. expand('%'))
endfunction

function! s:inao_scratch()
    let inao = s:markdown2inao()
    execute 'new'
    setlocal bufhidden=unload
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal noswapfile
    silent file markdown
    nnoremap <buffer> <silent> q <C-w>c
    call append(0, split(inao, "\n"))
    1
endfunction

function! s:inao_copy()
    let inao = s:markdown2inao()
    call system('iconv -f utf-8 -t shift-jis | pbcopy', inao)
endfunction

command! -nargs=0 Inao     :call s:inao_scratch()
command! -nargs=0 InaoCopy :call s:inao_copy()
