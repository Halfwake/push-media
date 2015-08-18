;;;; push-media.lisp

(in-package #:push-media)

;;; "push-media" goes here. Hacks and glory await!

(defvar *app* (make-instance 'ningle:<app>))

(defun random-string ()
  "Return a random string."
  (coerce (loop for i below 16
	     collect (code-char (+ 65 (random (- 90 65))))) ; Random letter A-Z
	  'string))

(defvar *media-hash* (make-hash-table :test #'equal)
  "Contains a hash matching media routes to media file.")

(defparameter *not-found-response*
  '(404
    (:content-type "text/plain")
    ("The file was not found. It may have expired or never existed."))
  "The response to return when a media file cannot be found.")

(defun init-media (app)
  (setf (ningle:route app "/temp-media/:key")
	(lambda (params)
	  (let ((media-callback (gethash (cdar params) *media-hash*)))
	    (cond (media-callback
		   (funcall media-callback))
		  (t
		   *not-found-response*))))))

(defun clear-media ()
  "Clear all media routes."
  (clrhash *media-hash*))

(defun push-media (name-of-file &key (max-views nil) (seconds-alive nil))
  "Create a new route to the given file on the given server."
  (let ((file-key (random-string)))
    (setf (gethash file-key *media-hash*)
	  (lambda ()
	    (when max-views
	      (cond ((= max-views 1)
		     (remhash file-key *media-hash*))
		    (t
		     (decf max-views))))
	    `(200
	      (:content-type ,(mimes:mime name-of-file))
	      ,name-of-file)))
    (when seconds-alive
      (trivial-timers:schedule-timer
       (trivial-timers:make-timer
	(lambda ()
	  (remhash file-key *media-hash*)))
       seconds-alive))
    file-key))

    

