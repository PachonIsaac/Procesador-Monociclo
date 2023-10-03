module alu(
  input [31:0] x1,
  input [31:0] x2,    
  input [2:0] func_3,//Indica la operacion que se quiere realizar
  input add_sub,	//Indica si se realiza suma o resta
  output reg [31:0] resultado //Resultado de la operación
);

  //Definimos los cables para las diferentes operaciones de la ALU
  wire [31:0] resultado_SUMA;
  wire [31:0] resultado_RESTA;
  wire [31:0] resultado_MENOR_Q;
  wire [31:0] resultado_DESPLAZAMIENTO_IZQ;
  wire [31:0] resultado_DESPLAZAMIENTO_DER;
  wire [31:0] resultado_DESPLAZAMIENTO_ARITMETICO;
  wire [31:0] resultado_OR;
  wire [31:0] resultado_AND;
  wire [31:0] resultado_XOR;
  	
  	
  	// Sumar
    assign resultado_SUMA = x1 + x2;
  	// Restar
    assign resultado_RESTA = x1 - x2;
  	// Menor que 
    assign resultado_MENOR_Q = x1 < x2;
  	// Desplazamiento hacia la izquierda
  	assign resultado_DESPLAZAMIENTO_IZQ = x1 << x2;
	// Desplazamiento hacia la derecha
  	assign resultado_DESPLAZAMIENTO_DER = x1 >> x2;
	// Desplazamiento aritmético hacia la derecha
  	assign resultado_DESPLAZAMIENTO_ARITMETICO = $signed(x1) >>> x2;
	// Logic OR 
    assign resultado_OR = x1 | x2;
  	// Logic AND 
	assign resultado_AND = x1 & x2;
  	// Logic XOR
    assign resultado_XOR = x1 ^ x2; 
  	
  	
  
  //Aqui determinamos que operacion se va  a hacer en funcion de 		func3.

  
  always @(*)
    begin
      case (func_3)
            3'b000:
              if (add_sub)
                    resultado <= resultado_RESTA;
                else
                    resultado <= resultado_SUMA;
          	3'b001:
              resultado <= resultado_MENOR_Q;
              
          	3'b010:
              resultado <= resultado_DESPLAZAMIENTO_IZQ;
          	3'b011:
              if (add_sub)
                   resultado <= resultado_DESPLAZAMIENTO_ARITMETICO;
                else
                    resultado <= resultado_DESPLAZAMIENTO_DER;
         	3'b100:
              resultado <= resultado_OR;
              
          	3'b101:
              resultado <= resultado_AND;
          	3'b110:
              resultado <= resultado_XOR;
              
        endcase
    end

endmodule