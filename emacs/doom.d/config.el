;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "chaomai"
      user-mail-address "loneymai@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;;;;;;;;; env
(setq read-process-output-max (* 1024 1024 3))

(setq default-frame-alist
      (append default-frame-alist '((inhibit-double-buffering . t))))

;; check is gui
(defvar is_gui (display-graphic-p))

;; check platform
(defconst MACOS "macos")
(defconst WSL "wsl")
(defconst LINUX "linux")

(cond
 ((string-equal system-type "darwin")
  (defvar platform MACOS))

 ((string-match "microsoft"
                (with-temp-buffer (shell-command "uname -r" t)
                                  (goto-char (point-max))
                                  (delete-char -1)
                                  (buffer-string)))
  (defvar platform WSL))

 ((string-equal system-type "gnu/linux")
  (defvar platform LINUX)))

;; org mode dir
(defvar org_notes_path "chaomai.org/notes/")

(cond
 ((string-equal platform MACOS)
  (defvar org_dir "~/Documents/onedrive/Documents/workspace/chaomai.org/"))

 ((string-equal platform LINUX)
  (message "no implemented"))

 ((string-equal platform WSL)
  (defvar org_dir "~/Documents/onedrive/Documents/workspace/chaomai.org/")))

;; conda home
(cond
 ((string-equal platform MACOS)
  (defvar conda_home "/usr/local/Caskroom/miniconda/base/")
  (defvar conda_env_home "/usr/local/Caskroom/miniconda/base/"))

 ((string-equal platform LINUX)
  (message "no implemented"))

 ((string-equal platform WSL)
  (defvar conda_home "/home/chaomai/Programs/opt/miniconda3/")
  (defvar conda_env_home "/home/chaomai/Programs/opt/miniconda3/")))

;; wsl open
(defun wsl-browse-url (url &optional _new-window)
  ;; new-window ignored
  (interactive (browse-url-interactive-arg "URL: "))
  (let ((quotedUrl (format "start '%s'" url)))
    (apply 'call-process "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" nil
           0 nil
           (list "-Command" quotedUrl)))
  (message "open link via powershell"))

(cond
 ((string-equal platform WSL)
  (setq browse-url-browser-function 'wsl-browse-url)))

;; clang-format
(cond
 ((string-equal platform MACOS)
  (defvar clang-format_bin "/usr/local/Cellar/llvm/11.1.0_1/bin/clang-format"))

 ((string-equal platform LINUX)
  (message "no implemented"))

 ((string-equal platform WSL)
  (defvar clang-format_bin "clang-format-10")))

(use-package! which-key
  :config
  (setq which-key-idle-delay 0.5))

;;;;;;;;;; ui
(setq fancy-splash-image (concat doom-private-dir "nerv_logo.png"))

(setq line-spacing 8
      display-line-numbers-type t)

(cond
 ((string-equal platform MACOS)
  (defvar font_size 15))

 ((string-equal platform LINUX)
  (message "no implemented"))

 ((string-equal platform WSL)
  (defvar font_size 18)))

;; https://emacs-china.org/t/doom-emacs/9628/8?u=chaomai
(defun +my/better-font(size)
  (interactive)
  (if (display-graphic-p)
      (progn
        ;; english font
        ;; (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Victor Mono" size) :weight 'Regular)
        (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Sarasa Mono SC" size) :weight 'Regular)
        ;; chinese font
        (dolist (charset '(kana han symbol cjk-misc bopomofo))
          (set-fontset-font (frame-parameter nil 'font) charset
                            (font-spec :family "Noto Sans CJK SC"))))))

(defun +my|init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (+my/better-font font_size))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font font_size))

(use-package! doom-themes
  :config
  (if (display-graphic-p)
      (load-theme 'doom-acario-light t)
    (load-theme 'doom-acario-light t))

  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  (doom-themes-visual-bell-config)

  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;;;;;;;;;; basic
;; pyim
(use-package! pyim
  :demand t
  :config
  (setq pyim-default-scheme 'quanpin
        default-input-method "pyim"
        ;; 开启拼音搜索功能
        ;; pyim-isearch-mode 1
        pyim-page-tooltip 'posframe
        pyim-page-length 8
        pyim-fuzzy-pinyin-alist '(("an" "ang")
                                  ("in" "ing")
                                  ("en" "eng")
                                  ("uan" "uang"))
        pyim-dcache-directory (concat doom-cache-dir "pyim"))

  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 C-; 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions '(pyim-probe-dynamic-english
                                                      pyim-probe-isearch-mode
                                                      pyim-probe-program-mode
                                                      pyim-probe-org-structure-template)
                pyim-punctuation-half-width-functions '(pyim-probe-punctuation-line-beginning
                                                        pyim-probe-punctuation-after-punctuation))

  :bind
  (("C-;" . pyim-convert-string-at-point) ; 与 pyim-probe-dynamic-english 配合
   ))

(use-package! pyim-basedict
  :after pyim
  :config
  (pyim-basedict-enable))

(use-package! pyim-greatdict
  :after pyim
  :config
  (pyim-greatdict-enable))

(use-package! pangu-spacing
  :demand t
  :config
  (global-pangu-spacing-mode 1)
  (setq pangu-spacing-real-insert-separtor t))

;; projectile
;; project root is same with vim's configuration
(use-package! projectile
  :demand t
  :config
  (setq projectile-require-project-root t
        projectile-project-root-files '(".ccls-root" ".idea" "go.mod" ".bzr" "_darcs"
                                        "build.xml" ".project" ".root" ".svn" ".git"
                                        ".projectile")
        projectile-project-root-functions '(projectile-root-top-down
                                            projectile-root-top-down-recurring
                                            projectile-root-bottom-up
                                            projectile-root-local)))

;; evil
(use-package! evil
  :defer t
  :config
  (evil-ex-define-cmd "q[uit]" 'kill-this-buffer)
  :custom
  (evil-want-fine-undo t)
  (evil-disable-insert-state-bindings t)
  (evil-split-window-below t)
  (evil-vsplit-window-right t))

;; centaur-tabs
(use-package! centaur-tabs
  :demand t
  :config
  (defun centaur-tabs-hide-tab (x)
    "Do no to show buffer X in tabs."
    (let ((name (format "%s" x)))
      (or
       ;; Current window is not dedicated window.
       (window-dedicated-p (selected-window))

       ;; Buffer name not match below blacklist.
       (string-prefix-p "*epc" name)
       (string-prefix-p "*helm" name)
       (string-prefix-p "*Helm" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*lsp" name)
       (string-prefix-p "*company" name)
       (string-prefix-p "*Flycheck" name)
       (string-prefix-p "*tramp" name)
       (string-prefix-p " *Mini" name)
       (string-prefix-p "*help" name)
       (string-prefix-p "*straight" name)
       (string-prefix-p " *temp" name)
       (string-prefix-p "*Help" name)
       (string-prefix-p "*mybuf" name)

       ;; Is not magit buffer.
       (and (string-prefix-p "magit" name)
            (not (file-name-extension name)))
       )))
  (centaur-tabs-headline-match)
  (centaur-tabs-group-by-projectile-project)
  (centaur-tabs-mode t)
  (setq centaur-tabs-style "wave"
        centaur-tabs-set-close-button nil
        centaur-tabs-set-modified-marker t))

(use-package! saveplace
  :demand t
  :config
  (save-place-mode 1)
  (setq save-place-mode t))

(use-package! posframe
  :demand t)

(use-package! flycheck-posframe
  :after flycheck
  :hook (flycheck-mode-hook . flycheck-posframe-mode))

;;;;;;;;;; ivy
(use-package! ivy
  :defer t
  :config
  (setq ivy-display-style 'fancy
        ivy-count-format "(%d/%d) "
        ivy-use-virtual-buffers t
        ivy-on-del-error-function 'ignore
        ivy-re-builders-alist '((t . pyim-ivy-cregexp))))

(use-package! counsel
  :defer t
  :hook (ivy-mode . counsel-mode))

(use-package! swiper
  :defer t
  :config
  (setq swiper-action-recenter t))

;;;;;;;;;; company
;; https://emacs.stackexchange.com/questions/15246/how-add-company-dabbrev-to-the-company-completion-popup
;; https://phenix3443.github.io/notebook/emacs/modes/company-mode.html
(use-package! company
  :defer t
  :config
  (setq company-tooltip-limit 10
        company-idle-delay 0.0
        company-echo-delay 0.0
        ;; Easy navigation to candidates with M-<n>
        company-show-numbers t
        company-require-match nil
        company-minimum-prefix-length 1
        company-tooltip-align-annotations t
        ;; complete `abbrev' only in current buffer
        company-dabbrev-other-buffers nil
        ;; make dabbrev case-sensitive
        company-dabbrev-ignore-case t
        company-dabbrev-downcase nil
        company-backends '((company-capf
                            company-dabbrev-code
                            company-keywords
                            company-files
                            company-dabbrev))))

;;;;;;;;;; org
;; org-mode
(use-package! org
  :defer t
  :init
  (setq org-directory org_dir)
  :config
  (setq org-agenda-files (list (concat org_dir "gdt/"))
        org-capture-templates `(("i" "inbox" entry (file ,(concat org_dir "gdt/inbox.org"))
                                 "* TODO %? \n\n %F \n")
                                ("l" "link" entry (file ,(concat org_dir "gdt/inbox.org"))
                                 "* TODO %(org-cliplink-capture)" :immediate-finish t)
                                ("c" "org-protocol-capture" entry (file ,(concat org_dir "gdt/inbox.org"))
                                 "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t))
        org-tags-column 0
        org-pretty-entities nil
        org-startup-indented t
        org-startup-folded t
        org-startup-truncated nil
        org-image-actual-width nil
        org-hide-leading-stars t
        org-hide-emphasis-markers nil
        org-fontify-done-headline t
        org-fontify-whole-heading-line t
        org-fontify-quote-and-verse-blocks t
        org-catch-invisible-edits 'smart
        org-insert-heading-respect-content t
        ;; block switching the parent to done state
        org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t
        org-ellipsis " ▼ "
        ;; gdt task status
        org-todo-keywords '((sequence "TODO(t)" "NEXT(n@/!)" "PROG(p@/!)" "|" "DONE(d@/!)" "HOLD(h@/!)" "CANCELLED(c@/!)"))

        ;; log
        org-log-done 'time
        org-log-repeat 'time
        org-log-redeadline 'note
        org-log-reschedule 'note
        org-log-into-drawer t
        org-log-state-notes-insert-after-drawers nil
        ;; refile
        org-refile-use-cache t
        org-refile-targets '((org-agenda-files . (:maxlevel . 6)))
        org-refile-use-outline-path t
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm
        ;; 配置归档文件的名称和 Headline 格式
        org-archive-location "%s_archive::date-tree"
        org-blank-before-new-entry '((heading . always)
                                     (plain-list-item . nil))))

;; org-src
(use-package! org-src
  :after org
  :config
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-src-window-setup 'current-window
        org-confirm-babel-evaluate t
        org-edit-src-content-indentation 0
        org-babel-load-languages '((shell . t)
                                   (python . t)
                                   (ocaml . t)
                                   (emacs-lisp . t))))

;; org-clock
(use-package! org-clock
  :after org
  :config
  (org-clock-persistence-insinuate)
  (setq org-clock-in-resume t
        org-clock-idle-time 10
        org-clock-into-drawer t
        org-clock-out-when-done t
        org-clock-persist 'history
        org-clock-history-length 10
        org-clock-out-remove-zero-time-clocks t
        org-clock-report-include-clocking-task t))

;; org-superstar
(use-package! org-superstar
  :after org
  :hook (org-mode . org-superstar-mode))
  ;; :config
  ;; (setq org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷" "☷" "☷" "☷")))

;; org-download
;; make drag-and-drop image save in the same name folder as org file.
;; example: `aa-bb-cc.org' then save image test.png to `aa-bb-cc_media/test.png'.
;; if in notes folader, then save image to media folder.
;; https://coldnew.github.io/hexo-org-example/2018/05/22/use-org-download-to-drag-image-to-emacs/
(use-package! org-download
  :hook (dired-mode . org-download-enable)
  :config
  (defun my-org-download-method (link)
    (if (string-match-p (regexp-quote org_notes_path) (buffer-file-name))
        (let ((filename
               (file-name-nondirectory
                (car (url-path-and-query
                      (url-generic-parse-url link)))))
              (dirname (concat org_dir "notes/media/" (format-time-string "%Y/%m/"))))
          (unless (file-exists-p dirname)
            (make-directory dirname))
          (expand-file-name filename dirname))

    (let ((filename
           (file-name-nondirectory
            (car (url-path-and-query
                  (url-generic-parse-url link)))))
          (dirname (concat (file-name-sans-extension (buffer-name)) "_media/")))
      ;; if directory not exist, create it
      (unless (file-exists-p dirname)
        (make-directory dirname))
      ;; return the path to save the download files
      (expand-file-name filename dirname)))

  (setq org-download-method 'my-org-download-method)))

;; valign
(use-package! valign
  :after org
  :hook (org-mode . valign-mode)
  :config
  (setq valign-fancy-bar t))

;;;;;;;;;; dev
(use-package! format
  :demand t
  :config
  (defun get-format-args (formatter)
    (let ((confpath
           (cond
            ((string-equal formatter "clang-format")
             (concat (projectile-project-root) ".clang-format"))
            ((string-equal formatter "black")
             (message "no implemented")))))
      (if (file-exists-p confpath)
          (concat "-style=" confpath)
        "-style={BasedOnStyle: Google, IndentWidth: 4, AlignTrailingComments: true, SortIncludes: false}")))

  (set-formatter! 'clang-format
    '(clang-format_bin
      (get-format-args "clang-format")
      ("-assume-filename=%S" (or buffer-file-name mode-result "")))
    :modes
    '((c-mode ".c")
      (c++-mode ".cpp")
      (java-mode ".java")
      (objc-mode ".m")
      (protobuf-mode ".proto")))
  (set-formatter! 'black "black -q -"
    :modes '(python-mode)))

;; ;;;;;;;;;; lsp
;; ;; lsp-mode
;; ;; 1. https://github.com/MaskRay/Config/blob/master/home/.config/doom/modules/private/my-cc/autoload.el
;; ;; 2. https://github.com/MaskRay/ccls/wiki/lsp-mode
;; (use-package! lsp-mode
;;   :commands lsp
;;   :hook (lsp-mode-hook . lsp-enable-which-key-integration)
;;   :config
;;   (setq lsp-idle-delay 0.5                 ;; lazy refresh
;;         lsp-log-io nil                     ;; enable log only for debug
;;         lsp-enable-file-watchers nil
;;         lsp-headerline-breadcrumb-enable t)
;;   (add-to-list 'exec-path (concat conda_home "envs/common_env_python3.9/bin/")))
;;
;; (use-package! lsp-ui
;;   :after lsp-mode
;;   :config
;;   (setq lsp-ui-sideline-enable t
;;         lsp-ui-sideline-delay 0.1
;;         lsp-ui-sideline-ignore-duplicate t
;;         lsp-ui-sideline-show-code-actions nil
;;         lsp-ui-sideline-show-diagnostics t
;;         lsp-ui-sideline-show-hover nil
;;
;;         lsp-ui-peek-enable nil
;;         lsp-ui-peek-fontify 'always
;;
;;         lsp-ui-doc-enable nil
;;         lsp-ui-doc-use-webkit nil
;;         lsp-ui-doc-delay 0.1
;;         lsp-ui-doc-include-signature t
;;         lsp-ui-doc-position 'top
;;
;;         lsp-ui-imenu-enable t))
;;
;; ;; ccls
;; (use-package! ccls
;;   :after lsp-mode
;;   :config
;;   (setq ccls-sem-highlight-method 'overlay)
;;   (ccls-use-default-rainbow-sem-highlight)
;;
;;   (setq ccls-executable "~/Documents/workspace/github/ccls/Release/ccls"
;;         ccls-args '("--log-file=/tmp/ccls-emacs.log")
;;         ccls-initialization-options `(:capabilities (:foldingRangeProvider :json-false)
;;                                       :cache (:directory ".ccls-cache")
;;                                       :completion (:caseSensitivity 0)
;;                                       :compilationDatabaseDirectory "cmake-build"
;;                                       :codeLens (:localVariables :json-false)
;;                                       :client (:snippetSupport t)
;;                                       :diagnostics (:onChang 100
;;                                                     :onOpen 100
;;                                                     :onSave 100)
;;                                       :highlight (:lsRanges t)
;;                                       :index (:threads 5)))
;;   (evil-set-initial-state 'ccls-tree-mode 'emacs))

;;;;;;;;;; references
;; https://practicalli.github.io/spacemacs/
;; https://scarletsky.github.io/2017/09/29/org-mode-in-spacemacs/
;; https://edward852.github.io/post/%E9%80%9A%E7%94%A8%E4%BB%A3%E7%A0%81%E7%BC%96%E8%BE%91%E5%99%A8spacemacs/
;; https://emacs-lsp.github.io/lsp-mode/
;; https://www.gtrun.org/custom/init.html
;; https://github.com/condy0919/emacs-newbie
;; https://github.com/condy0919/.emacs.d
;; https://alhassy.github.io/init/
;; https://huadeyu.tech/tools/emacs-setup-notes.html
;; https://emacs.nasy.moe/
;; https://github.com/lujun9972/emacs-document
;; https://blog.jethro.dev/posts/org_mode_workflow_preview/
