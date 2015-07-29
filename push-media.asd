;;;; push-media.asd

(asdf:defsystem #:push-media
  :description "Describe push-media here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:ningle
	       #:trivial-mimes
	       #:trivial-timers)
  :serial t
  :components ((:file "package")
               (:file "push-media")))

