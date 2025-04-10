.text
.global main
main:
    mov x2, # 0b11110000         /* x2 <- 11110000 */
    mov x3, # 0b10101010         /* x3 <- 10101010 */
    and x0, x2, x3               /* x0 <- x2 AND x3 */
    orr x1, x2, x3               /* x1 <- x2 OR x3 */
    mvn x4, x0                   /* x4 <- NOT x0 */
    mov x0, # 0x80000000         /* x0 <- 0x80000000 */
    tst x0, # 0x80000000         /* Test bit 31 of x0 */
    tst x0, # 0x40000000         /* Test bit 30 of x0 */
    ret

/* La instrucción tst hace la operación and entre un registro y una máscara y sólo
actúa sobre los flags. */