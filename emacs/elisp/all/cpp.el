;; -*- emacs-lisp -*-

(require 'tempo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define initialization function and related variables

(defvar cpp-convention-expert nil
  "Set to non nil to activate more functionality.")

(defvar cpp-convention-verbose t
  "Set to non nil to cause insertion of explanitory comments.")

;; Initialize the conventions macros
(defun cpp-conventions ()
  "Setup macros implementing cpp coding conventions."

  ;; With out this, there will be no prompting inside tempo templates.
  (setq tempo-interactive t)

  ;; Tell tempo which tags to use
  (tempo-use-tag-list 'cpp-convention-tags)

  ;; Bind the functions to some convenient keys
  (local-set-key "\C-cmc" 'cpp-convention)
  (local-set-key "\M-]" 'tempo-forward-mark)
  (local-set-key "\M-[" 'tempo-backward-mark))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The template definitions

(defvar cpp-convention-tags nil
  "Tempo tags for C++ conventions")

;;; Preprocessor Templates (appended to cpp-convention-tags)

(tempo-define-template 
 "cpp-ifdef-else"
 '("#ifdef " (p "ifdef-clause: " clause) > n> p n
   "#else // !(" (s clause) ") " n> p n
   "#endif // " (s clause) n>
   )
 "#ifdef-else"
 "Insert a #ifdef #else #endif statement"
 'cpp-convention-tags)

(tempo-define-template 
 "cpp-ifndef"
 '("#ifndef " (p "ifndef-clause: " clause) > n 
   "#define " (s clause) n> p n
   "#endif // " (s clause) n>
   )
 "#ifndef"
 "Insert a #ifndef #define #endif statement"
 'cpp-convention-tags)

;;; C-Mode Templates
(tempo-define-template 
 "cpp-main"
 '(> "int main (int argc, char *argv[])" >  n> 
     "{" > n> r n 
     n
     n
     > "return EXIT_SUCCESS;" > n
     "} // end of main()" > n>
     )
 "main"
 "Insert a C main statement"
 'cpp-convention-tags)

(tempo-define-template 
 "cpp-switch"
 '(> "switch (" (p "switch condition: " clause) ")" " {" > n 
   > "case " (p "first value: ") ":" > n> 
   p n
   > "break;" > n> 
   p n
   > "default:" > n> 
   p n
   > "break;" > n
     "} // end of switch (" (s clause) ")" > n>
     )
 "switch"
 "Insert a C switch statement"
 'cpp-convention-tags)

(tempo-define-template 
 "cpp-case"
 '(n 
   > "case " (p "value: ") ":" > n> 
   p n
   > "break;" > n> p
   )
 "case"
 "Insert a C case statement"
 'cpp-convention-tags)


(tempo-define-template 
 "cpp-class"
 '(
   "class " classname p n "{" n 
   n
   (if cpp-convention-verbose
       (insert 
"//>>>  Layout hint:  Delete this hint before submitting code. \n\
//>>> \n\
//>>>  Align member names to this template if possible:- \n\
//>>> \n\
//>>>  return_type member_name( arg-list ) { in-line code ; } \n\
//>>> \n\
//>>> \n\
//>>>  Deal with long elements by left aligning as follows:- \n\
//>>> \n\
//>>>  very_long_return_type \n\
//>>>              very_long_member_name \n\
//>>>                        ( 1st-arg-type 1st-arg-name, \n\
//>>>                          2nd-arg_type 2nd-arg-name, \n\
//>>>                          3rd-arg_type 3rd-arg-name, \n\
//>>>                          ...     ) \n\
//>>>                              {  1st_code_stmt; \n\
//>>>                                 2nd_code_stmt; \n\
//>>>                                 ...            } \n\
//>>>  End layout hint \n\n"))
   > "public:" > n
   n
   " " (indent-for-comment) "Typedefs an enumerations:" n
   > p
   n
   > " " (indent-for-comment) "Con/de-structors:" n 
   > classname "(" p ");" > n
   > "~" classname "(" p ");" > n 
   n
   " " (indent-for-comment) "State testing member functions:" n 
   > p n
   " " (indent-for-comment) "State changing member functions:" n 
   > p n
   > "protected:" > n
   n
   " " (indent-for-comment) "State testing member functions:" n
   > p n
   " " (indent-for-comment) "State changing member functions:" n
   > p n
   > "private:" > n
   n
;   " " (indent-for-comment) "copy constructor, assignment:" n
;   > classname "(const " classname "& rhs); // copy constructor" > n
;   > classname "& operator=(const " classname "& rhs); // assignment" > n
   n
   " " (indent-for-comment) "State testing member functions:" n
   > p n
   " " (indent-for-comment) "State changing member functions:" n
   > p n
   " " (indent-for-comment) "Data members:" n
   (cond 
    (cpp-convention-verbose
     (indent-for-comment)
     (insert "  Naming convention: fXxxYyy  Class (static) members: fgXxxYyy\n")))
   n
   > p n
   "};" (indent-for-comment) "end of class " classname n>
   )
 "class"
 "Insert a class skeleton"
 'cpp-convention-tags)

(tempo-define-template 
 "cpp-header-comments"
 '((tempo-save-named 'class (file-name-sans-extension
			     (file-name-nondirectory buffer-file-name)))
   "/**" n
   " * \\class " classname n
   " *" n
   " * \\brief " (p "brief description: ") n 
   " *" n
   " * " p (p "detailed description: ") n
   " *" n
   " *" n
   " *" n
   " * bv@bnl.gov " (current-time-string) n
   " *" n
   " */" n
   n
   )
 "header-comments"
 "Insert a skeleton header comments"
 'cpp-convention-tags)

(tempo-define-template
 "cpp-implementation-extras"
 '(
   n
   "#include \"" packagename "/" classname ".h\""  n
   n
   "ClassImp(" classname ");" n
   n
   "// Note: the methods below should be kept in alphabetical order." n
   n
   )
 "implementation-extras"
 "Insert pre-method extra bits."
 'cpp-convention-tags)


(tempo-define-template
 "cpp-header-protect"
 '(
   "#ifndef " (upcase filename) "_H" n
   "#define " (upcase filename) "_H" n
   n
   p
   n
   "#endif  // " (upcase filename) "_H" n
   )
 "header-protect"
 "Insert the skeleton to protect a header file from multiple inclusion"
 'cpp-convention-tags)


(tempo-define-template
 "cpp-method-definition"
 '(
   "//......................................................................" n
   n
   > (p "Method return type: ") " " classname "::"
   methodname "(" (p "full arg list: ") ") " > n
   > "{"  > n
;   > "// Purpose: " (p "Purpose of method: ") n
;   > "// Args: " (p "Method arguments description: ") n
;   > "// Returns: " (p "Method return value description: ") n
;   > "// Contact: " (p "Contact programmer: ") n
   p n
   "}" n
   n
   )
 "method-definition"
 "Insert skelton of a definition of a method"
 'cpp-convention-tags)

(tempo-define-template
 "cpp-method-declare"
 '( 
   > "/** \\brief " (p "brief description: ") > n
     p
     " *  \\param [ARG1] [brief desc of arg1]" > n
     " *  \\param [ARG2] [brief desc of arg2]" > n
     " *  \\return [brief desc of return value]" > n
     " */" > n 
     p
     > (p "Method return type: ") " " 
     methodname "(" (p "full arg list: ") ")" p ";" 
     )
 "method-declare"
 "Insert the declaration of a method"
 'cpp-convention-tags)

(tempo-define-template
 "cpp-method-inline"
 '( > (p "Method return type: ") " " 
      methodname "(" (p "full arg list: ") ") { " (p "method body: ") " };"
      (indent-for-comment) (p "Short descriptive comment: ")  n )
 "method-inline"
 "Insert inlined method declaration/definition"
 'cpp-convention-tags)

(tempo-define-template
 "cpp-data-member"
 '( > (p "data members type: ") " " datamembername p ";"
      (indent-for-comment) (p "Short descriptive comment: ") n )
 "data-member"
 "Insert a class data member declaration"
 'cpp-convention-tags)

(tempo-define-template
 "cpp-cvs-log"
 '( 
   (indent-for-comment)
   " $" "Log: " "$" n)
   "cvs-log"
   "Insert a CVS Log tag"
   'cpp-convention-tags)

(tempo-define-template
 "cpp-cvs-id"
 '( 
   (indent-for-comment)
   " $" "Id: " "$" n)
 "cvs-id"
 "Insert a CVS Id tag"
 'cpp-convention-tags)


(tempo-define-template
 "cpp-alg-header"
 '(
   n
   > "#include \"GaudiAlg/GaudiAlgorithm.h\"" n
   n
   "class " classname " : public GaudiAlgorithm " n 
   > "{" > n 
   n
   > "public:" > n
   n
   > classname "(const std::string& name, ISvcLocator* pSvcLocator);" > n
   > "virtual ~" classname "(" p ");" > n 
   n
   > "virtual StatusCode initialize();" n
   > "virtual StatusCode execute();" n
   > "virtual StatusCode finalize();" n
   n
   > p n
   "};" n
   )
 "alg-header"
 "Insert an algorithm class skeleton"
 'cpp-convention-tags)


(tempo-define-template
 "cpp-alg-imp"
 '(
   n
   > "#include \"" classname ".h\"" p n
   n
   > classname "::" classname "(const std::string& name, ISvcLocator* pSvcLocator)" n
   > ": GaudiAlgorithm(name,pSvcLocator)" > > n
   > "{" > n
   > "}" > n n
   > classname "::~" classname "()" > n
   > "{" > n
   > "}" > n n
   > "StatusCode " classname "::initialize()" n
   > "{" > n
   > "this->GaudiAlgorithm::initialize();" > n
   n p
   > "return StatusCode::SUCCESS;" > n
   > "}" > n n
   > "StatusCode " classname "::execute()" n
   > "{" > n
   n p
   > "return StatusCode::SUCCESS;" > n
   > "}" > n n
   > "StatusCode " classname "::finalize()" n
   > "{" > n
   n p
   > "return this->GaudiAlgorithm::finalize();" > n
   > "}" > n n
   )
 "alg-imp"
 "Insert an algorithm class skeleton, implementation"
 'cpp-convention-tags)


(tempo-define-template
 "cpp-tool-header"
 '(
   n
   > "#include \"GaudiAlg/GaudiTool.h\"" n
   n
   "class " classname " : public GaudiTool " n 
   > "{" > n 
   n
   > "public:" > n
   n
   > classname "(const std::string& type," > n
   > "const std::string& name," > n
   > "const IInterface* parent);" > n
   > "virtual ~" classname "(" p ");" > n 
   n
   > "virtual StatusCode initialize();" n
   > "virtual StatusCode finalize();" n
   n
   > p n
   "};" n
   )
 "tool-header"
 "Insert a tool class skeleton"
 'cpp-convention-tags)


(tempo-define-template
 "cpp-tool-imp"
 '(
   n
   > "#include \"" classname ".h\"" p n
   n
   > classname "::" classname "(const std::string& type," > n
   > "const std::string& name, " > n
   > "const IInterface* parent)" > n
   > ": GaudiTool(type,name,parent)" > > n
   > "{" > n
   > "}" > n n
   > classname "::~" classname "()" > n
   > "{" > n
   > "}" > n n
   > "StatusCode " classname "::initialize()" n
   > "{" > n
   > "this->GaudiTool::initialize();" > n
   n p
   > "return StatusCode::SUCCESS;" > n
   > "}" > n n
   > "StatusCode " classname "::finalize()" n
   > "{" > n
   n p
   > "return this->GaudiTool::finalize();" > n
   > "}" > n n
   )
 "tool-imp"
 "Insert a tool class skeleton, implementation"
 'cpp-convention-tags)


(tempo-define-template
 "cpp-emacs-file-variables"
 '(
   n
   > "// Local Variables: **" n
   > "// c-basic-offset:4 **" n
   > "// indent-tabs-mode:nil **" n
   > "// End: **" n
   )
 "emacs-file-variables"
 "Insert emacs file variables setting one true C style"
 'cpp-convention-tags)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Some helper functions

(defun down-cased-p (str)
  (or 
   (string< (substring str 0 1) "A") 
   (string< "Z" (substring str 0 1))))

(defun filename-okay-p (fn)
  (if (or
       (not (down-cased-p fn))
       (y-or-n-p "File name should be capitalized, use anyways? "))
      fn
      (error "Canceled")))
(defun get-filename ()
  (filename-okay-p (file-name-sans-extension
		   (file-name-nondirectory buffer-file-name))))

(defun classname-okay-p (cn)
  (if (or 
       (and (not (down-cased-p cn))
	    (string= cn (file-name-sans-extension
			 (file-name-nondirectory buffer-file-name))))
       (y-or-n-p "Class name and file name should be same and capitalized, use anyways? "))
      cn
    (error "Canceled")))
(defun get-classname ()
  (classname-okay-p (read-string "ClassName: " 
				(file-name-sans-extension
				 (file-name-nondirectory buffer-file-name)))))

(defun methodname-okay-p (mn)
  (if (or
       (not (down-cased-p mn))
       (string= (substring mn 0 1) "~")
       (y-or-n-p
	"Methods' first character should be lower cased, use anyways? "))
      mn
    (error "Canceled")))
(defun get-methodname ()
  (methodname-okay-p (read-string "MethodName: ")))

(defun get-current-dirname () 
  (file-name-nondirectory (directory-file-name default-directory)))

(defun packagename-okay-p (pn)
  (if (or 
       (not (down-cased-p pn))
       (y-or-n-p "Package name no capitalized, use anyways? "))
      pn
    (error "Canceled")))       
(defun get-packagename ()
  (packagename-okay-p (read-string "PackageName: " (get-current-dirname))))

(defun datamembername-okay-p (dmn)
  (if (or
       (string= (substring dmn 0 1) "f")
       (y-or-n-p "Data member names should start with `f', use anyways? "))
      dmn
    (error "Canceled")))
(defun get-datamembername () 
  (datamembername-okay-p (read-string "Data member name (should start with `f'): " "f")))

(defun get-message-level ()
  (let ((level-list '(("Verbose" 0)
		      ("Debug" 1)
		      ("Info" 2)
		      ("Warning" 3)
		      ("Error" 4)
		      ("Fatal" 5))))
    (capitalize (completing-read "Message level: "
				 level-list
				 nil
				 t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions callable by user (begin with ``cpp-convention-''

(defun cpp-convention-class ()
  "Insert a C++ class skeleton, following CPP coding conventions"
  (interactive)
  (let* ((classname (get-classname)))
    (tempo-template-cpp-class)))

(defun cpp-convention-method-definition ()
  "Insert a method, following CPP coding conventions"
  (interactive)
  (let ((methodname (get-methodname))
	(classname (get-classname)))
    (tempo-template-cpp-method-definition)))

(defun cpp-convention-method-declare ()
  "Insert a method declaration"
  (interactive)
  (let ((methodname (get-methodname))
	;(classname (get-classname))
	)
    (tempo-template-cpp-method-declare)))

(defun cpp-convention-method-inline ()
  "Insert a inlined method declaration/definition"
  (interactive)
  (let ((methodname (get-methodname))
	(classname (get-classname)))
    (tempo-template-cpp-method-inline)))
  

(defun cpp-convention-header-file ()
  "Insert a C++ header file skeleton, following CPP coding conventions"
  (interactive)
  (let* ((filename (get-filename))
	 (classname (get-classname)))
    (tempo-template-cpp-header-comments)
    (tempo-template-cpp-header-protect)
    (tempo-template-cpp-class)))


(defun cpp-convention-implementation-file ()
  "Insert a C++ class implementation file skeleton, following CPP coding conventions"
  (interactive)
  (let* ((filename (get-filename))
	 (classname (get-classname))
	 (packagename (get-packagename))
	 (methodname (get-methodname)))
    (tempo-template-cpp-header-comments)
    (tempo-template-cpp-implementation-extras)
    (tempo-template-cpp-method-definition)))

(defun cpp-convention-ifdef-else ()
  "Insert a #ifdef-else block"
  (interactive)
  (tempo-template-cpp-ifdef-else))

(defun cpp-convention-ifndef ()
  "Insert a #ifndef block"
  (interactive)
  (tempo-template-cpp-ifndef))

(defun cpp-convention-main ()
  "Insert a main() block"
  (interactive)
  (tempo-template-cpp-main))

(defun cpp-convention-switch ()
  "Insert a switch block"
  (interactive)
  (tempo-template-cpp-switch))

(defun cpp-convention-case ()
  "Insert a switch block"
  (interactive)
  (tempo-template-cpp-case))

(defun cpp-convention-header-comments () 
  "Insert a switch block"
  (interactive)
  (let* ((classname (get-classname)))
    (tempo-template-cpp-header-comments)))

(defun cpp-convention-header-protect ()
  "Insert a switch block"
  (interactive)
  (tempo-template-cpp-header-protect))

(defun cpp-convention-data-member ()
  "Insert declaration of data member"
  (interactive)
  (let* ((datamembername (get-datamembername)))
    (tempo-template-cpp-data-member)))

(defun cpp-convention-cvs-log ()
  "Insert a CVS Log tag"
  (interactive)
  (tempo-template-cpp-cvs-log))

(defun cpp-convention-cvs-id ()
  "Insert a CVS Id tag"
  (interactive)
  (tempo-template-cpp-cvs-id))

(defun cpp-convention-alg-header ()
  "Insert an algorithm class definition"
  (interactive)
  (let* ((classname (get-classname)))
    (tempo-template-cpp-alg-header)))

(defun cpp-convention-alg-imp ()
  "Insert an algorithm implementation"
  (interactive)
  (let* ((classname (get-classname)))
    (tempo-template-cpp-alg-imp)))

(defun cpp-convention-tool-header ()
  "Insert an tool class definition"
  (interactive)
  (let* ((classname (get-classname)))
    (tempo-template-cpp-tool-header)))

(defun cpp-convention-tool-imp ()
  "Insert an tool implementation"
  (interactive)
  (let* ((classname (get-classname)))
    (tempo-template-cpp-tool-imp)))

(defun cpp-convention-emacs-file-variables ()
  "Insert file variables setting one true C style"
  (interactive)
  (tempo-template-cpp-emacs-file-variables))

(defun cpp-convention ()
  "Insert some skeleton of code following CPP coding conentions"
  (interactive)
  (let ((filename (file-name-sans-extension 
		   (file-name-nondirectory buffer-file-name)))
	(comp-list '(("header-file" 1)
		     ("implementation-file" 2) 
		     )))

    (if cpp-convention-expert
	(setq comp-list 
	      (append comp-list '(
				  ("method-definition" 3)
				  ("method-declare" 4)
				  ("method-inline" 4)
				  ("class" 5)
				  ("ifdef-else" 6)
				  ("ifndef" 7)
				  ("main" 8)
				  ("switch" 9)
				  ("case" 10)
				  ("data-member" 11)
				  ("header-protect" 12)
				  ("header-comments" 13)
				  ("cvs-log" 14)
				  ("cvs-id" 15)
				  ("alg-header" 16)
				  ("alg-imp" 17)
				  ("tool-header" 18)
				  ("tool-imp" 19)
				  ("emacs-file-variables" 20)
				  ))))

    (eval (read (concat "(cpp-convention-"
			(completing-read "Block name: " 
					 comp-list
					 nil
					 t)
			")")))))

(setq cpp-convention-verbose nil)
(setq cpp-convention-expert t)

;; Tell what file extentions should trigger c++-mode
(setq auto-mode-alist (append 
		       (mapcar 'purecopy
			       '(("\\.h$" . c++-mode)
				 ("\\.C$" . c++-mode)
				 ("\\.c$" . c++-mode)
				 ("\\.cc$" . c++-mode)
				 ("\\.cpp$" . c++-mode)
				 ("\\.cxx$" . c++-mode)))
		       auto-mode-alist))
      
;; Set up c++-mode.  You can pick and choose from the ones in the
;; optional section and still be w/in conventions
(defun my-c++-mode-common-hook ()

  ;; Required:
  (cpp-conventions)  
  (c-set-style "cc-mode")
  (setq c-indent-level 4)
  (setq c-indent-comments-syntactically-p t)
  (setq indent-tabs-mode nil)

  ;; Optional:
  (local-set-key "\C-c\C-c" 'compile)
  (local-set-key "\C-ct" 'toggle-source)
  )
(add-hook 'c++-mode-hook 'my-c++-mode-common-hook)


