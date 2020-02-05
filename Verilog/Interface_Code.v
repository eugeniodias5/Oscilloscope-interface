module Projeto_lcd
(
	clk,	reset, enter, cima, esquerda, switch1,
	enable, rs, rw,
	data, on
);

	input clk, enter, reset, cima, esquerda, switch1;
	output reg enable, rs, rw, on;
	output reg [7:0]data;
	// Declare state register
	reg		[6:0]state;
	reg		[6:0]nstate;
	reg [16:0]counter;
	reg [2:0]counter2;
	reg clk_100hz;
	reg [1:0]controle;
	//Variáveis para guardar o valor de cada bit no menu de escolha da frequência
	reg bit1;//O primeiro bit só pode assumir 0 ou 1, já que a frequência máxima é 10MHz		
	reg [3:0]bit2;
	reg [3:0]bit3;
	reg [3:0]bit4;
	reg [3:0]bit5;
	reg [3:0]bit6;
	reg [3:0]bit7;
	reg [3:0]bit8;
	reg [3:0]bit_atual;
	
	wire baixo, direita; 
	assign baixo = (~switch1 || cima); //Baixo é 0 quando switch é levantado e cima pressionado
	assign direita = (~switch1 || esquerda); //direita é 0 quando switch é levantado e cima pressionado
	
	wire esq, dir, baix, cim;
	assign cim = (!cima && baixo); 
	assign dir = (!direita && !esquerda);
	assign baix = (!baixo && !cima);
	assign esq = (!esquerda && direita);//Assigns feitos para não serem ativos ao mesmo tempo 
	
	// Declare states
	parameter power_on = 0, function_set = 1, function_set1 = 2, function_set2 = 3,
				function_set3 = 4,display_off = 5,display_clear = 6, display_on=7,
				entry_mode_set=8, write0 = 9, write1 = 10, write2 = 11, write3 = 12, 
				write4 = 13, write5 = 14, write6 = 15, write7 = 16, write8 = 17, 
				write9 = 18, write10 = 19, write11 = 20, write12 = 21, set_line2 = 22, 
				write13 = 23, write14 = 24, write15 = 25, write16 = 26, write17 = 27, 
				write18 = 28, write19 = 29, write20 = 30, write21 = 31, menu_1 = 32,
				display_clear2 = 33, write22 = 34, write23 = 35, write24 = 36, 
				write25 = 37, write26 = 38, write27 = 39, write28 = 40, write29 = 41,
				write30 = 42, write31 = 43, write32 = 44, set_line2_2 = 45, 
				write33 = 46, write34 = 47, write35 = 48, write36 = 49, write37 = 50,
				write38 = 51, write39 = 52, write40 = 53, menu_2 = 54, remove = 55, 
				set_line2_3 = 56, write41 = 57, display_clear3 = 58, write42 = 59, 
				write43 = 60, write44 = 61, write45 = 62, write46 = 63, write47 = 64,
				write48 = 65, write49 = 66, write50 = 67, write51 = 68, write52 = 69,
				write53 = 70, set_line2_4 = 71, write54 = 72, write55 = 73,
				write56 = 74, write57 = 75, write58 = 76, primeira_posicao = 77, 
				segunda_posicao = 78, terceira_posicao = 79, quarta_posicao = 80, 
				quinta_posicao = 81, sexta_posicao = 82, setima_posicao = 83, 
				oitava_posicao = 84, incrementar = 85, decrementar = 86, next = 87, 
				display_clear4 = 88, write59 = 89, write60 = 90, write61 = 91, write62 = 92,
				write63 = 93, write64 = 94, write65 = 95, write66 = 96, write67 = 97, 
				write68 = 98, write69 = 99, write70 = 100, write71 = 101, hold = 102
;


	
		
	 always @ (posedge clk or negedge reset) begin
		if(!reset)
		begin
		counter <= 17'h0000;
		clk_100hz <= 1'b0;
		end
		
		else if(counter < 17'd125000) //Uso de um contador para reduzir a frequência
	 begin									 //do clock
	 counter <= counter + 1'b1;
	 end
	 
	 else
	 begin
	 counter <= 17'h00000;
	 clk_100hz <= ~clk_100hz;
		end
		end
	 
	 
	// Determine the next state
	always @ (posedge clk_100hz or negedge reset) begin
	if(!reset)
		begin
			state <= power_on;
			end
			
			else
			begin
			case (state)	
				power_on:
				begin
					state <= next;
					nstate <= function_set; //Inicio
					end
					
				next:	//Indica o próximo estado
				begin
				if((cim)||(baix)||(dir)||(esq)) //Impede que um botão seja lido duas 
				state <= next;							//ou mais vezes
				
				else
				begin
				enable <= 1'b0; //Alternância do enable
				on <= 1'b1;		//Liga LCD	
				state <= nstate;
				end
				end
			
			//====================INICIALIZAÇÃO==================================
				function_set:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00111000;
					state <= next;
					nstate <= function_set1;
					end
					
				function_set1:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00111000;
					state <= next;
					nstate <= function_set2;
				end
				
				function_set2:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00111000;
					state <= next;
					nstate <= function_set3;
				end
				
				function_set3:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00111000;
					state <= next;
					nstate <= display_off;
					end
					
				display_off:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00001000;
					state <= next;
					nstate <= display_clear;
				end
				
				display_clear:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00000001;
					state <= next;
					nstate <= display_on;
					end
					
				display_on:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00001100;
					state <= next;
					nstate <= entry_mode_set;
					end
					
				entry_mode_set:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00000110;
					state <= next;
					nstate <= write0;
					end
			//========================FIM DA INICIALIZAÇÃO======================
					
			//Escreve "Tipo de onda:"
			//">Quadrada"	
				write0:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h54; //T
					state <= next;
					nstate <= write1;
				end
				
				write1:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h69; //i
					state <= next;
					nstate <= write2;
				end
				
				write2:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h70; //p
					state <= next;
					nstate <= write3;
				end
				
				write3:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6F; //O
					state <= next;
					nstate <= write4;
				end
				
				write4:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h20; //Space
					state <= next;
					nstate <= write5;
				end
				
				write5:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h64; //d
					state <= next;
					nstate <= write6;
				end
					
				write6:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h65; //e
					state <= next;
					nstate <= write7;
					
				end
				
				write7:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h20; //space
					state <= next;
					nstate <= write8;
				end
					
					write8:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6F; //O
					state <= next;
					nstate <= write9;
					
				end
				
				write9:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6E; //n
					state <= next;
					nstate <= write10;
				end
				
				write10:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h64; //d
					state <= next;
					nstate <= write11;
				end
				
				write11:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write12;
				end
				
				write12:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h3A; //:
					state <= next;
					nstate <= set_line2;
				end
				
				set_line2:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000000; //Pula para linha 2
					state <= next;
					nstate <= write13;
				end
				
				write13:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h3E; //>
					state <= next;
					nstate <= write14;
				end
				
				write14:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h51; //Q
					state <= next;
					nstate <= write15;
				end
				
				write15:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h75; //u
					state <= next;
					nstate <= write16;
				end
				
				write16:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write17;
				end
				
				write17:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h64; //d
					state <= next;
					nstate <= write18;
				end
					
				write18:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h72; //r
					state <= next;
					nstate <= write19;
					
				end
				
				write19:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write20;
				end
					
					write20:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h64; //d
					state <= next;
					nstate <= write21;
					
				end
				
				write21:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= menu_1;
				end
				
				
				menu_1: //Menu para alternar seleção
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'h80; //Return home
					if(baix) //Alterna a seleção
					begin
					state <= next;
					nstate <= display_clear2;
					controle <= 2'd0;
					end
					else if(!enter)
					begin
					state <= next;
					nstate <= display_clear3;
					end
					else
					state <= menu_1;
				end
					
		//Escreve ">Triangular"
		//			 " Senoidal" 		
				display_clear2:
					begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00000001;
					state <= next;
					nstate <= write22;
					end
				
				write22:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h3E; //>
					state <= next;
					nstate <= write23;
				end
				
				write23:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h54; //T
					state <= next;
					nstate <= write24;
				end
				
				write24:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h72; //r
					state <= next;
					nstate <= write25;
				end
				
				write25:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h69; //i
					state <= next;
					nstate <= write26;
				end
				
				write26:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write27;
				end
					
				write27:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6E; //n
					state <= next;
					nstate <= write28;
					
				end
				
				write28:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h67; //g
					state <= next;
					nstate <= write29;
				end
					
					write29:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h75; //u
					state <= next;
					nstate <= write30;
					
				end
				
				write30:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6C; //l
					state <= next;
					nstate <= write31;
				end
				
				write31:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write32;
					
				end
				
				write32:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h72; //r
					state <= next;
					nstate <= set_line2_2;
				end				
	
				set_line2_2:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000001; //Pula para linha 2, segunda coluna
					state <= next;
					nstate <= write33;
				end
				
				write33:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h53; //S
					state <= next;
					nstate <= write34;
				end
				
				write34:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h65; //e
					state <= next;
					nstate <= write35;
				end
				
				write35:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6E; //n
					state <= next;
					nstate <= write36;
				end
				
				write36:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6F; //O
					state <= next;
					nstate <= write37;
				end
					
				write37:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h69; //i
					state <= next;
					nstate <= write38;
					
				end
				
				write38:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h64; //d
					state <= next;
					nstate <= write39;
				end
					
					write39:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write40;
					
				end
				
				write40:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6C; //l
					state <= next;
					nstate <= menu_2;
				end
				
				
				//---------------------- Primeiro menu ------------------------------------
				menu_2:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b10000000; //Return home
					
				if(cim)
				begin
				if(controle == 2'd0)//Se controle = 0, significa que a seleção '>' 
											//está em "triangular"
				begin            
				state <= next;	  
				nstate <= display_clear; //Volta a primeira seleção
				end
				else if(controle == 2'd1) //Se controle = 1, significa que
				begin								//a seleção '>' está em "Senoidal"
				data <= 8'b11000000; //Pula para linha 2, primeira coluna para limpar '>'
				state <= next;
				nstate <= remove;
				end
				end
				
				else if(baix) //Seleção vai para ">Senoidal"
				begin
				state <= next;
				nstate <= remove;
				controle <= 2'd2; //Controle = 2 significa que baixo foi pressionado
				
				end
				
				else if(!enter) // Passar para a seleção da frequência
				begin
				state <= next;
				nstate <= display_clear3;
				end
				
				else
				state <= menu_2;
				end
				
				remove:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h20; //Limpa o caractere '>'
					state <= next;
					nstate <= set_line2_3;
				end	
				
				set_line2_3:
				begin
				if(controle == 2'd1)
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b10000000; //Linha 1, primeira coluna
					controle <= 2'd0; // Seletor '>' voltará para onda triangular 
					state <= next;
					nstate <= write41;
					end
				else if(controle == 2'd2)
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000000; //Seletor '>' irá para linha 2, primeira coluna
					controle <= 2'd1; //O controle retorna a 1 pois baixo deixou de ser
					state <= next;		//pressionado
					nstate <= write41;
					end
				end
				
				write41:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h3E; //Escreve o seletor '>'
					state <= next;
					nstate <= menu_2;
				end
				
				display_clear3:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00000001;
					state <= next;
					nstate <= write42;
					end
					
				//=====================SELEÇÃO DA FREQUÊNCIA===========================
				//Tela: "Frequencia:     "
				//		  "00000001 Hz     " 
				write42:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h46; //F
					state <= next;
					nstate <= write43;
				end
				
				write43:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h72; //r
					state <= next;
					nstate <= write45;
				end
				
				write45:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h65; //e
					state <= next;
					nstate <= write46;
				end
				
				write46:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h71; //q
					state <= next;
					nstate <= write47;
				end
				
				write47:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h75; //u
					state <= next;
					nstate <= write48;
				end
				
				write48:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h65; //e
					state <= next;
					nstate <= write49;
				end
					
				write49:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6E; //n
					state <= next;
					nstate <= write50;
					
				end
				
				write50:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h63; //c
					state <= next;
					nstate <= write51;
				end
					
					write51:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h69; //i
					state <= next;
					nstate <= write52;
					
				end
				
				write52:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write53;
				end
				
				write53:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h3A; //:
					state <= next;
					nstate <= set_line2_4;
				end
				
				set_line2_4:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000000; //Pula para linha 2
					state <= next;
					nstate <= write54;
				end
				
				
				write54:
				begin
					if(counter2 < 3'd7) //Escrever 7 zeros
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h30; //0
					counter2 <= counter2 + 1'd1;
					state <= next;
					nstate <= write54;
					end
					else
					begin
					counter2 <= 3'd0;
					bit1 <= 1'd0;
					bit2 <= 1'd0;
					bit3 <= 1'd0;
					bit4 <= 1'd0;
					bit5 <= 1'd0;
					bit6 <= 1'd0;
					bit7 <= 1'd0;
					state <= next;
					nstate <= write55;
					end
				end
				
					write55:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h31; //1
					bit8 <= 4'd1; //Último bit começa em 1;
					state <= next;
					nstate <= write56;
				end
				
				write56:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h20; //Space
					state <= next;
					nstate <= write57;
				end
				
				write57:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h48; //H
					state <= next;
					nstate <= write58;
				end
				
				write58:
				begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h7A; //z
					state <= next;
					nstate <= primeira_posicao;
				end
				
				primeira_posicao://Bit mais significativo
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000000; //Endereço do primeiro número
					bit_atual <= 4'd1;
				if(dir) //Passa pra segunda posição
				begin
				state <= next;
				nstate <= segunda_posicao;
				end
				else if(cim || baix) //O primeiro bit só pode ser 0 ou 1, portanto,
				begin						//Sua lógica foi toda feita no estado incrementar
				state <= next;
				nstate <= incrementar;
				end
				else if(esq) //Vai para oitava posição
				begin
				state <= next;
				nstate <= oitava_posicao;
				end
				else if(!enter) //Vai para próxima tela
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= primeira_posicao;
				end
				
				segunda_posicao:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000001; //Endereço do segundo número
					bit_atual <= 4'd2; 
				if(baix)
				begin
				bit2 <= bit2 - 1'b1;
				state <= next;
				nstate <= decrementar;
				end
				else if(cim)
				begin
				bit2<=bit2 + 1'b1;
				state <= next;
				nstate <= incrementar;
				end
				else if(dir)
				begin
				state <= next;
				nstate <= terceira_posicao;
				end
				else if(esq)
				begin
				state <= next;
				nstate <= primeira_posicao;
				end
				else if(!enter)
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= segunda_posicao;
				end
				
					terceira_posicao:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000010; //Endereço do terceiro número
					bit_atual <= 4'd3; 
				if(cim)
				begin
				bit3 <= bit3 + 1'b1;
				state <= next;
				nstate <= incrementar;
				end
				else if(baix)
				begin
				bit3 <= bit3 - 1'b1;
				state <= next;
				nstate <= decrementar;
				end
				else if(dir)
				begin
				state <= next;
				nstate <= quarta_posicao;
				end
				else if(esq)
				begin
				state <= next;
				nstate <= segunda_posicao;
				end
				else if(!enter)
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= terceira_posicao;
				end
				
				quarta_posicao:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000011; //Endereço do quarto número
					bit_atual <= 4'd4; 
				if(cim)
				begin
				bit4 <= bit4 + 1'b1;
				state <= next;
				nstate <= incrementar;
				end
				else if(baix)
				begin
				bit4 <= bit4 - 1'b1;
				state <= next;
				nstate <= decrementar;
				end
				else if(dir)
				begin
				state <= next;
				nstate <= quinta_posicao;
				end
				else if(esq)
				begin
				state <= next;
				nstate <= terceira_posicao;
				end
				else if(!enter)
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= quarta_posicao;
				end
				
				quinta_posicao:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000100; //Endereço do quinto número
					bit_atual <= 4'd5; 
				if(cim)
				begin
				bit5 <= bit5 + 1'b1;
				state <= next;
				nstate <= incrementar;
				end
				else if(baix)
				begin
				bit5 <= bit5 - 1'b1;
				state <= next;
				nstate <= decrementar;
				end
				else if(dir)
				begin
				state <= next;
				nstate <= sexta_posicao;
				end
				else if(esq)
				begin
				state <= next;
				nstate <= quarta_posicao;
				end
				else if(!enter)
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= quinta_posicao;
				end
				
				sexta_posicao:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000101; //Endereço do sexto número
					bit_atual <= 4'd6; 
				if(cim)
				begin
				bit6 <= bit6 + 1'b1;
				state <= next;
				nstate <= incrementar;
				end
				else if(baix)
				begin
				bit6 <= bit6 - 1'b1;
				state <= next;
				nstate <= decrementar;
				end
				else if(dir)
				begin
				state <= next;
				nstate <= setima_posicao;
				end
				else if(esq)
				begin
				state <= next;
				nstate <= quinta_posicao;
				end
				else if(!enter)
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= sexta_posicao;
				end
				
				setima_posicao:
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000110; //Endereço do sétimo número
					bit_atual <= 4'd7; 
				if(cim)
				begin
				bit7 <= bit7 + 1'b1;
				state <= next;
				nstate <= incrementar;
				end
				else if(baix)
				begin
				bit7 <= bit7 - 1'b1;
				state <= next;
				nstate <= decrementar;
				end
				else if(dir)
				begin
				state <= next;
				nstate <= oitava_posicao;
				end
				else if(esq)
				begin
				state <= next;
				nstate <= sexta_posicao;
				end
				else if(!enter)
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= setima_posicao;
				end
				
				oitava_posicao: //Bit menos significativo
				begin
				enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b11000111; //Endereço do oitavo número
					bit_atual <= 4'd8; 
				if(cim)
				begin
				bit8 <= bit8 + 1'b1;
				state <= next;
				nstate <= incrementar;
				end
				else if(baix)
				begin
				bit8 <= bit8 - 1'b1;
				state <= next;
				nstate <= decrementar;
				end
				else if(dir)
				begin
				state <= next;
				nstate <= primeira_posicao;
				end
				else if(esq)
				begin
				state <= next;
				nstate <= setima_posicao;
				end
				else if(!enter)
				begin
				state <= next;
				nstate <= display_clear4;
				end
				else
				state <= oitava_posicao;
				end
				
				incrementar:
				begin
				enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
				case(bit_atual)
				4'd1:	//Primeira posição
				begin
				if(bit1 == 1'b0)
				begin
				data <= 8'h31; //Escreve 1 se está escrito 0
				bit1 = 1'b1; // Bit1 agora é 1
				end
				else
				begin
				data <= 8'h30; //Escreve 0 se está escrito 1
				bit1 = 1'b0; // Bit1 agora é 0
				end 
				state <= next;
				nstate <= primeira_posicao;
				end
				
				4'd2: //Segunda posição
				begin
				data <= {4'h3, bit2}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit2 == 4'd10) //	Se o bit for igual a 10, escreve 0
				begin
				bit2 <= 4'd0; 
				data <= 8'h30;
				end
				state <= next;
				nstate <= segunda_posicao;
				end
				
				4'd3: //Terceira posição
				begin
				data <= {4'h3, bit3}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit3 == 4'd10) //	Se o bit for igual a 10, escreve 0
				begin
				bit3 <= 4'd0; 
				data <= 8'h30;
				end
				state <= next;
				nstate <= terceira_posicao;
				end
				
				4'd4: //Quarta posição
				begin
				data <= {4'h3, bit4}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit4 == 4'd10) //	Se o bit for igual a 10, escreve 0
				begin
				bit4 <= 4'd0; 
				data <= 8'h30;
				end
				state <= next;
				nstate <= quarta_posicao;
				end
				
				4'd5: //Quinta posição
				begin
				
				data <= {4'h3, bit5}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit5 == 4'd10) //	Se o bit for igual a 10, escreve 0
				begin
				bit5 <= 4'd0; 
				data <= 8'h30;
				end
				state <= next;
				nstate <= quinta_posicao;
				end
				
				4'd6: //Sexta posição
				begin
				data <= {4'h3, bit6}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit6 == 4'd10) //	Se o bit for igual a 10, escreve 0
				begin
				bit6 <= 4'd0; 
				data <= 8'h30;
				end
				state <= next;
				nstate <= sexta_posicao;
				end
				
				4'd7: //Sétima posição
				begin
				data <= {4'h3, bit7}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit7 == 4'd10) //	Se o bit for igual a 10, escreve 0
				begin
				bit7 <= 4'd0; 
				data <= 8'h30;
				end
				state <= next;
				nstate <= setima_posicao;
				end
				
				4'd8: //Oitava posição
				begin
				data <= {4'h3, bit8}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit8 == 4'd10) //	Se o bit for igual a 10, escreve 0
				begin
				bit8 <= 4'd0; 
				data <= 8'h30;
				end
				state <= next;
				nstate <= oitava_posicao;
				end
				
				endcase
				end
				
				
				decrementar:
				begin
				enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
				case(bit_atual)
				4'd2:	//Segunda posição			
				begin
				data <= {4'h3, bit2}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit2 == -4'd1)//Bit não pode ser -1 e vai pra 9
				begin
				bit2 <= 4'd9;
				data <= 8'h39;//Escreve 9
				end
				state <= next;
				nstate <= segunda_posicao;
				end
				
				4'd3:	//Terceira posição			
				begin
				data <= {4'h3, bit3}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit3 == -4'd1)//Bit não pode ser -1 e vai pra 9
				begin
				bit3 <= 4'd9;
				data <= 8'h39;//Escreve 9
				end
				state <= next;
				nstate <= terceira_posicao;
				end
				
				4'd4:	//Quarta posição			
				begin
				data <= {4'h3, bit4}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit4 == -4'd1)//Bit não pode ser -1 e vai pra 9
				begin
				bit4 <= 4'd9;
				data <= 8'h39;//Escreve 9
				end
				state <= next;
				nstate <= quarta_posicao;
				end
				
				4'd5:	//Quinta posição			
				begin
				data <= {4'h3, bit5}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit5 == -4'd1)//Bit não pode ser -1 e vai pra 9
				begin
				bit5 <= 4'd9;
				data <= 8'h39;//Escreve 9
				end
				state <= next;
				nstate <= quinta_posicao;
				end
				
				4'd6:	//Sexta posição			
				begin
				data <= {4'h3, bit6}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit6 == -4'd1)//Bit não pode ser -1 e vai pra 9
				begin
				bit6 <= 4'd9;
				data <= 8'h39;//Escreve 9
				end
				state <= next;
				nstate <= sexta_posicao;
				end
				
				4'd7:	//Sétima posição			
				begin
				data <= {4'h3, bit7}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit7 == -4'd1)//Bit não pode ser -1 e vai pra 9
				begin
				bit7 <= 4'd9;
				data <= 8'h39;//Escreve 9
				end
				state <= next;
				nstate <= setima_posicao;
				end
				
				4'd8:	//Oitava posição			
				begin
				data <= {4'h3, bit8}; //Será escrito o resultado de 0 mais o valor da soma 
				if(bit8 == -4'd1)//Bit não pode ser -1 e vai pra 9
				begin
				bit8 <= 4'd9;
				data <= 8'h39;//Escreve 9
				end
				state <= next;
				nstate <= oitava_posicao;
				end
				endcase
				end
				
			//==================Escreve "Executando..."==========================	
				display_clear4:
				begin
					enable <= 1'b1;
					rs <= 1'b0;
					rw <= 1'b0;
					data <= 8'b00000001;
					state <= next;
					nstate <= write59;
					end
					
				write59:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h45; //E
					state <= next;
					nstate <= write60;
				end
				
				write60:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h78; //x
					state <= next;
					nstate <= write61;
				end
				
				write61:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h65; //e
					state <= next;
					nstate <= write62;
				end
				
				write62:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h63; //c
					state <= next;
					nstate <= write63;
				end
			
				write63:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h75; //u
					state <= next;
					nstate <= write64;
				end
				
				write64:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h74; //t
					state <= next;
					nstate <= write65;
				end
			
			write65:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h61; //a
					state <= next;
					nstate <= write66;
				end
			
			write66:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h6E; //n
					state <= next;
					nstate <= write67;
				end
				
			write67:	
					begin
					enable <= 1'b1;
					rs <= 1'b1;
					rw <= 1'b0;
					data <= 8'h64; //d
					state <= next;
					nstate <= write68;
				end
				
		write68:	
			begin
			enable <= 1'b1;
			rs <= 1'b1;
			rw <= 1'b0;
			data <= 8'h6F; //o
			state <= next;
			nstate <= write69;
		end
		
		write69:	
			begin
			enable <= 1'b1;
			rs <= 1'b1;
			rw <= 1'b0;
			data <= 8'h2E; //.
			state <= next;
			nstate <= write70;
			end
	
		write70:	
			begin
			enable <= 1'b1;
			rs <= 1'b1;
			rw <= 1'b0;
			data <= 8'h2E; //.
			state <= next;
			nstate <= write71;
			end	
			
		write71:	
			begin
			enable <= 1'b1;
			rs <= 1'b1;
			rw <= 1'b0;
			data <= 8'h2E; //.
			state <= next;
			nstate <= hold;
			end
			
		hold:	//Espera pelo reset para reiniciar
			begin
			state<=hold;
			enable <= 1'b1;
			rs <= 1'b0;
			rw <= 1'b0;
			data <= 8'h80;
		end
		
			endcase
			end
		end
endmodule