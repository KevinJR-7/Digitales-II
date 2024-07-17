// *********************** 
// Peripherals Unit Module
// *********************** 

module peripherals (clk, reset, enter, inputdata,
						  loaddata, inputdata_ready,
                    dataA, dataB, dataR, 
						  disp3, disp2, disp1, disp0);
	input logic  clk, reset, enter;
	input logic  [7:0] inputdata;
	input logic  loaddata;
	output logic inputdata_ready;
	output logic [31:0] dataA, dataB;
	input logic  [31:0] dataR;
	output logic [6:0] disp3, disp2, disp1, disp0;
	
	// Internal signals and module instantiation for pulse generation
	logic enterPulse;
	logic [3:0] cont; 		// Variable que cuenta las veces que se pulsa el boton
	logic [2:0] contindex;  // indica el segmneto donde se almacenara el valor de los swiches
	logic	[3:0] contaux;		// Me indica el numero que voy a mostrar en el display 0,1,2 o 3
 	logic [3:0] letra;		// indica la letra que se va a mostrar A,B o R
	logic [3:0] Aux0;			// primer segmento a imprimir
	logic [3:0] Aux1;			// Segundo segmento a imprimir
	logic [31:0] numA;
	logic [31:0] numB;
	
	assign contaux = {2'b00,cont[1:0]};	// Contador para imprimir de 0 - 3
	assign dataA = numA;
	assign dataB = numB;

	pulse p0 (enter,clk,reset,enterPulse);
	
	always_ff @(posedge clk, posedge reset) begin
		if (reset)
			cont <= 0;
		else if (enterPulse)
			cont <= cont + 1;
	end
	
	// Process, internal signals and assign statement to control data input indexes and data input ready signals
	always_comb begin
		if (cont < 8 && loaddata)begin
			contindex = cont;
			inputdata_ready = 0;
			if (cont <= 3) begin
				letra = 4'b1010;
			end
			else begin
				letra = 4'b1011;
			end
		end
		else begin
			contindex = 7;
			inputdata_ready = 1;
			letra = 4'b1100;
		end		
	end
	
	// Internal signals and module instantiation for getting operands
	peripheral_getoperands get0 (inputdata,contindex,numA,numB);
	

	// Internal signals, module instantiation and process for showing operands and result
	always_comb begin
	Aux0 = 4'b1111;
	Aux1 = 4'b1111;
		if (loaddata) begin
			case (cont)
				4'b0000: begin 
					Aux0 = numA[3:0];
					Aux1 = numA[7:4];
				end
				4'b0001: begin 
					Aux0 = numA[11:8];
					Aux1 = numA[15:12];
				end
				4'b0010: begin
					Aux0 = numA[19:16];
					Aux1 = numA[23:20];
				end
				4'b0011: begin 
					Aux0 = numA[27:24];
					Aux1 = numA[31:28];
				end
				4'b0100: begin
					Aux0 = numB[3:0];
					Aux1 = numB[7:4];
				end
				4'b0101: begin
					Aux0 = numB[11:8];
					Aux1 = numB[15:12];
				end
				4'b0110: begin
					Aux0 = numB[19:16];
					Aux1 = numB[23:20];
				end
				4'b0111: begin
					Aux0 = numB[27:24];
					Aux1 = numB[31:28];
				end
			endcase
		end 
		else begin
		//32'h7FC00000
			case (contaux)
				4'b0000: begin 
					Aux0 = dataR[3:0];
					Aux1 = dataR[7:4];
				end
				4'b0001: begin 
					Aux0 = dataR[11:8];
					Aux1 = dataR[15:12];
				end
				4'b0010: begin
					Aux0 = dataR[19:16];
					Aux1 = dataR[23:20];
				end
				4'b0011: begin 
					Aux0 = dataR[27:24];
					Aux1 = dataR[31:28];
				end
			endcase		
		end
	end
	
	peripheral_deco7seg dec0 (Aux0, 0,disp0);
	peripheral_deco7seg dec1 (Aux1, 0,disp1);
	peripheral_deco7seg dec2 (contaux, 0, disp2);
	peripheral_deco7seg dec3 (letra, 1, disp3);
	
endmodule
