(module
  (type $t (func (param i32 i32 i32 i32) (result i32)))

  ;; Import the required fd_write WASI function which will write the given io vectors to stdout
  ;; The function signature for fd_write is:
  ;; (File Descriptor, *iovs, iovs_len, nwritten) -> Returns number of bytes written
  (import "wasi_unstable" "fd_write" (func $fd_write (type $t)))
  (import "wasi_unstable" "fd_read" (func $fd_read (type $t)))

  (memory 1)
  (export "memory" (memory 0))

  ;; -----------------------------------------------------------------------------------------------------
  ;; NOTE: memory starts at index 8 - everything below that (index 0 and 4) is reserved for read and write
  ;; -----------------------------------------------------------------------------------------------------


  (global $MAX_INPUT_LEN i32 (i32.const 256)) ;; max number of characters to input

  (global $CIPHERTEXT_ADDR i32 (i32.const 256))
  (global $KEY_ADDR i32 (i32.const 384))
  (global $RES_ADDR i32 (i32.const 512))
  (global $RC4_S_ADDR i32 (i32.const 3072))
  (global $USAGE_ADDR i32 (i32.const 4224))

  (global $CIPHERTEXT_LEN i32 (i32.const 6))
  (global $KEY_LEN (mut i32) (i32.const 5))
  (global $RES_LEN i32 (i32.const 8))
  (global $USAGE_LEN i32 (i32.const 293))

  ;; -----------------------------------------------------------------------------------------------------------------------------------------
  ;; NOTE: These offsets have to match the globals above. However, data does not support using globals as offsets, so the address is constant
  ;; -----------------------------------------------------------------------------------------------------------------------------------------

  ;; Ciphertext
  ;; (data (global.get $CIPHERTEXT_ADDR) "...")
  (data (i32.const 256) "\49\fd\82\d8\04\8f")

  ;; Key prompt
  ;;(data (global.get $KEY_ADDR) "Key: ")
  (data (i32.const 384) "Key: ")

  ;; Key prompt
  ;;(data (global.get $RES_ADDR) "Output: ")
  (data (i32.const 512) "Output: ")

  ;; Usage string
  ;;(data (global.get $USAGE_ADDR) "...")
  (data (i32.const 4224) "There are three primes in this puzzle. One of them is 3539, the other two are in the image. Multiply them together to get the key to decrypt the ciphertext embedded in this program. Enter this key below. If the output is not valid ASCII that matches the password requirement, the key is wrong.")

  (func $print_one (param $val i32)
	(i32.store (i32.const 8) (local.get $val))
	(call $print (i32.const 8) (i32.const 1))
	)

  ;; Print to console, where addr is the address of the text to be printed in memory, and len is the length of the text
  (func $print (param $addr i32) (param $len i32)
	(i32.store (i32.const 0) (local.get $addr))
	(i32.store (i32.const 4) (local.get $len))

	(drop 
	  (call $fd_write
            (i32.const 1) ;; file_descriptor - 1 for stdout
            (i32.const 0) ;; *iovs - The pointer to the iov array, which is stored at memory location 0
            (i32.const 1) ;; iovs_len - We're printing 1 string stored in an iov - so one.
            (i32.const 0) ;; nwritten - A place in memory to store the number of bytes written. We don't care about this, so just writing it to a place which I know will be overwritten in the future
	    )
	  ) ;; Discard the number of bytes written from the top of the stack
	)

  ;; A convenience function that reads a line of input from stdin. Note that this respects the $MAX-INPUT_LEN global.
  ;; The $addr param is the address to store the input at
  ;; Returns the number of bytes read. It is guaranteed that this is 0 <= x <= MAX_INPUT_LEN.
  (func $input (param $addr i32) (result i32)
	(i32.store (i32.const 0) (local.get $addr))
	(i32.store (i32.const 4) (global.get $MAX_INPUT_LEN))

	(drop
	  (call $fd_read
		(i32.const 0) ;; file_descriptor - 0 for stdin
		(i32.const 0) ;; *iovs - The pointer to the iov array, which is stored at memory location 0
		(i32.const 1) ;; iovs_len - We're printing 1 string stored in an iov - so one.
		(i32.const 0) ;; nwritten - A place in memory to store the number of bytes written. We don't care about this, so just writing it to a place which I know will be overwritten in the future
		)
	  )

	(i32.sub (i32.load (i32.const 0)) (i32.const 1))
	)

  ;; Swaps two indeces in the S array
  ;; In Python:
  ;; S[i], S[j] = S[j], S[i]
  (func $swap (param $i1 i32) (param $i2 i32) (local $e1 i32) (local $e2 i32)
	(local.set $e1
	  (i32.load8_u
	    (i32.add (global.get $RC4_S_ADDR) (local.get $i1))
	    )
	  )

	(local.set $e2
	  (i32.load8_u
	    (i32.add (global.get $RC4_S_ADDR) (local.get $i2))
	    )
	  )
	
	(i32.store8
	  (i32.add (global.get $RC4_S_ADDR) (local.get $i2))
	  (local.get $e1)
	  )
	(i32.store8
	  (i32.add (global.get $RC4_S_ADDR) (local.get $i1))
	  (local.get $e2)
	  )
	)

  (func $ksa (local $i i32) (local $j i32)
	;; --------------------------------------------------------
	;; The array "S" is initialized to the identity permutation
	;; --------------------------------------------------------

	;; i is initialized to negative 1 because 1 is added to i in the beginning of the loop, making it 0
	(local.set $i (i32.const -1))
	(loop $for
	      ;; Add 1 to i
	      (local.set $i (i32.add (local.get $i) (i32.const 1)))

	      ;; ---------
	      ;; S[i] := i
	      ;; ---------
	      (i32.store8 (i32.add (global.get $RC4_S_ADDR) (local.get $i)) (local.get $i))

	      ;; continue while i < 256 for a total of 256 iterations, 0...255
	      ;; go to $for if i < 256 is true
	      (br_if $for (i32.lt_s (local.get $i) (i32.const 256)))
	      )

	;;(call $print (global.get $RC4_S_ADDR) (i32.const 256))

	;; ------------------------------------------------------------------------------------------------------------------------------
	;; S is then processed for 256 iterations in a similar way to the main PRGA, but also mixes in bytes of the key at the same time.
	;; ------------------------------------------------------------------------------------------------------------------------------

	(local.set $j (i32.const 0))

	;; i is initialized to negative 1 because 1 is added to i in the beginning of the loop, making it 0
	(local.set $i (i32.const -1))
        (loop $for
              ;; Add 1 to i
	      (local.set $i (i32.add (local.get $i) (i32.const 1)))

	      ;; ----------------------------------------------
	      ;; j := (j + S[i] + key[i mod keylength]) mod 256
	      ;; ----------------------------------------------

	      ;; j := (j + S[i] + key[i mod keylength]) mod 256
	      (local.set $j
	        ;; (j + S[i] + key[i mod keylength]) mod 256
		(i32.rem_u
		  ;; (j + S[i] + key[i mod keylength])
		  (i32.add
		    ;; (j + S[i])
		    (i32.add
		      (local.get $j)
		      (i32.load8_u 
			(i32.add 
			  (global.get $RC4_S_ADDR) 
			  (local.get $i)
			  )
			)
		      )
		    (i32.load8_u 
		      (i32.add 
			(global.get $KEY_ADDR) 
			(i32.rem_u 
			  (local.get $i) 
			  (global.get $KEY_LEN)
			  )
			)
		      )
		    )
		  (i32.const 256)
		  )
		)

	      ;; ----------------------------
	      ;; swap values of S[i] and S[j]
	      ;; ----------------------------
	      (call $swap (local.get $i) (local.get $j))

	      	      
              ;; continue while i < 256 for a total of 256 iterations, 0...255
              ;; go to $for if i < 256 is true
              (br_if $for (i32.lt_s (local.get $i) (i32.const 256)))
              )
	)

  (func $prga (local $loop_index i32) (local $i i32) (local $j i32) (local $K i32)
	(local.set $loop_index (i32.const -1))
	(local.set $i (i32.const 0))
	(local.set $j (i32.const 0))

	(loop $for
	      ;; Increment loop_index
	      (local.set $loop_index (i32.add (local.get $loop_index) (i32.const 1)))

	      ;;---------------------
	      ;; i := (i + 1) mod 256
	      ;;---------------------
	      (local.set $i
	        (i32.rem_u
		  (i32.add
		    (local.get $i)
		    (i32.const 1)
		    )
		  (i32.const 256)
		  )
		)
	      
	      ;;------------------------
	      ;; j := (j + S[i]) mod 256
	      ;;------------------------
	      (local.set $j
	        (i32.rem_u
		  (i32.add
		    (local.get $j)
		    (i32.load8_u
		      (i32.add
			(global.get $RC4_S_ADDR)
			(local.get $i)
			)
		      )
		    )
		  (i32.const 256)
		  )
		)

	      ;;-----------------------------
	      ;; swap values of S[i] and S[j]
	      ;;-----------------------------
	      (call $swap (local.get $i) (local.get $j))


	      ;;------------------------------
	      ;; K := S[(S[i] + S[j]) mod 256]
	      ;;------------------------------
	      (local.set $K
	        (i32.load8_u
		  (i32.add
		    (global.get $RC4_S_ADDR)
		    (i32.rem_u
		      (i32.add
			(i32.load8_u
			  (i32.add
			    (global.get $RC4_S_ADDR)
			    (local.get $i)
			    )
			  )
			(i32.load8_u
			  (i32.add
			    (global.get $RC4_S_ADDR)
			    (local.get $j)
			    )
			  )
			)
		      (i32.const 256)
		      )
		    )
		  )
	        )

	      ;; -----------------------------------------------------------------------------------------
	      ;; Thus, this produces a K which is XOR'ed with the plaintext at loop_index to obtain the ciphertext. 
	      ;; ciphertext[loop_index] = plaintext[loop_index] ⊕ K .
	      ;; -----------------------------------------------------------------------------------------

	      (i32.store8
		(i32.add
		  (global.get $CIPHERTEXT_ADDR)
		  (local.get $loop_index)
		  )
		(i32.xor
		  (i32.load8_u
		    (i32.add
		      (global.get $CIPHERTEXT_ADDR)
		      (local.get $loop_index)
		      )
		    )
		  (local.get $K)
		  )
		)

              ;; continue while $loop_index < $CIPHERTEXT_LEN for a total of CIPHERTEXT_LEN iterations, 0...$CIPHERTEXT_LEN-1
              ;; go to $for if i < $CIPHERTEXT_LEN is true
              (br_if $for (i32.lt_s (local.get $loop_index) (global.get $CIPHERTEXT_LEN)))
              )
	)

  ;; This is the entry point to the program
  ;; It implements RC4
  ;; It can be used to both encrypt, and decrypt, because RC4 is a two-way cipher that just uses XOR
  (start $main)
  (export "main" (func $main))
  (func $main (local $bytes_read i32)
	(call $print (global.get $USAGE_ADDR) (global.get $USAGE_LEN))

	;; Print a new line character
    (call $print_one (i32.const 10))

	;; Print the key prompt and store the key at the same address
	(call $print (global.get $KEY_ADDR) (global.get $KEY_LEN))
	(global.set $KEY_LEN
	  (call $input (global.get $KEY_ADDR))
	  )

	(call $ksa)
	(call $prga)

	(call $print (global.get $RES_ADDR) (global.get $RES_LEN))
	(call $print (global.get $CIPHERTEXT_ADDR) (global.get $CIPHERTEXT_LEN))

	;; Print a new line character
	(call $print_one (i32.const 10))
	)
  )
  
