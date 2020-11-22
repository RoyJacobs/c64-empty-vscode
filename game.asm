.segmentdef Upstart [start=$0801]
.segmentdef Code [start=$8000]
.file [name="game.prg", segments="Upstart, Code"]

.segment Upstart
BasicUpstart2(start)

.segment Code
start:
    sei

    // Disable CIA interrupts
    lda #$7f
    sta $dc0d
    sta $dd0d
    lda $dc0d
    sta $dc0d

    // Enable Raster Interrupts
    lda #$01
    sta $d01a

    // Set IRQ
    lda #<IRQ
    ldx #>IRQ
    sta $fffe
    stx $ffff

    // Set line
    lda $d011
    and #$7f
    sta $d011
    lda #123
    sta $d012

    // Bank out kernel and basic
    lda #$35
    sta $01

    // Set colors
    lda #$00
    sta $d020
    sta $d021 

    // Ack interrupt
    asl $d019
    cli

!loop:
    jmp !loop-

IRQ:
    asl $d019
    inc $d020
    inc $d021
    dec $d021
    dec $d020
    rti