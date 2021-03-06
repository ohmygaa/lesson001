
;; commandをcontrolと同じにする
;(setq mac-command-modifier 'ctrl)
;(setq ns-command-modifier 'ctrl)
;; CommandとOptionを入れ替える
;(setq ns-command-modifier (quote meta))
;(setq ns-alternate-modifier (quote super))

;; スクロールステップ１
(setq scroll-step 1)

; カッコの強調
(show-paren-mode t)
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "gray10")
(set-face-foreground 'show-paren-match-face "SkyBlue")
(setq show-paren-style 'expression)

;; C-k １回で行全体を削除する
(setq kill-whole-line t)

; カーソル行アンダーライン
(setq hl-line-face 'underline)
(global-hl-line-mode)

;; C-t 画面移動
(global-set-key "\C-t" 'other-window)

;; C-h をBackspaceに割り当て
(global-set-key "\C-h" 'delete-backward-char)

;;指定行へ移動
(global-set-key "\M-g" 'goto-line)


;; 予約語を色分けする
(global-font-lock-mode t)
;; リージョンを色付きにする
(setq transient-mark-mode t)

;; カーソル位置の桁数をモードライン行に表示する
(column-number-mode 1)
;; カーソル位置の行数をモードライン行に表示する
(line-number-mode 1)

;; モードラインに時間表示 月/日 曜日
(setq display-time-string-forms '(year "/" month "/" day " (" dayname ") " 24-hours ":" minutes))
(display-time)

;--------------------------------------------------------
(add-hook 'php-mode-hook
  '(lambda()
     (setq tab-width 4)
     (setq indent-tabs-mode t)
     (setq c-basic-offset 4)
     (c-set-offset 'case-label' 4)
     (c-set-offset 'arglist-intro' 4)
     (c-set-offset 'arglist-cont-nonempty' 4)
     (c-set-offset 'arglist-close' 0)
   ))

;; Cakephp
(add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode))

;;----------------------------------------
;;PHPモード
;;----------------------------------------
(autoload 'php-mode "php-mode" "PHP mode" t)
(defcustom php-file-patterns (list "\\.php[s34]?\\'" "\\.phtml\\'" "\\.inc\\'")
  "*List of file patterns for which to automatically invoke php-mode."
  :type '(repeat (regexp :tag "Pattern"))
  :group 'php)
  (let ((php-file-patterns-temp php-file-patterns))
   (while php-file-patterns-temp
     (add-to-list 'auto-mode-alist
                  (cons (car php-file-patterns-temp) 'php-mode))
     (setq php-file-patterns-temp (cdr php-file-patterns-temp))))
;;構文チェック
(add-hook 'php-mode-hook
          '(lambda ()
            (local-set-key "\C-ctj" 'php-lint)))
(defun php-lint ()
  "Performs a PHP lint-check on the current file."
  (interactive)
  (shell-command (concat "php -l " (buffer-file-name))))





;;-----------------------------------

;====================================
;;全角スペースとかに色を付ける
;====================================
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-1 '((t (:background "dark turquoise"))) nil)
(defface my-face-b-2 '((t (:background "black"))) nil)
(defface my-face-b-2 '((t (:background "cyan"))) nil)
(defface my-face-b-2 '((t (:background "SeaGreen"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
            (font-lock-add-keywords
                 major-mode
                    '(
                           ("　" 0 my-face-b-1 append)
                           ("\t" 0 my-face-b-2 append)
                           ("[ ]+$" 0 my-face-u-1 append)
          )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                             (if font-lock-mode
                               nil
                               (font-lock-mode t))))
;--------------------------------------------------------
(global-set-key "\C-v" 'exp-pagedown)
(global-set-key [next] 'exp-pagedown)
(defun exp-pagedown () "Page Down"
  (interactive)
  (if (> (count-lines (window-end) (point)) 2)
        (forward-line (- (count-lines (point) (window-end)) 2))
    (progn
        (forward-line (/ (window-height) 2)) ; 半画面
	;  (forward-line (- (window-height) 4)) ; 全画面
	  (recenter -1))))

(global-set-key "\M-v" 'exp-pageup)
(global-set-key [prior] 'exp-pageup)
(defun exp-pageup () "Page Up"
  (interactive)
  (if (/= (window-start) (point))
        (goto-char (window-start))
    (progn
        (forward-line (- 0 (/ (window-height) 2))) ; 半画面
	;  (forward-line (- 3 (window-height))) ; 前画面
	  (recenter 0))))
;--------------------------------------------------------



(defun window-resizer ()
  "Control window size and position."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 1
              -1))
        (dy (if (= (nth 1 (window-edges)) 0) 1
              -1))
        action c)
    (catch 'end-flag
      (while t
        (setq action
              (read-key-sequence-vector (format "size[%dx%d]"
                                                (window-width)
                                                (window-height))))
        (setq c (aref action 0))
        (cond ((= c ?l)
               (enlarge-window-horizontally dx))
              ((= c ?h)
               (shrink-window-horizontally dx))
              ((= c ?j)
               (enlarge-window dy))
              ((= c ?k)
               (shrink-window dy))
              ;; otherwise
              (t
               (let ((last-command-char (aref action 0))
                     (command (key-binding action)))
                 (when command
                   (call-interactively command)))
               (message "Quit")
               (throw 'end-flag t)))))))
(global-set-key "\C-c\C-r" 'window-resizer)



