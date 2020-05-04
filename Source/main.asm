		; PROJE		- Odev2
		; YAZAR		- Burak YAZAN
		; TARIH		- MAYIS 2020
		
		ORG 0H 		; 0H adresine konuslan
		SJMP ANA	; ANA etiketine dallan
		
		ORG 0BH		; TIMER0 kesme alanina konuslan
KESME_T:LJMP ISLEM 	; ISLEM etiketine uzun dallanma yap
		
		ORG 30H				; 30H adresine konuslan
ANA:	SETB P1.0			; P1 i giris olarak ayarla
		MOV TMOD,#01H		; TMOD 1 olarak ayarla
		MOV IE,#82H			; Kesme yetkilendirme ayarla

TEMIZLE:MOV P3,#0			; P3 e 0 degerini tasi - sifirlama islemi
		MOV R4,#20			; R4 e 20 degerini tasi
		MOV TH0,#HIGH(15536); 50000 saymak icin yuksek tarafi ayarla
		MOV TL0,#LOW(15536) ; 50000 saymak icin dusuk tarafi ayarla

BASLA:	CLR A				; A yi temizle
		MOV DPTR,#008FH		; DPTR 8FH adresini tasi
		MOV R7, #80H		; R7 e 80H adresini tasi
		MOV P0,R7			; P0 portuna R7deki degeri tasi
		CLR TR0				; TR0 i sifirla
		JB P1.0, TEMIZLE	; P1 1 degerindeyse TEMIZLE etiketine dallan
		SETB TR0			; saymayi baslat
		
CALIS:	JB P3.0,SONUK 	; P3.0 1e esitse SONUK etiketine dallan
		MOV R6,A 		; A degerini R6 ya at
		MOV A,R7 		; R7 deki degeri A ya aktar
		RL A 			; A yi sola dondur
		MOV R7,A		; A nin degerini R7 e at
		MOV A,R6 		; R6 daki degeri tekrar A ya al
		MOV P0,R7 		; P0 portuna R7 yi tasi

SONUK:	CALL SAY 		; SAY alt programini çagir
		MOV P2,A 		; A daki degeri P2'ye aktar
		MOV A,R2 		; R2 deki degeri aküye aktar
		CALL GECIKME 	; GECIKME alt programini çagir
		CJNE A,#4,CALIS ; A 4 olmadiysa CALIS etiketine dallan
		SJMP BASLA 		; BASLA etiketine dallan

GECIKME:MOV R0,#10		; R0 a 10 degerini tasi
		MOV R1,#10		; R1 e 10 degerini tasi
BEKLE:	DJNZ R0,BEKLE 	; R0 i 1 azalt 0 degilse BEKLE etiketine dallan
		MOV R0,#10		; R0 a 10 degerini tasi
		DJNZ R1,BEKLE 	; R1 i 1 azalt 0 degilse BEKLE etiketine dallan
		RET 			; alt programdan dön

SAY:	INC A 			; A daki degeri 1 arttir
		MOV R2,A 		; Tablo dizisinin indis degerini R2'ye yükle
		MOVC A,@A+DPTR	; akü ile DPTR'yi topla ilgili adresteki degeri A ya at
		RET

		ORG 90h 									; 90H adresine konuslan
TABLO:	DB 1111100B, 1101110B, 0000110B, 1111100B 	; B Y 1 B karakterlerinin 7 segment uzerinde sirali karsiliklari

		ORG 120H			; 120H adresine konuslan
ISLEM: 	DJNZ R4,DEVAM		; R4 u bir azalt 0 degilse DEVAM etiketine dallan
		CLR TF0				; Timer flag -TF0- temizle
		CPL P3.0			; P3.0 i tersle
		MOV R4,#20			; R4 u tekrar 20 olarak ayarla
		MOV TH0,#HIGH(15536); 50000 saymak icin yuksek tarafi ayarla
		MOV TL0,#LOW(15536)	; 50000 saymak icin dusuk tarafi ayarla
		RETI				; kesmeden donus yap
		
		ORG 140H			; 140H adresine konuslan
DEVAM:  CLR TF0				; Timer flag -TF0- temizle
		MOV TH0,#HIGH(15536); 50000 saymak icin yuksek tarafi ayarla
		MOV TL0,#LOW(15536) ; 50000 saymak icin dusuk tarafi ayarla
		RETI				; kesmeden donus yap
		
		END					; programi bitir