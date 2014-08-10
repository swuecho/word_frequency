#!/usr/bin/emacs --script
(defun read-words (file)
  "Return a list of words in FILE."
  (with-temp-buffer
    (insert-file-contents file)
     (split-string (buffer-string))))

;; 

(defun build_count (words)
  "return a frequency hash"
  (let (counts_hash)
    (setq counts_hash (make-hash-table :test 'equal))
    (mapcar (lambda (elt)
	      (puthash elt (+ 1 (gethash elt counts_hash 0)) counts_hash)) 
	    words)
    counts_hash))
;;TODO: learn todo list
   ;; (let (value)
   ;;   (dolist (elt list value)
	;;(puthash elt (+ 1 (gethash elt 0)))))))
;; TODO: should be hash to pair list
(defun hash-to-list (hashtable)
  "Return a list that represent the HASHTABLE."
  (let (myList)
    (maphash (lambda (kk vv) (setq myList (cons (cons kk vv) myList))) hashtable) 
    myList
  )
)
(hash-to-list (build_count (list "a" "a" "b")))

(defun sort_by_value (word_pair)
  (sort word_pair (lambda (a b) 
		    (< (cdr a) (cdr b))
		   )
  )
)
(sort_by_value (hash-to-list (build_count (list "a" "a" "b"))))

(mapcar 'princ (sort_by_value (hash-to-list (build_count (read-words "big.txt")))))

