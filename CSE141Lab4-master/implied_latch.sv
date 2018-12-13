always_comb case(sel)
  2'b00: output = 5;
  2'b01: output = 10;
  default: output = 0; 

endcase


always_comb 
  if(sel==2'b00) output = 5;
  else if(sel==2'b01) output = 10;
  else output = 0; 
