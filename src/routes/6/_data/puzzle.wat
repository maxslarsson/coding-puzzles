(module
  ;; Import the required fd_write WASI function which will write the given io vectors to stdout
  ;; The function signature for fd_write is:
  ;; (File Descriptor, *iovs, iovs_len, nwritten) -> Returns number of bytes written
  (import "wasi_unstable" "fd_write" (func $fd_write (param i32 i32 i32 i32) (result i32)))

  (memory 1)
  (export "memory" (memory 0))

  ;; -----------------------------------------------------------------------------------------------------
  ;; NOTE: memory starts at index 6 - everything below that (index 0 and 4) is reserved for read and write
  ;; -----------------------------------------------------------------------------------------------------

  (global $MESSAGE_ADDR i32 (i32.const 8))

  ;; Length of 7 with newline at end
  (global $MESSAGE_LEN i32 (i32.const 7))


  ;; The encrypted ciphertext
  (data (i32.const 8) "\29\77\26\24\26\22\1b")

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

  ;; This is the entry point to the program
  ;; It does a simple XOR and prints the password
  ;; It can be used to both encrypt, and decrypt, because RC4 is a two-way cipher that just uses XOR
  (start $main)
  (export "main" (func $main))
  (func $main (local $i i32)
    (local.set $i (i32.const -1))
    (loop $for
        ;; Add 1 to i
        (local.set $i (i32.add (local.get $i) (i32.const 1)))

        ;; Message[i] = message[i] ^ 17
        (i32.store8
            (i32.add (global.get $MESSAGE_ADDR) (local.get $i))
            (i32.xor
                (i32.load8_u (i32.add (global.get $MESSAGE_ADDR) (local.get $i)))
                (i32.const 17)
            )
        )

        ;; continue while i < MESSSAGE_LEN
        ;; go to $for if i < MESSAGE_LEN is true
        (br_if $for (i32.lt_s (local.get $i) (global.get $MESSAGE_LEN)))
    )
	(call $print (global.get $MESSAGE_ADDR) (global.get $MESSAGE_LEN))
	)
  )
  
