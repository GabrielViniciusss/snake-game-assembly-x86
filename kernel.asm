org 0x7e00
jmp 0x0000:menu

constantes:
    venceuString db "Parabens! Voce eh o Rei do snake game"
    menuString db "Pressione ENTER para comecar o jogo"
    menuImg db 
    regrasString db "Pressione SPACE para ver as regras" ;34
    regra1 db "Ganhe comendo 10 uvas!" ;22
    caso db "Voce perde se:" ;14
    regra2 db ".Bater com a cabeca no proprio corpo" ;36
    regra3 db ".Passar dos limites da tela" ;27
    voltaMenu db "Aperte ESC para voltar ao menu";30
    controles db "Controles:" ;10
    controleW db "W - vai para cima" ;17
    controleA db "A - vai para esquerda";21
    controleS db "S - vai para baixo";18
    controleD db "D - vai para direita";20
    perdeuString1 db "Muito fraco!"
    perdeuString2 db "Se quiser tentar de novo pressione SPACE" ;40
    perdeuString3 db "Caso contrario,pressione ESC" ;28
    stringBy db "Produzido por:"
    stringLaga db  "Laga el Demonio Louco-agcs2"
    stringBiel db  "Texas matador de galinha-gvab"
    stringDoubo db "Doubo o ultimo romantico-jvcn"
    

    largura equ 80 ;VGA color text mode 80x25
    altura  equ 25

    corUva equ 05F8h  ;F8 é o ascii de uma bolinha, 5 é a cor que desejo printar ela(roxo)
    corCobra equ 04FEh ;FE é o ascii do quadrado que será o corpo da cobra,de cor vermelha(4) 
    corBackGround equ 0020h ;background sera preto, preenchido por ' '

    ;cor: [4bits][4bits][Ascii da letra] , primeiro grupo de 4 bits é a cor do background , segundo é a cor do caractere (foreground)
    ;printamos passando a word para cada caractere da tela, por meio do es:di(atraves do offset na memoria em video)
    ;ex:
    ;xor di,di
    ;mov ax,0F42h 0-background preto, F- foreground branco, 42 ascii da letra B
    ;stosw
    ;printa o caractere b na posiçao (0,0), pois nao foi dado offset(em bytes) a di

    maximoUva equ 17  ;quando a cobra comer 10 uvas o jogador ganha, e o valor da largura da cobra será 21 nesse momento

    cobraArrayX equ 500h ;porçao da memoria q vou usar para guardar os valores de x e y do corpo da cobra
    cobraArrayY equ 700h

    uvasPegas equ 900h;porçao da memoria para saber quantas uvas o player ja pegou

variaveis:
    cobraX: dw 40 ; A principio, a cobra vai estar no centro da tela e tera 1 de largura.
    cobraY: dw 13                                                                         
    larguraCobra: dw 1

    uvaX: dw 74   ; A principio, a uva vai ta na posiçao (74,16) coluna 74, linha 16 (lembrando que é 0-indexed)
    uvaY: dw 16
    
    direcaoAtual: db 4 ;0 se move pra cima, 1 para baixo, 2 para a esquerda, 3 para direita

menu:
    xor ax,ax

    mov bp,ax ;ponteiros para string
    mov es,ax

    mov ah,0   ; modo de video vga graphics 320x200
    mov al,13h
    int 10h 

    ;printando strings do menu
    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 15 ;cor dos caracteres
    mov dh, 5;linha
    mov dl, 3;coluna
    mov cx, 35 ;numero de caracteres
    mov bp, menuString ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 15 ;cor dos caracteres
    mov dh, 8;linha
    mov dl, 3;coluna
    mov cx, 34 ;numero de caracteres
    mov bp, regrasString ;offset da string
    int 10h
    
    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 9 ;cor dos caracteres
    mov dh, 14;linha
    mov dl, 0;coluna
    mov cx, 10 ;numero de caracteres
    mov bp, controles ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 9 ;cor dos caracteres
    mov dh, 16;linha
    mov dl, 3;coluna
    mov cx, 17 ;numero de caracteres
    mov bp, controleW ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 9 ;cor dos caracteres
    mov dh, 18;linha
    mov dl, 3;coluna
    mov cx, 21 ;numero de caracteres
    mov bp, controleA ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 9 ;cor dos caracteres
    mov dh, 20;linha
    mov dl, 3;coluna
    mov cx, 18 ;numero de caracteres
    mov bp, controleS ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 9 ;cor dos caracteres
    mov dh, 22;linha
    mov dl, 3;coluna
    mov cx, 20 ;numero de caracteres
    mov bp, controleD ;offset da string
    int 10h

    mov ah,0 ;lendo input do player, se ele nao digitar nada fica preso aqui
    int 16h 

    cmp al,13     ;se for enter vamos pro jogo
    je ModoDeVideo

    cmp al,20h    ;se for espaço vamos para as regras
    je regrasMenu

    jmp menu ;caso o player digite algo que nao seja ENTER

regrasMenu:
    xor ax,ax

    mov bp,ax ;ponteiros para string
    mov es,ax

    mov ah,0   ; modo de video vga graphics 320x200
    mov al,13h
    int 10h
    
    ;printando strings do menu de regras
    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 10 ;cor dos caracteres
    mov dh, 3;linha
    mov dl, 8;coluna
    mov cx, 22 ;numero de caracteres
    mov bp, regra1 ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 4 ;cor dos caracteres
    mov dh, 7;linha
    mov dl, 3;coluna
    mov cx, 14 ;numero de caracteres
    mov bp, caso ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 4 ;cor dos caracteres
    mov dh, 10;linha
    mov dl, 3;coluna
    mov cx, 36 ;numero de caracteres
    mov bp, regra2 ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 4 ;cor dos caracteres
    mov dh, 13;linha
    mov dl, 3;coluna
    mov cx, 27 ;numero de caracteres
    mov bp, regra3 ;offset da string
    int 10h

    mov ah, 13h ;chamada para printar
    mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
    mov bl, 15 ;cor dos caracteres
    mov dh, 17;linha
    mov dl, 3;coluna
    mov cx, 30 ;numero de caracteres
    mov bp, voltaMenu ;offset da string
    int 10h
    
    mov ah,0 ;lendo input do player, se ele nao digitar nada fica preso aqui
    int 16h

    cmp al,27 ; se for esc volta pro menu
    je menu

    jmp regrasMenu ; se nao for fica preso no menu de regras

ModoDeVideo:       ; modo texto 80x25 caracteres, 16 cores VGA
    mov ah,0        
    mov al,03h   
    int 10h

    mov ax,0B800h ;memoria de video padrao do VGA color text mode(scrn addr) para poder printar na tela
    mov es,ax ; ES:DI aponta para B800:0000, que é a memoria de video

    mov ax, [cobraX]          ;setando a posiçao inicial da cobra, [cobraX] e [cobraY] sao as regioes na memoria que tem o x e y da cabeça da cobra;x=coluna,y=linha
    mov word [cobraArrayX],ax
    mov ax, [cobraY]
    mov word [cobraArrayY],ax

main:
    mov ax, corBackGround ;toda vez que entramos no loop limpamos a tela, e printamos o background preto
    xor di,di  
    mov cx,largura*altura ;quantos caracteres temos no maximo em 80x25
    rep stosw ;stosw = mov [es:di],ax + inc di, vai repetir cx vezes.;printando ' ' com background preto em toda a tela
                  
    xor bx,bx    ;bx sera o index do array na memoria
    mov ax,corCobra ; sera printado na posiçao certa ' ' com background vermelho
    mov cx, [larguraCobra] ; contador do loop (quantos segmentos a cobra tem?)
    desenhaCobra:
        imul di, [cobraArrayY+bx],largura*2 ;para achar a linha Y: percorrer 80 caracteres Y vezes, cada caractere é 2bytes, logo Y(offset) = 80x2xY bytes
        imul dx, [cobraArrayX+bx],2 ;para achar a coluna é só multiplicar X por 2(offset)
        add di,dx  ;primeiro achamos o offset da linha, depois somamos com o offset da coluna para printar na posiçao certa
        stosw  
        add bx,2 ; como os elementos do array sao words(2bytes), o proximo index sera bx + 2
        dec cx   ;decrementando o contador
        cmp cx,0
        jne desenhaCobra ; se nao for 0 ainda tem partes da cobra pra desenhar
    
    desenhaUva:                     
        imul di,[uvaY],largura*2 ;mesma logica aqui
        imul dx,[uvaX],2
        add di,dx                         
        mov ax, corUva
        stosw
          
    atualizaDirecao:
        mov al,[direcaoAtual] 

        cmp al,0              ;0 sobe
        je subindo

        cmp al,1              ;1 desce
        je descendo

        cmp al,2              ;2 vai pra esq
        je esquerda

        cmp al,3              ;3 vai pra direita
        je direita

        jmp atualizaCobra ;sempre atualizamos a cobra, assim que entrar ela estara parada até que seja apertada alguma tecla de movimento
 
    atualizaCabeca:   ;pega a posiçao atual da cabeça(mas nao coloca no array ainda, pq agt precisa da posiçao anterior para animar os segmentos de tras)

        subindo:      ;para subir, subimos uma linha, ou seja, decrementamos a posiçao Y da cabeça da cobra
            dec word [cobraY] 
            jmp atualizaCobra
        
        descendo:             ;mesma logica de cima
            inc word [cobraY] 
            jmp atualizaCobra

        esquerda:
            dec word [cobraX] ; para ir para esquerda na tela, basta decrementarmos a coluna, posiçao X da cabeça da cobra
            jmp atualizaCobra

        direita:              ;mesma logica de cima
            inc word [cobraX] 

    atualizaCobra: ;loop que vai animar de fato a cobra. Cada segmento ocupara a posiçao do seu posterior, de tras para frente ate chegar na cabeça que n está ainda com sua posiçao atualizada no array
        imul bx,[larguraCobra],2 ;offset total de todos os elementos, bx indica inicio de um futuro novo elemento
        loop:
            mov ax,[cobraArrayY-2+bx] ;para pegar o offset do ultimo elemento, temos q pegar o offset total e subtrair dois bytes(pois sao words). Ex: [2][2][2]bx -> bx - 2 = [2][2]bx, assim bx indica o começo do ultimo elemento
            mov word [cobraArrayY+bx],ax ;agora o elemento que está na frente(na memoria) tera a posiçao do que está atras

            mov ax,[cobraArrayX-2+bx] ;mesma logica, so que para posiçao X agr
            mov word[cobraArrayX+bx],ax

            sub bx,2     ;indo pro proximo elemento do array
            cmp bx,0     
            jne loop   ;se for 0 é pq ja copiamos a posiçao antiga da head para o elemento atras dela, entao podemos sair do loop
    
        mov ax,[cobraX]            ;atualizando a posiçao atual da cabeça nos arrays
        mov word [cobraArrayX],ax
        mov ax,[cobraY]
        mov word [cobraArrayY],ax

    CasosDerrota:
        ;passar dos limites da tela
        mov ax,[cobraX]
        cmp ax,-1        ;limite lateral esquerdo da tela
        je perdeu
        cmp ax,largura   ;limite lateral direito da tela
        je perdeu

        mov ax,[cobraY]
        cmp ax,-1         ;limite superior da tela
        je perdeu
        cmp ax,altura     ;limite inferior da tela
        je perdeu

        ;bater no proprio corpo
        mov ax, [larguraCobra]
        cmp ax,1               ; se a cobra só tiver a cabeça nao tem como ela atingir o proprio corpo
        je inputJogador

        mov cx,[larguraCobra]  ;quantos segmentos vou ter que verificar
        mov bx,2    ;index do array

        colisaoCobra: ;para haver colisao, a Pos X e a Pos Y da cabeça da cobra deve ser igual a Pos X e Pos Y de algum dos segmentos
            mov ax,[cobraX]
            cmp ax,[cobraArrayX+bx] ;verificando se alguma Pos X de algum segmento é igual a da cabeça
            jne proxIndex

            mov ax,[cobraY]
            cmp ax,[cobraArrayY+bx] ;caso a Pos X seja igual, verificamos a Pos Y do segmento atual
            je perdeu ; se posY for igual também, o jogador perdeu

            proxIndex:      ;se pos (x,y) de algum segmento for diferente do (x,y) da cabeça, vamos para o prox segmento
                add bx,2

            dec cx
            cmp cx,0        ;se cx for 0 ja vimos todos os segmentos e podemos sair do loop
            jne colisaoCobra

    inputJogador:      ;indica a proxima direçao da cobra que sera printada no prox loop
    
        mov ah,1       ;verifica se o teclado foi usado
        int 16h
        jz colisaoUva  ;se for 0 indica que nao foi, logo agt pode ir direto checar a uva

        mov ah,0      ; le caractere do teclado e armazena em al
        int 16h

        cmp al,'w'    ;vendo oq o jogador apertou
        je praCima
        cmp al,'a'
        je praEsquerda
        cmp al,'s'
        je praBaixo
        cmp al,'d'
        je praDireita

        jmp colisaoUva ;se nao clicou nada, continua na mesma direçao e vai ver se comeu uma uva

        praCima:               
            mov byte [direcaoAtual],0  ;atualizando direçao atual na memoria de acordo com as teclas
            jmp colisaoUva

        praBaixo:
            mov byte [direcaoAtual],1
            jmp colisaoUva
            
        praEsquerda:
            mov byte [direcaoAtual],2
            jmp colisaoUva
            
        praDireita:
            mov byte [direcaoAtual],3
            jmp colisaoUva

    colisaoUva:         ;para haver colisao (x,y) da head da cobra tem que ser igual a (x,y) da uva
        mov ax,[cobraX]
        cmp ax,[uvaX]
        jne delay ; se nao for igual vamos pra proxima iteraçao

        mov ax,[cobraY]
        cmp ax,[uvaY]
        jne delay  ; se nao for igual vamos pra proxima iteraçao

        ;se chegar aqui é pq houve colisao
        inc word [uvasPegas] ;aumentando o contador de uvas pegas
        mov ax,[larguraCobra]
        cmp ax,5             ;se o cara ja comeu 4 uvas vamos aumentar o nivel, aumentando a cobra de 2 em 2 segmentos a cada uva
        jae aumentandoNivel

        inc word [larguraCobra] ;caso contrario apenas aumentamos a cobra de 1 em 1 segmento a cada uva
        jmp novaPosUva

        aumentandoNivel:
            add word [larguraCobra],2

        comparacaoFinal:
            cmp word [uvasPegas],10 ;se conseguir pegar 10 uvas, vence o jogo, para isso a largura tera que ser igual a 17
            je venceu

    novaPosUva:    ;para proxima uva, precisamos de uma nova posiçao (x,y) aleatoria
        ;Posiçao X
        mov ah,0
        int 1Ah   ;coloca o numero de ticks(18 por segundo) do dia (começando de meia noite) e coloca em CX:DX, cx fica com a primeira metade, dx com a segunda.
        mov ax,dx ;passando a segunda metade para ax
        mov cx, largura; vamos dividir a quantidade da segunda metade de ticks pela largura da tela, o resto(entre 0 e 79) dessa divisao sera a nova posiçao X
        mov dx,0
        div cx ; ax/cx , ax recebera o quociente e dx recebera o resto, por isso precisamos zerar ele antes
        mov word [uvaX],dx ;atualizando na memoria a nova posiçao X da uva

        ;Posiçao Y
        mov ah,0
        int 1Ah   ;coloca o numero de ticks(18 por segundo) do dia (começando de meia noite) e coloca em CX:DX, cx fica com a primeira metade, dx com a segunda.
        mov ax,dx ;passando a segunda metade para ax
        mov cx, altura; vamos dividir a quantidade da segunda metade de ticks pela altura da tela, o resto(entre 0 e 24) dessa divisao sera a nova posiçao Y
        mov dx,0
        div cx ; ax/cx , ax recebera o quociente e dx recebera o resto, por isso precisamos zerar ele antes
        mov word [uvaY],dx ;atualizando na memoria a nova posiçao Y da uva

    delay:              
        printUvasPegas:
            mov ax,0A00h        ;foreground verde

            mov cx,[uvasPegas] ;convertendo o ascii
            add cx,48        

            add ax,cx ;agr ax é da forma 0A[ascii do numero de uvas pegas]h

            mov bx,24
        
            imul di,bx,2*largura ;offset para ultima linha da tela
            
            mov bx,79

            imul dx,bx,2 ;offset para ultima coluna da ultima linha

            add di,dx ;printando na tela
            stosw

        mov cx,[046Ch]   ; 046Ch é um timer da BDA(bios data area),conta cerca de 18 ticks por segundo. 0x046C contem o numero de ticks desde o boot
        add cx,2
        .delay:
            cmp [046Ch],cx  ;basicamente, enquanto o temporizador da bios n tiver aumentado em 2 unidades da medida dele, ficamos no loop
            jl .delay
    
    jmp main

    venceu:
        xor ax,ax
        mov bp,ax
        mov es,ax ;zerando ponteiros para strings

        mov ah,0    ;setando modo de video VGA 320x200
        mov al,13h
        int 10h

        mov ah, 13h ;chamada para printar
		mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
		mov bl, 10 ;cor dos caracteres
		mov dh, 6 ;linha
		mov dl, 2;coluna
		mov cx, 37 ;numero de caracteres
		mov bp, venceuString ;offset da string
        int 10h

        delay3:              ; 046Ch é um timer da BDA(bios data area),conta cerca de 18 ticks por segundo. 0x046C contem o numero de ticks desde o boot
            mov cx,[046Ch]
            add cx,100
            .delay3:
                cmp [046Ch],cx  ;basicamente, enquanto o temporizador da bios n tiver aumentado em 100 unidades da medida dele, ficamos no loop
                jl .delay3

        call endGame

    perdeu:

        delay4:              ; 046Ch é um timer da BDA(bios data area),conta cerca de 18 ticks por segundo. 0x046C contem o numero de ticks desde o boot
            mov cx,[046Ch]
            add cx,30
            .delay4:
                cmp [046Ch],cx  ;basicamente, enquanto o temporizador da bios n tiver aumentado em 30 unidades da medida dele, ficamos no loop
                jl .delay4
        
        xor ax,ax
        mov bp,ax ;ponteiros para string
        mov es,ax
 
        mov ah,0     ;setando modo de video VGA 320x200
        mov al,13h
        int 10h

        mov ah, 13h ;chamada para printar
		mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
		mov bl, 5 ;cor dos caracteres
		mov dh, 3 ;linha
		mov dl, 14;coluna
		mov cx, 12 ;numero de caracteres
		mov bp, perdeuString1 ;offset da string
        int 10h

        mov ah, 13h ;chamada para printar
		mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
		mov bl, 5 ;cor dos caracteres
		mov dh, 8 ;linha
		mov dl, 0;coluna
		mov cx, 40 ;numero de caracteres
		mov bp, perdeuString2 ;offset da string
        int 10h

        mov ah, 13h ;chamada para printar
		mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
		mov bl, 5 ;cor dos caracteres
		mov dh, 11 ;linha
		mov dl, 5;coluna
		mov cx, 28 ;numero de caracteres
		mov bp, perdeuString3 ;offset da string
        int 10h

        mov ah,0  ;lendo a opçao que o jogador quis (tentar de novo ou sair do jogo)
        int 16h

        cmp al,20h ;ascii do espaço
        je resetGame

        cmp al,001Bh  ;ascii do ESC
        je endGame

        delay2:              ; 046Ch é um timer da BDA(bios data area),conta cerca de 18 ticks por segundo. 0x046C contem o numero de ticks desde o boot
            mov cx,[046Ch]
            add cx,120
            .delay2:
                cmp [046Ch],cx  ;basicamente, enquanto o temporizador da bios n tiver aumentado em 120 unidades da medida dele, ficamos no loop
                jl .delay2

        ;se o cara nao clicou em nada nesse meio tempo ou clicou em qualquer outra coisa, vamos pro endgame
        jmp endGame

        resetGame:
            int 19h     ;recarrega o programa

        endGame:
            xor ax,ax

            mov bp,ax ;ponteiros para string
            mov es,ax

            mov ah,0    ;setando modo de video VGA 320x200
            mov al,13h
            int 10h

            mov ah, 13h ;chamada para printar
            mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
            mov bl, 11 ;cor dos caracteres
            mov dh, 4 ;linha
            mov dl, 11;coluna
            mov cx, 14 ;numero de caracteres
            mov bp, stringBy ;offset da string
            int 10h

            mov ah, 13h ;chamada para printar
            mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
            mov bl, 4 ;cor dos caracteres
            mov dh, 8 ;linha
            mov dl, 5;coluna
            mov cx, 27 ;numero de caracteres
            mov bp, stringLaga ;offset da string
            int 10h

            mov ah, 13h ;chamada para printar
            mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
            mov bl, 15 ;cor dos caracteres
            mov dh, 11;linha
            mov dl, 5;coluna
            mov cx, 29 ;numero de caracteres
            mov bp, stringBiel ;offset da string
            int 10h

            mov ah, 13h ;chamada para printar
            mov al, 1 ;tipo de escrita (caracteres diferentes e com cores)
            mov bl, 14 ;cor dos caracteres
            mov dh, 14 ;linha
            mov dl, 5;coluna
            mov cx, 29 ;numero de caracteres
            mov bp, stringDoubo ;offset da string
            int 10h

            delay5:              ; 046Ch é um timer da BDA(bios data area),conta cerca de 18 ticks por segundo. 0x046C contem o numero de ticks desde o boot
            mov cx,[046Ch]
            add cx,130
            .delay5:
                cmp [046Ch],cx  ;basicamente, enquanto o temporizador da bios n tiver aumentado em 130 unidades da medida dele, ficamos no loop
                jl .delay5

            mov ah,0   ;limpando tela
            mov al,13h
            int 10h

            mov eax,1 ;halt (system call de exit)
            int 0x80 
    jmp $