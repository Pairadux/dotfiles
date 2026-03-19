; Stores the source image path between import and export.
; Valid as long as the Script-Fu interpreter is alive (i.e. your GIMP session).
(define *wallpaper-source-path* "")

; ── Helper: join a list of strings with a separator ────────────────────────
(define (str-join parts sep)
  (if (null? (cdr parts))
    (car parts)
    (string-append (car parts) sep (str-join (cdr parts) sep))))


; ── IMPORT: load as layer, remember the path ───────────────────────────────
(define (script-fu-wallpaper-import image drawables source-path)
  (let ((layer (car (gimp-file-load-layer RUN-NONINTERACTIVE image source-path))))
    (gimp-image-insert-layer image layer 0 -1)
    (set! *wallpaper-source-path* source-path)
    (gimp-displays-flush)))

(script-fu-register-filter
  "script-fu-wallpaper-import"
  "Wallpaper Import..."
  "Import source image as layer and remember its path for export"
  "Austin Gause" "" "2026"
  "*"
  SF-ONE-OR-MORE-DRAWABLE
  SF-FILENAME "Source Image" "")

(script-fu-menu-register "script-fu-wallpaper-import" "<Image>/File")


; ── EXPORT: build output path, flatten, export, close ──────────────────────
(define (script-fu-wallpaper-export image drawables)
  (if (string=? *wallpaper-source-path* "")
    (gimp-message "No source path recorded — run Wallpaper Import first.")
    (let* (
           ; e.g. "/home/austin/pics/sunset.jpg"
           ; → parts: ("" "home" "austin" "pics" "sunset.jpg")
           (all-parts   (strbreakup *wallpaper-source-path* "/"))

           ; last element is the filename, everything before is the dir
           (filename    (car (reverse all-parts)))
           (dir-parts   (reverse (cdr (reverse all-parts))))
           (dir         (str-join dir-parts "/"))

           ; strip the extension: "sunset.jpg" → "sunset"
           (name-parts  (strbreakup filename "."))
           (name-noext  (str-join (reverse (cdr (reverse name-parts))) "."))

           ; final output path: "/home/austin/pics/sunset-wallpaper.png"
           (output      (string-append dir "/" name-noext "-wallpaper.png")))

      (gimp-image-flatten image)
      (file-png-export
        #:run-mode RUN-NONINTERACTIVE
        #:image    image
        #:file     output
        #:options  -1
        #:interlaced      #f
        #:compression     9
        #:bkgd            #t
        #:offs            #f
        #:phys            #t
        #:time            #t
        #:save-transparent #t
        #:optimize-palette #f
        #:format          "auto"
        #:include-exif    #f
        #:include-iptc    #f
        #:include-xmp     #f
        #:include-color-profile #f
        #:include-thumbnail     #f
        #:include-comment       #f)

      (gimp-image-delete image))))

(script-fu-register-filter
  "script-fu-wallpaper-export"
  "Wallpaper Export"
  "Flatten and export next to source with -wallpaper suffix, then close"
  "Austin Gause" "" "2026"
  "*"
  SF-ONE-OR-MORE-DRAWABLE)

(script-fu-menu-register "script-fu-wallpaper-export" "<Image>/File")
