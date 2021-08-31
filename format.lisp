(format t "~$" pi)

(format t "~10$" pi)

(format t "~100$" pi)

(format t "~v$" 4 pi)

(format t "~#$" pi)

(format t "~,4f" pi)

(format t "~,vf" 4 pi)

(format t "~d" pi)

(format t "~d" 10)

(format t "~:d" 100000)

(format t "~@d" 100000)

(format t "~:@d" 100000)

(format t "~@:d" 1000000)

(format t "The value is: ~a" 10)

(format t "The value is: ~a" "Hello!")

(format t "The value is: ~a" (list 1 2 3 4))

(format t "The value is: ~:a" nil)

(format t "The value is: ~s" (list 1 2 3 4))

(format t "The value is: ~s" "Hey there!")

; weirdness here (each element of the list has a large number of newlines
; between it and the next); figure out the padding options to ~a some other
; time
(format t "The values are ~25a and ~a" (list 1 2 3 25) (list 36 49 64 81))

(format t "I'm on my own line.~&So am I, nice!")

(format t "There is an extra newline below me.~%~%Yes, there is.")

(format t "I'm on my own line.~%~&There is no extra newline above me!")

(format t "Here's how you escape the tilde character: ~~")

(format t "Here's a character: ~c" #\Space)

(format t "Here it is again, visible this time: ~:c" #\Space)

(format t "Another, readably: ~@c" #\Backspace)

(format t "A weird one: ~:@c" (code-char 0))

(format t "~a" 4)

(format t "~s" 4)

(format t "~a" "Hey there!")

(format t "~s" "Hey there!")

(format t "~a" #b1001)

(format t "~s" #b1110)

(format t "~d" #b1011)

(format t "~:d" #b1111101000)

(format t "~:@d" #b10011100010000)

(format t "~10,'.d" 100000000)

(format t "~10,'.d" 1000)

(format t "~4,'0d-~2,'0d-~2,'0d" 2005 5 25)

(format t "~,,'@,4:d" 1000000000)

(format t "~48,'#,:b" 10000)

(format t "~3r" 1001)

(format t "~,4f" 3.14159265)

(format t "~,4e" 3.1415926535)

(format t "~,4e" 14000000.16)

(format t "~9$" 3.1415926535)

(format t "~9@$" 3.14159265)

(format t "~r" 9)

(format t "~@r" 9)

(format t "~@r" 16)

(format t "~@r" 10000)

(format t "~@r" 4)

(format t "~:@r" 4)

(format t "~:@r" 9)

(format t "pooling~p" 0)

(format t "pooling~p" 1)

(format t "pool~p" 10)

(format t "~:@r pool~:p" 4)

(format t "~:@r famil~:@p" 1)

(format t "~:@r famil~:@p" 4)

(format t "~(~:@r~) famil~:@p" 4)

(format t "~(~a~)" "The monstrous gigantor!")

(format t "~:(~a~)" "The diminutive mouse!")

(format t "~@(~a~)" "the mighty eagle!")

(format t "~@(~a~)" "the screaming turtle")

(format t "~[cero~;uno~;dos~]" 0)

(format t "~[cero~;uno~;dos~]" 1)

(format t "~[\"cero\"~;\"uno\"~;\"dos\"~]" 2)

(format t "~[cero~;uno~:;dos~]" 3)

(format t "~[cero~;uno~:;dos~]" 100)

(format t "~#[Empty argument list~;~a~;~a and ~a~:;~a, ~a, ~]~#[~;and ~a~:;~a, etc~].")

(format t "~#[Empty argument list~;~a~;~a and ~a~:;~a, ~a, ~]~#[~;and ~a~:;~a, etc~]." 'a)

(format t "~#[Empty argument list~;~a~;~a and ~a~:;~a, ~a, ~]~#[~;and ~a~:;~a, etc~]." 'a 'b)

(format t "~#[Empty argument list~;~a~;~a and ~a~:;~a, ~a, ~]~#[~;and ~a~:;~a, etc~]." 'a 'b 'c)

(format t "~#[Empty argument list~;~a~;~a and ~a~:;~a, ~a, ~]~#[~;and ~a~:;~a, etc~]." 'a 'b 'c 'd)

(format t "~#[Empty argument list~;~a~;~a and ~a~:;~a, ~a, ~]~#[~;and ~a~:;~a, etc~]." 'a 'b 'c 'd 'e)

(format t "~:[The argument was false.~;The argument was true!~]" nil)

(format t "~:[The argument was false.~;The argument was true!~]" t)

(format t "~@[~a~]" nil)

(format t "~@[~a~]" t)

(format t "~{~a~%~}" (list 1 2 3))

(format t "~{~a, ~}" (list 1 2 3))

(format t "~{~a~^, ~}" (list 1 2 3))

(format t "~@{~a~%~}" 1 2 3 4)

(format t "~@{~a~^, ~}" 1 2 3 4)

(format t "~{~#[~;~a~:;~a and ~]~}" (list 1 2 3))

(format t "~{~#[~;~a~;~a and ~a~:;~@{~#[~;and ~a~:;~a, ~]~}~]~}" (list 1 2 3 4))

(format t "~{~#[No elements in list.~;~a~;~a and ~a~:;~@{~#[~;and ~a~:;~a, ~]~}~]~:}" (list))

(format t "~r" 1)

(format t "~r ~:*~d" 1)

(format t "I saw ~r el~:*~[ves~;f~:;ves~]" 0)

(format t "I saw ~r el~:*~[ves~;f~:;ves~]" 1)

(format t "I saw ~r el~:*~[ves~;f~:;ves~]" 2)

(format t "I saw ~r el~:*~[ves~;f~:;ves~]" 3)

(format t "I saw ~r el~:*~[ves~;f~:;ves~]" 4)

(format t "~{~a ~*~}" (list :a 1 :e 4 :r 16 :p 1024))

(format t "~{~s~^ ~*~}" '(:a 1 :e 4 :r 16 :p 1024))

(format t "~4@*~a" "not definite" "one" "two" "three" "four")
